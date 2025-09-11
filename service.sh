#!/system/bin/sh

# Module path and file references
MCTRL="${0%/*}"
SHAMIKO_WHITELIST="/data/adb/shamiko/whitelist"
NOHELLO_DIR="/data/adb/nohello"
NOHELLO_WHITELIST="$NOHELLO_DIR/whitelist"
LOG_DIR="/data/adb/Box-Brain/Integrity-Box-Logs"
LOG="$LOG_DIR/service.log"

# Logger function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG"
}

# Check for Magisk presence
is_magisk() {
    [ -d /data/adb/magisk ] || getprop | grep -q 'magisk'
}

# Module install path
export MODPATH="/data/adb/modules/zygisk"

NO_LINEAGE_FLAG="/data/adb/Box-Brain/NoLineageProp"

# Only run if NoLineageProp exists
if [ -f "$NO_LINEAGE_FLAG" ]; then
    log "NoLineageProp flag detected. Starting LineageOS prop cleanup."

    # Remove LineageOS props (by @ez-me)
    log "Deleting LineageOS build props..."
    resetprop --delete ro.lineage.build.version
    resetprop --delete ro.lineage.build.version.plat.rev
    resetprop --delete ro.lineage.build.version.plat.sdk
    resetprop --delete ro.lineage.device
    resetprop --delete ro.lineage.display.version
    resetprop --delete ro.lineage.releasetype
    resetprop --delete ro.lineage.version
    resetprop --delete ro.lineagelegal.url
    log "LineageOS props deleted."

    # Create system.prop from build info
    TMP_PROP="$MODPATH/tmp.prop"
    SYSTEM_PROP="$MODPATH/system.prop"

    log "Generating temporary prop file..."
    getprop | grep "userdebug" > "$TMP_PROP"
    getprop | grep "test-keys" >> "$TMP_PROP"
    getprop | grep "lineage_" >> "$TMP_PROP"

    log "Sanitizing temporary prop file..."
    sed -i 's///g' "$TMP_PROP"
    sed -i 's/: /=/g' "$TMP_PROP"
    sed -i 's/userdebug/user/g' "$TMP_PROP"
    sed -i 's/test-keys/release-keys/g' "$TMP_PROP"
    sed -i 's/lineage_//g' "$TMP_PROP"

    log "Sorting and creating final system.prop..."
    sort -u "$TMP_PROP" > "$SYSTEM_PROP"
    rm -f "$TMP_PROP"
    log "system.prop created at $SYSTEM_PROP."

    log "Waiting 30 seconds before applying props..."
    sleep 30

    log "Applying props via resetprop..."
    resetprop -n --file "$SYSTEM_PROP"
    log "LineageOS prop cleanup completed successfully ✅"
else
    log "NoLineageProp flag not found. Skipping LineageOS prop cleanup."
fi

#!/bin/sh

if [ -f /data/adb/Box-Brain/selinux ]; then
    if command -v setenforce >/dev/null 2>&1; then
        current=$(getenforce)
        if [ "$current" != "Enforcing" ]; then
            setenforce 1
            log "SELINUX Spoofed successfully"
        fi
    fi
fi

sh /data/adb/Box-Brain/Integrity-Box-Logs/description.sh

# Initial states
shamiko_prev=""
nohello_prev=""

# Loop to monitor toggle state
while true; do
  if [ -f /data/adb/Box-Brain/stop ]; then
#    log "Stop file found. Exiting background loop."
    rm -rf $SHAMIKO_WHITELIST
    rm -rf $NOHELLO_WHITELIST
    break
  fi
  
  if [ ! -e "${MCTRL}/disable" ] && [ ! -e "${MCTRL}/remove" ]; then
    if is_magisk && [ ! -f /data/adb/Box-Brain/stop ]; then

      if [ ! -f "$SHAMIKO_WHITELIST" ]; then
        touch "$SHAMIKO_WHITELIST"
      fi

      if [ -d "$NOHELLO_DIR" ] && [ ! -f "$NOHELLO_WHITELIST" ]; then
        touch "$NOHELLO_WHITELIST"
      fi

      # Show log if Shamiko just got activated
      if [ "$shamiko_prev" != "on" ] && [ -f "$SHAMIKO_WHITELIST" ]; then
        log "Shamiko Whitelist Mode Activated.✅"
        shamiko_prev="on"
      fi

      # Show log if NoHello just got activated
      if [ "$nohello_prev" != "on" ] && [ -f "$NOHELLO_WHITELIST" ]; then
        log "NoHello Whitelist Mode Activated.✅"
        nohello_prev="on"
      fi

    fi
  else
    if [ -f "$SHAMIKO_WHITELIST" ]; then
      rm -f "$SHAMIKO_WHITELIST"
      log "Shamiko Blacklist Mode Activated.❌"
      shamiko_prev="off"
    fi

    if [ -f "$NOHELLO_WHITELIST" ]; then
      rm -f "$NOHELLO_WHITELIST"
      log "NoHello Blacklist Mode Activated.❌"
      nohello_prev="off"
    fi
  fi
  sleep 4
done &