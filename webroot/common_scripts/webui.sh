#!/system/bin/sh

MODDIR="/data/adb/modules/zygisk/webroot"
BRAIN="/data/adb/Box-Brain"
FLAG="$BRAIN/.integrity_ui_swap.flag"
LOGDIR="$BRAIN/Integrity-Box-Logs"
LOGFILE="$LOGDIR/swap.log"

mkdir -p "$LOGDIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

if [ -f "$FLAG" ]; then
  log "Reverting changes..."
  if [ -f "$MODDIR/index.html.bak" ]; then
    mv -f "$MODDIR/index.html" "$MODDIR/old.md"
    log "Renamed index.html back to old.md"
    mv -f "$MODDIR/index.html.bak" "$MODDIR/index.html"
    log "Restored index.html from index.html.bak"
  else
    log "index.html.bak not found, cannot restore"
  fi
  rm -f "$FLAG"
  log "Revert complete"
else
  log "Applying changes..."
  if [ -f "$MODDIR/index.html" ]; then
    mv -f "$MODDIR/index.html" "$MODDIR/index.html.bak"
    log "Renamed index.html to index.html.bak"
  else
    log "index.html not found"
  fi
  if [ -f "$MODDIR/old.md" ]; then
    mv -f "$MODDIR/old.md" "$MODDIR/index.html"
    log "Renamed old.md to index.html"
  else
    log "old.md not found"
  fi
  touch "$FLAG"
  log "Changes applied"
fi