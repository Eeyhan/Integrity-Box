#!/system/bin/sh

FILE="/data/adb/modules/zygisk/webroot/index.html"
BAK="${FILE}.bak"
TMP="${FILE}.tmp.$$"
LOGDIR="/data/adb/Box-Brain/Integrity-Box-Logs"
LOGFILE="$LOGDIR/toggle_intro.log"

mkdir -p "$LOGDIR"

[ -f "$FILE" ] || { echo "[$(date)] ERROR: File not found: $FILE" >> "$LOGFILE"; exit 1; }

# one-time backup
if [ ! -f "$BAK" ]; then
  cp -p "$FILE" "$BAK"
  echo "[$(date)] Backup created: $BAK" >> "$LOGFILE"
fi

awk -v date="$(date)" -v logfile="$LOGFILE" '
BEGIN { mode=0; incomment=0 }
/^<!--$/ && mode==0 {
  getline nxt
  if (nxt ~ /^ *<div id="intro-overlay">/) {
    # found commented block
    mode=2; incomment=1
    print nxt
    next
  } else {
    print; print nxt
    next
  }
}
/^-->/ && incomment==1 {
  incomment=0
  next
}
/^ *<div id="intro-overlay">/ && mode==0 {
  mode=1
  print "<!--"
  print
  next
}
mode==1 {
  print
  if ($0 ~ /^ *<\/div>/) {
    print "-->"
    mode=0
  }
  next
}
mode==2 {
  print
  if ($0 ~ /^ *<\/div>/) {
    mode=0
  }
  next
}
{ print }
END {
  if (mode==1) {
    system("echo \"[" date "] Action: commented intro overlay\" >> " logfile)
  } else if (mode==2) {
    system("echo \"[" date "] Action: uncommented intro overlay\" >> " logfile)
  } else {
    system("echo \"[" date "] Warning: intro overlay block not found\" >> " logfile)
  }
}
' "$FILE" > "$TMP" && mv "$TMP" "$FILE"