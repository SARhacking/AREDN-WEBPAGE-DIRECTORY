#!/usr/bin/env python3
"""
Auto-update script for BBS listings from telnetbbsguide.com
Fetches latest BBSes and updates index.html automatically
"""

import urllib.request
import re
import json
import os
from datetime import datetime
from html import unescape

# Configuration
TELNETBBSGUIDE_URL = "https://www.telnetbbsguide.com/bbs/"
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INDEX_FILE = os.path.join(SCRIPT_DIR, "index.html")
LOG_FILE = os.path.join(SCRIPT_DIR, "bbs_update.log")

def log_message(message):
    """Log messages with timestamps"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] {message}"
    print(log_entry)
    
    try:
        with open(LOG_FILE, 'a') as f:
            f.write(log_entry + "\n")
    except Exception as e:
        print(f"Warning: Could not write to log file: {e}")

def fetch_bbs_list():
    """Fetch and parse BBS list from telnetbbsguide.com"""
    log_message("Fetching BBS list from telnetbbsguide.com...")
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
    }
    
    try:
        req = urllib.request.Request(TELNETBBSGUIDE_URL, headers=headers)
        with urllib.request.urlopen(req, timeout=15) as response:
            html = response.read().decode('utf-8')
        
        log_message("Successfully downloaded telnetbbsguide.com")
        return html
    
    except Exception as e:
        log_message(f"ERROR: Failed to fetch telnetbbsguide.com: {e}")
        return None

def parse_bbs_entries(html):
    """Parse BBS entries from HTML"""
    bbs_list = []
    
    # Find all h3 headings (BBS names)
    for match in re.finditer(r'<h3[^>]*>([^<]+)</h3>', html):
        name = match.group(1).strip()
        
        # Skip invalid entries
        if not name or name.startswith('+') or len(name) < 3 or name in ['Filter', 'Archives']:
            continue
        
        # Decode HTML entities
        name = unescape(name)
        
        # Get next 3000 characters for telnet link
        pos = match.end()
        section = html[pos:pos+3000]
        
        # Find telnet link
        telnet_match = re.search(r'href="telnet://([^:"]+):(\d+)"', section)
        if not telnet_match:
            telnet_match = re.search(r'telnet://([^:"]+):(\d+)', section)
        
        if telnet_match:
            address = telnet_match.group(1)
            port = int(telnet_match.group(2))
            
            bbs_list.append({
                'name': name,
                'address': address,
                'port': port,
                'type': 'bulletin',
                'location': 'Imported',
                'description': 'BBS from telnetbbsguide.com',
                'status': 'online',
                'tags': ['telnetbbsguide', 'imported'],
                'sysop': 'telnetbbsguide.com'
            })
    
    return bbs_list

def format_bbs_entries(bbs_list):
    """Format BBS entries as JavaScript code"""
    output = ""
    for bbs in bbs_list:
        entry_str = json.dumps(bbs, indent=16)
        # Add proper indentation
        entry_str = '\n'.join('            ' + line for line in entry_str.split('\n'))
        output += entry_str + ',\n'
    
    return output

def update_index_html(bbs_entries_text):
    """Update index.html with new BBS entries"""
    log_message(f"Updating index.html with new entries...")
    
    try:
        with open(INDEX_FILE, 'r') as f:
            html_content = f.read()
        
        # Find the section to replace
        # Pattern: last BBS entry ending with Floodgap, followed by ];
        old_pattern = '''                sysop: "Floodgap"
            },
            // BBSes scraped from telnetbbsguide.com
'''
        
        # Find start and end of imported section
        start_marker = old_pattern
        end_marker = '        ];'
        
        start_idx = html_content.find(start_marker)
        if start_idx == -1:
            log_message("ERROR: Could not find start marker in index.html")
            return False
        
        # Find the end marker after the start
        end_idx = html_content.find(end_marker, start_idx)
        if end_idx == -1:
            log_message("ERROR: Could not find end marker in index.html")
            return False
        
        # Build replacement
        new_section = start_marker + bbs_entries_text
        
        # Replace
        new_html = html_content[:start_idx] + new_section + end_marker + html_content[end_idx + len(end_marker):]
        
        # Verify the file looks good before writing
        if new_html.count('<h1>') != html_content.count('<h1>'):
            log_message("ERROR: HTML structure might be corrupted")
            return False
        
        # Write back
        with open(INDEX_FILE, 'w') as f:
            f.write(new_html)
        
        log_message("Successfully updated index.html")
        return True
    
    except Exception as e:
        log_message(f"ERROR: Failed to update index.html: {e}")
        return False

def main():
    """Main update routine"""
    log_message("=" * 60)
    log_message("Starting BBS list auto-update")
    
    # Fetch latest data
    html = fetch_bbs_list()
    if not html:
        log_message("FAILED: Could not fetch BBS list")
        return False
    
    # Parse entries
    bbs_list = parse_bbs_entries(html)
    
    if not bbs_list:
        log_message("WARNING: No BBSes found")
        return False
    
    log_message(f"Found {len(bbs_list)} BBSes from telnetbbsguide.com")
    
    # Format entries
    bbs_entries_text = format_bbs_entries(bbs_list)
    
    # Update HTML
    success = update_index_html(bbs_entries_text)
    
    if success:
        log_message(f"SUCCESS: Updated with {len(bbs_list)} BBSes")
    
    log_message("Update process completed")
    log_message("=" * 60)
    
    return success

if __name__ == '__main__':
    main()
