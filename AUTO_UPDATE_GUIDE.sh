#!/usr/bin/env bash
# Quick reference guide for BBS Auto-Update

# ============================================================================
# SETUP INSTRUCTIONS
# ============================================================================

# 1. AUTOMATIC SETUP (Recommended)
# Run this and follow the prompts:
./setup_autoupdate.sh

# 2. MANUAL SETUP
# Edit your crontab:
crontab -e

# Then add one of these lines (change path as needed):

# Update every 6 hours (recommended for most use cases):
0 */6 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# Update every 12 hours (less frequent):
0 */12 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# Update daily at 2 AM (once per day):
0 2 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# Update every 3 days (less frequent):
0 0 */3 * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# ============================================================================
# MANAGE YOUR CRON JOB
# ============================================================================

# View your current cron jobs:
crontab -l

# Remove all cron jobs:
crontab -r

# Edit cron jobs:
crontab -e

# ============================================================================
# MONITOR UPDATES
# ============================================================================

# View all updates:
cat bbs_update.log

# View only successful updates:
grep SUCCESS bbs_update.log

# View only errors:
grep ERROR bbs_update.log

# Watch log in real-time:
tail -f bbs_update.log

# Count number of updates:
grep "SUCCESS:" bbs_update.log | wc -l

# ============================================================================
# MANUAL UPDATES
# ============================================================================

# Run update immediately (useful for testing):
./update_bbs_list.py

# Or with python3 explicitly:
python3 update_bbs_list.py

# ============================================================================
# TROUBLESHOOTING
# ============================================================================

# Check if Python 3 is installed:
which python3

# Check if the update script is executable:
ls -l update_bbs_list.py
# Should show: -rwxrwxrwx ... update_bbs_list.py

# Run update with verbose output:
python3 -u update_bbs_list.py

# Check cron job is running by looking at system logs:
grep CRON /var/log/syslog 2>/dev/null || echo "Not found in syslog"

# ============================================================================
# WHAT THE SCRIPT DOES
# ============================================================================

# 1. Fetches the latest BBS list from telnetbbsguide.com
# 2. Parses HTML to extract BBS names, addresses, and ports
# 3. Formats entries as JavaScript objects
# 4. Updates index.html with new/changed BBS entries
# 5. Keeps original BBSes intact
# 6. Logs all activity to bbs_update.log
# 7. Maintains HTML structure and styling

# ============================================================================
# CRON TIMING GUIDE
# ============================================================================

# Cron format: minute hour day month weekday
# 
# Examples:
# 0    12   *    *      *      = Every day at 12:00 PM
# */30 *    *    *      *      = Every 30 minutes
# 0    */6  *    *      *      = Every 6 hours
# 0    0    *    *      *      = Every day at midnight
# 0    0    *    *      0      = Every Sunday at midnight
# 0    0    1    *      *      = First day of month at midnight
#
# Online cron expression generator: https://crontab.guru

# ============================================================================
# NOTES
# ============================================================================

# - The script will not overwrite original BBS entries (first 20)
# - It only updates the "Imported from telnetbbsguide.com" section
# - All updates are logged with timestamps
# - The script handles network timeouts gracefully
# - Invalid BBS entries are skipped automatically
