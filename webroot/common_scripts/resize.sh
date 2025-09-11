#!/system/bin/sh

# Paths
HTML_FILE="/data/adb/modules/zygisk/webroot/index.html"
LOG_FILE="/data/adb/Box-Brain/Integrity-Box-Logs/resize.log"
STATUS_FILE="/data/adb/Box-Brain/.resize_state"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Log helper
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Enlarge font sizes
increase_size() {
    sed -i 's/font-size: 28px/font-size: 65px/g' "$HTML_FILE"
    sed -i 's/font-size: 0.8rem/font-size: 1.0rem/g' "$HTML_FILE"
    echo "big" > "$STATUS_FILE"
    log "Increased: 28px → 65px, 0.8rem → 1.0rem"
    log "Size increased, Pls reopen the WebUI"
}

# Restore to default
restore_default() {
    sed -i 's/font-size: 65px/font-size: 28px/g' "$HTML_FILE"
    sed -i 's/font-size: 1.0rem/font-size: 0.8rem/g' "$HTML_FILE"
    echo "default" > "$STATUS_FILE"
    log "Restored: 65px → 28px, 1.0rem → 0.8rem"
    log "Size restored, Pls reopen the WebUI"
}

# Toggle behavior
if [ -f "$STATUS_FILE" ]; then
    STATE=$(cat "$STATUS_FILE")
    if [ "$STATE" = "big" ]; then
        restore_default
    else
        increase_size
    fi
else
    increase_size
fi