#!/system/bin/sh

# Paths
LOG="/data/adb/Box-Brain/Integrity-Box-Logs"
LOGFILE="$LOG/patch.log"
TARGET_DIR="/data/adb/tricky_store"
FILE_PATH="$TARGET_DIR/security_patch.txt"
FILE_CONTENT="all=2025-07-05"
U="/data/adb/modules/integrity_box"

# Execute kill script
chmod +x "$U/kill.sh"
sh "$U/kill.sh"

# Ensure log directory exists
mkdir -p "$LOG"

# Logging function
log() { echo -e "$1" | tee -a "$LOGFILE"; }

log "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log " "
log "Patch Mode : Auto"
log "Spoofed to : 05 JULY 2025"
log "Applied on:  $(date '+%A %d/%m/%Y %I:%M:%S %p')"

# Check if file exists to proceed
if [ ! -f "$FILE_PATH" ] && [ ! -d "$TARGET_DIR" ]; then
    log "⚠️ Tricky Store is not installed."
    exit 0
fi

# Toggle spoofing
if [ -f "$FILE_PATH" ]; then
    rm -f "$FILE_PATH"
    log "Patch Status : ❌ Not Spoofed / Removed"
else
    mkdir -p "$TARGET_DIR"
    echo "$FILE_CONTENT" > "$FILE_PATH"
    log "Patch Status : ✅ Spoofed"
fi

log "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log " "