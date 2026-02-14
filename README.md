# AREDN-WEBPAGE-DIRECTORY
AREDN directory of telnet sites both on the regular internet and on the AREDN network

## Version 2.0 - Final Consolidated Presentation List

This directory now includes comprehensive listings across multiple categories:

### I. Scientific & Space Data
- **NASA JPL Horizons** (horizons.jpl.nasa.gov:6775) - Real-time ephemerides for 1.3M+ celestial objects
- **Solar Flux & Propagation** (dx.clearskyinstitute.com:7373) - Live WWV solar data for HF prediction

### II. Real-Time Information Utilities
- **University of Michigan Weather** (rainmaker.wunderground.com) - NWS text forecasts and marine alerts
- **Aviation Weather (METAR/TAF)** (metar.vne.com) - Raw airport weather data
- **The Bitcoin Ticker** (ticker.bitcointicker.co:10080) - Live text feed for market stability testing

### III. Network & Infrastructure Diagnostics
- **NIST Atomic Time** (time.nist.gov:13) - Single-packet UTC time check
- **BGP Route Views** (route-views.oregon-ix.net) - Global routing table viewer for troubleshooting gateways

### IV. Reference & Educational Systems
- **Dictionary (DICT) Server** (dict.org:2628) - Searchable multi-database word definitions
- **Wikipedia Terminal Bridge** (telnet.wiki.gd) - Low-bandwidth, text-only Wikipedia access
- **Telehack** (telehack.com) - 1980s network simulation and massive technical archive

### V. Specialty & Unlisted Ham BBSes
- **Galacticomm Official** (bbs.gcomm.com) - Original flagship MajorBBS system
- **The Vortex BBS** (bbs.thevortex.com) - MajorBBS node for VTC routing testing
- **K8OE-BBS** (k8oe.ddns.net) - Specialized amateur radio and AREDN-focused board
- **N0ARY BBS** (bbs.n0ary.org) - Classic packet radio terminal simulation

### VI. Communication Gateways
- **Winlink RMS Telnet** (cmsterm.winlink.org:8778) - Bridge mesh/packet mail to Winlink
- **Usenet News** (news.eternal-september.org:119) - Global newsgroups via NNTP

### VII. DX Clusters & Propagation
- **DX Cluster Minimalist** (dxc.nc7j.com:7373) - Raw spotting feed for band conditions
- **K2SDR DX Cluster** (k2sdr.net:7373) - Live HF radio propagation spots

### Additional Notable Services
- **ISCABBS** - Oldest continuously operating online community
- **BatMUD** - High-fantasy MUD stable over multi-hop networks
- **Aardwolf MUD** - Best-maintained MUD with low-bandwidth mode
- **Archaic Binary** - Security and retro-computing focus
- **Aioe & Eternal September** - Newsgroup gateways
- **CNN Text News** - Real-time headlines via Gopher

## Features
- Searchable directory with filtering by type
- Real-time status indicators
- Categorization for easy browsing
- Optimized for AREDN mesh network access
- Low-bandwidth, text-only services prioritized
- **Auto-update capability** - Automatically syncs with telnetbbsguide.com

## Auto-Update Configuration

The directory now includes 42 BBSes automatically scraped from telnetbbsguide.com, with the ability to keep them synchronized as the source site updates.

### Quick Setup (Linux/macOS)

Run the interactive setup script:
```bash
./setup_autoupdate.sh
```

This will prompt you to choose an update frequency:
- Every hour
- Every 6 hours
- Every 12 hours (recommended)
- Every 24 hours (daily)
- Every 3 days
- Custom cron expression

### Manual Setup

If you prefer to set up the cron job manually:

```bash
# View your current crontab
crontab -l

# Edit the crontab
crontab -e

# Add one of these lines (replace /path/to with actual path):
# Update every 6 hours:
0 */6 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# Update daily at 2 AM:
0 2 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1

# Update every 12 hours:
0 */12 * * * /usr/bin/python3 /path/to/update_bbs_list.py >> /path/to/bbs_update.log 2>&1
```

### Update Process

The `update_bbs_list.py` script:
1. Fetches the latest BBS listings from telnetbbsguide.com
2. Parses entries for address, port, and name
3. Updates the `index.html` database with new/changed entries
4. Logs all updates to `bbs_update.log`
5. Maintains existing webpage styling and original BBS entries

### Monitoring Updates

Check the update log:
```bash
tail -f bbs_update.log
```

View recent updates:
```bash
cat bbs_update.log | grep SUCCESS
```

### Remove Auto-Update

To disable automatic updates:
```bash
crontab -e
# Delete the line containing update_bbs_list.py
# Save and exit
```

## Last Updated
February 2026 - Version 2.0 with Auto-Update
