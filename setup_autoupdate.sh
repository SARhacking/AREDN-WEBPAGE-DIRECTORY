#!/bin/bash
# Setup script for automatic BBS list updates
# This script installs a cron job to automatically update the BBS list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/update_bbs_list.py"
PYTHON_PATH=$(which python3)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}BBS List Auto-Update Setup${NC}"
echo "========================================"

# Check if script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo -e "${RED}Error: update_bbs_list.py not found at $SCRIPT_PATH${NC}"
    exit 1
fi

# Check if python3 is available
if [ -z "$PYTHON_PATH" ]; then
    echo -e "${RED}Error: python3 not found${NC}"
    exit 1
fi

echo "Script location: $SCRIPT_PATH"
echo "Python location: $PYTHON_PATH"
echo ""

# Ask user for update frequency
echo "How often should the BBS list update?"
echo "1) Every hour"
echo "2) Every 6 hours"
echo "3) Every 12 hours"
echo "4) Every 24 hours (daily)"
echo "5) Every 3 days"
echo "6) Custom (enter cron expression)"
echo ""
read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        CRON_EXPR="0 * * * *"
        FREQ="hourly"
        ;;
    2)
        CRON_EXPR="0 */6 * * *"
        FREQ="every 6 hours"
        ;;
    3)
        CRON_EXPR="0 */12 * * *"
        FREQ="every 12 hours"
        ;;
    4)
        CRON_EXPR="0 0 * * *"
        FREQ="daily at midnight"
        ;;
    5)
        CRON_EXPR="0 0 */3 * *"
        FREQ="every 3 days"
        ;;
    6)
        read -p "Enter cron expression (e.g., '0 2 * * *'): " CRON_EXPR
        FREQ="$CRON_EXPR"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Create cron job entry
CRON_JOB="$CRON_EXPR $PYTHON_PATH $SCRIPT_PATH >> $SCRIPT_DIR/bbs_update.log 2>&1"

echo ""
echo "This will install a cron job:"
echo "${YELLOW}$CRON_JOB${NC}"
echo ""
echo "Update frequency: $FREQ"
echo ""

# Ask for confirmation
read -p "Continue with installation? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Installation cancelled"
    exit 0
fi

# Check existing crontab
TEMP_CRON=$(mktemp)
crontab -l > "$TEMP_CRON" 2>/dev/null || true

# Check if job already exists
if grep -F "$SCRIPT_PATH" "$TEMP_CRON" > /dev/null; then
    echo -e "${YELLOW}Warning: Update job already exists in crontab${NC}"
    echo "Removing old entry..."
    grep -v "$SCRIPT_PATH" "$TEMP_CRON" > "$TEMP_CRON.new"
    mv "$TEMP_CRON.new" "$TEMP_CRON"
fi

# Add new cron job
echo "$CRON_JOB" >> "$TEMP_CRON"

# Install crontab
crontab "$TEMP_CRON"
rm -f "$TEMP_CRON" "$TEMP_CRON.new"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Cron job successfully installed!${NC}"
    echo ""
    echo "The BBS list will now auto-update $FREQ"
    echo "Log file: $SCRIPT_DIR/bbs_update.log"
    echo ""
    echo "To view the cron job:"
    echo "  crontab -l"
    echo ""
    echo "To remove the cron job:"
    echo "  crontab -e  (then delete the line with update_bbs_list.py)"
    echo ""
else
    echo -e "${RED}Failed to install cron job${NC}"
    exit 1
fi
