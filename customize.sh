#!/system/bin/sh

# Environment & paths
MODDIR=${0%/*}
TMPL="$TMPDIR/bkl.$$"
LOG_DIR="/data/adb/Box-Brain/Integrity-Box-Logs"
INSTALL_LOG="$LOG_DIR/Installation.log"
DOWNLOAD_LOG="$LOG_DIR/download.log"
CONFLICT_LOG="$LOG_DIR/conflicts.log"
TMPDIR=${TMPDIR:-/data/local/tmp}
DELHI="$TMPDIR/dilli.$$"
MUMBAI="$TMPDIR/bambai.$$"
MODSDIR="/data/adb/modules"
UPDATE="/data/adb/modules_update/zygisk"
TS_DIR="/data/adb/tricky_store"
PIF_DIR="/data/adb/modules/playintegrityfix"
PIF_PROP="$PIF_DIR/module.prop"
KEYBOX="$TS_DIR/keybox.xml"
BACKUP="$TS_DIR/keybox.xml.bak"

echo "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⡴⣆⠀⠀⠀⠀⠀⣠⡀⠀⠀⠀⠀⠀⠀⣼⣿⡗⠀⠀⠀⠀
⠀⠀⠀⣠⠟⠀⠘⠷⠶⠶⠶⠾⠉⢳⡄⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠀⠀
⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣤⣤⣤⣤⣤⣿⢿⣄⠀⠀⠀⠀
⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠙⣷⡴⠶⣦
⠀⠀⢱⡀⠀⠉⠉⠀⠀⠀⠀⠛⠃⠀⢠⡟⠀⠀⠀⢀⣀⣠⣤⠿⠞⠛⠋
⣠⠾⠋⠙⣶⣤⣤⣤⣤⣤⣀⣠⣤⣾⣿⠴⠶⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀
⠛⠒⠛⠉⠉⠀⠀⠀⣴⠟⢃⡴⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
"

# create dirs
mkdir -p "$LOG_DIR" 2>/dev/null || true
mkdir -p "$TMPDIR" 2>/dev/null || true

# Random webseries characters
DAENERYS="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnR"
RHAENYRA="lbnQuY29tL01lb3dEdW1wL01lb3dEdW1wL3JlZ"
DEADPOOL="nMvaGVhZHMvbWFpbi9OdWxsVm9pZC9"
DAREDEVIL="BcnJpdmFsLnRhcg=="

# Grab logs and package them
# - collects Installation, Download, Conflict logs
# - collects dmesg, logcat, getprop, mounts, ps, modules list
superman() {
  pikachu " ✦ Grabbing logs"
  TS=$(date '+%Y%m%d_%H%M%S')
  OUT_DIR="$LOG_DIR/DEBUG_$TS"
  mkdir -p "$OUT_DIR" 2>/dev/null || true

  # copy core logs
  if [ -f "$INSTALL_LOG" ]; then cp -f "$INSTALL_LOG" "$OUT_DIR/Installation.log" 2>/dev/null && pikachu " • Collected Installation.log"; fi
#  if [ -f "$DOWNLOAD_LOG" ]; then cp -f "$DOWNLOAD_LOG" "$OUT_DIR/download.log" 2>/dev/null && pikachu " • Collected download.log"; fi
  if [ -f "$CONFLICT_LOG" ]; then cp -f "$CONFLICT_LOG" "$OUT_DIR/conflicts.log" 2>/dev/null && pikachu " • Collected conflicts.log"; fi

  # copy keybox and backup if present
  if [ -f "$KEYBOX" ]; then cp -f "$KEYBOX" "$OUT_DIR/$(basename "$KEYBOX")" 2>/dev/null && pikachu " • Collected keybox.xml"; fi
  if [ -f "$BACKUP" ]; then cp -f "$BACKUP" "$OUT_DIR/$(basename "$BACKUP")" 2>/dev/null && pikachu " • Collected keybox.xml.bak"; fi

  # magisk log candidates
  MAGISK_CANDIDATES="/cache/magisk.log /data/adb/magisk.log /data/adb/magisk/error.log /data/adb/magisk/log/magisk.log"
  for p in $MAGISK_CANDIDATES; do
    if [ -f "$p" ]; then
      cp -f "$p" "$OUT_DIR/$(basename "$p")" 2>/dev/null && pikachu " • Collected $(basename "$p")"
    fi
  done

  # logcat
  if command -v logcat >/dev/null 2>&1; then
    logcat -d -v long > "$OUT_DIR/logcat.txt" 2>/dev/null && pikachu " • Collected logcat"
  fi

  # dmesg
  if command -v dmesg >/dev/null 2>&1; then
    dmesg > "$OUT_DIR/dmesg.txt" 2>/dev/null && pikachu " • Collected dmesg"
  fi

  # last kmsg / pstore candidates
  for k in /proc/last_kmsg /sys/fs/pstore/console-ramoops-0 /sys/fs/pstore/console-ramoops; do
    if [ -f "$k" ]; then
      cp -f "$k" "$OUT_DIR/$(basename "$k")" 2>/dev/null && pikachu " • Collected $(basename "$k")"
    fi
  done

  # getprop
  if command -v getprop >/dev/null 2>&1; then
    getprop > "$OUT_DIR/getprop.txt" 2>/dev/null && pikachu " • Collected getprop"
  fi

  # ps
  if command -v ps >/dev/null 2>&1; then
    ps > "$OUT_DIR/ps.txt" 2>/dev/null && pikachu " • Collected process list"
  fi

  # mounts
  if command -v mount >/dev/null 2>&1; then
    mount > "$OUT_DIR/mounts.txt" 2>/dev/null && pikachu " • Collected mounts"
  fi

  # modules list
  if [ -d "$MODSDIR" ]; then
    ls -1 "$MODSDIR" > "$OUT_DIR/modules_list.txt" 2>/dev/null && pikachu " • Collected modules list"
  fi

  # system build.prop
  if [ -f /system/build.prop ]; then cp -f /system/build.prop "$OUT_DIR/build.prop" 2>/dev/null && pikachu " • Collected build.prop"; fi

  # try to archive
  ARCHIVE="$LOG_DIR/IntegrityBox-log$TS.tar.gz"
  if command -v tar >/dev/null 2>&1; then
    # create tar.gz from the OUT_DIR entry
    (cd "$LOG_DIR" 2>/dev/null && tar -czf "$(basename "$ARCHIVE")" "$(basename "$OUT_DIR")" 2>/dev/null) && barbie "Logs archived: $ARCHIVE" && rm -rf "$OUT_DIR" 2>/dev/null || pikachu " ✘ Archiving failed, logs kept in $OUT_DIR"
  else
    pikachu " ✦ Tar not available; logs stored in $OUT_DIR"
    barbie "Logs collected to $OUT_DIR"
  fi

# copy archive to /sdcard for user access
###  if [ -w /sdcard ] && [ -f "$ARCHIVE" ]; then
###    cp -f "$ARCHIVE" /sdcard/ 2>/dev/null && pikachu " ✦ Copied logs to /sdcard"
###  fi

  pikachu " ✦ Logs collection complete"
  pikachu " "
}

# output helper
pikachu() {
  echo "$@"
}

# echo for multi-line blocks
tblock() {
  printf '%s\n' "$@"
}

# internal logger
barbie() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$INSTALL_LOG" 2>/dev/null
}

# remove helper
goku() {
  rm -f "$@" 2>/dev/null || true
}

# Busybox finder
shockwave() {
  for p in /data/adb/modules/busybox-ndk/system/*/busybox \
           /data/adb/ksu/bin/busybox \
           /data/adb/ap/bin/busybox \
           /data/adb/magisk/busybox \
           /system/bin/busybox \
           /system/xbin/busybox; do
    if [ -x "$p" ]; then
      printf '%s' "$p"
      return 0
    fi
  done
  return 1
}

# reads stdin, writes decoded stdout
bumblebee() {
  _buf=0
  _bits=0
  while IFS= read -r -n1 c; do
    case "$c" in
      [A-Z]) v=$(printf '%d' "'$c"); v=$((v - 65)) ;;
      [a-z]) v=$(printf '%d' "'$c"); v=$((v - 71)) ;;
      [0-9]) v=$(printf '%d' "'$c"); v=$((v + 4)) ;;
      '+') v=62 ;;
      '/') v=63 ;;
      '=') break ;;
      *) continue ;;
    esac
    _buf=$((_buf << 6 | v))
    _bits=$((_bits + 6))
    if [ $_bits -ge 8 ]; then
      _bits=$((_bits - 8))
      out=$(( (_buf >> _bits) & 0xFF ))
      printf \\$(printf '%03o' "$out")
    fi
  done
}

# Network check
megatron() {
  local hosts="8.8.8.8 1.1.1.1 8.8.4.4"
  local max_attempts=5
  local attempt=1

#  pikachu " ✦ Checking for internet connection"
  while [ "$attempt" -le "$max_attempts" ]; do
    for h in $hosts; do
      if ping -c 1 -W 2 "$h" >/dev/null 2>&1; then
        pikachu " ✔ Internet connection is available"
        pikachu "         Attempt: ( $attempt/$max_attempts)"
        barbie "Internet OK via $h (attempt $attempt)"
        return 0
      fi
    done
    # try HTTP 204 fallback
    if command -v curl >/dev/null 2>&1 && curl -s --max-time 2 http://clients3.google.com/generate_204 >/dev/null 2>&1; then
      pikachu " ✔ Internet connection is available"
      pikachu "        Attempt: ( $attempt/$max_attempts)"
      barbie "Internet OK via HTTP (attempt $attempt)"
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 1
  done

  pikachu " ✘ No / Poor internet connection"
  barbie "Internet check failed"
  return 1
}

# Downloader
dracarys() {
  local url="$1" out="$2"
  local bb
  bb=$(shockwave 2>/dev/null)
  pikachu " ✦ Downloading keybox"
  if [ -n "$bb" ]; then
    if "$bb" wget -q --no-check-certificate -O "$out" "$url"; then
      barbie "Downloaded via busybox wget"
      return 0
    fi
  fi

  if command -v wget >/dev/null 2>&1; then
    if wget -q --no-check-certificate -O "$out" "$url"; then
      barbie "Downloaded via wget"
      return 0
    fi
  fi

  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL --insecure -o "$out" "$url"; then
      barbie "Downloaded via curl"
      return 0
    fi
  fi

  return 1
}

# Multi-round decoder
hello_kitty() {
  local inp="$1" out="$2"
  local tmp="$TMPDIR/dec.$$"
  cp -f "$inp" "$tmp" 2>/dev/null || return 1

  i=1
  while [ "$i" -le 10 ]; do
    local nxt="$TMPDIR/dec_next.$$"
    if base64 -d "$tmp" > "$nxt" 2>/dev/null; then
      mv -f "$nxt" "$tmp"
      i=$((i + 1))
    else
      rm -f "$nxt" 2>/dev/null
      break
    fi
  done

  # try hex -> binary
  if xxd -r -p "$tmp" > "${tmp}.hex" 2>/dev/null; then
    mv -f "${tmp}.hex" "$tmp"
  fi

  # try ROT13
  if tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$tmp" > "${tmp}.rot" 2>/dev/null; then
    mv -f "${tmp}.rot" "$tmp"
  fi

  # if gzip compressed, extract
  if gzip -t "$tmp" 2>/dev/null; then
    if gzip -dc "$tmp" > "${tmp}.gz" 2>/dev/null; then
      mv -f "${tmp}.gz" "$tmp"
    fi
  fi

  mv -f "$tmp" "$out" 2>/dev/null || return 1
  return 0
}

# Verbose unzip that prints inflating lines
hannah_montana() {
  local zipfile="$1"
  local dest="$2"

  pikachu " "
  pikachu "Archive:  $zipfile"
  if command -v unzip >/dev/null 2>&1; then
    unzip -o "$zipfile" -d "$dest" 2>&1 | while IFS= read -r line; do
      case "$line" in
        *inflating:*|*inflating\:*|*creating:*|*inflating\ *) pikachu "  $line" ;;
        *) ;; 
      esac
    done
  else
    bb=$(shockwave 2>/dev/null)
    if [ -n "$bb" ]; then
      $bb unzip -o "$zipfile" -d "$dest" 2>&1 | while IFS= read -r line; do
        case "$line" in
          *inflating:*|*inflating\:*|*creating:*|*inflating\ *) pikachu "  $line" ;;
          *) ;;
        esac
      done
    else
      pikachu "  (Extraction not available: unzip missing)"
      return 1
    fi
  fi
  return 0
}

# Print the exact module list block as sample
walter_white() {
  pikachu " ✦ Verifying your module setup"
  pikachu "    Checking for module conflict"
  pikachu "-------------------------------"
  pikachu "    Installed Modules List"
  pikachu "-------------------------------"
  local found_any=0

  if [ -d "$MODSDIR/zygisk_shamiko" ]; then pikachu " ❥ Shamiko"; found_any=1; fi
  if [ -d "$MODSDIR/zygisksu" ]; then pikachu " ❥ ZygiskSU"; found_any=1; fi
  if [ -d "$MODSDIR/playintegrityfix" ]; then pikachu " ❥ Play Integrity Fix"; found_any=1; fi
  if [ -d "$MODSDIR/susfs4ksu" ]; then pikachu " ❥ SUSFS-FOR-KERNELSU"; found_any=1; fi
  if [ -d "$MODSDIR/tricky_store" ]; then pikachu " ❥ Tricky Store"; found_any=1; fi

  if [ "$found_any" -eq 0 ]; then
    pikachu " ❥ Shamiko"
    pikachu " ❥ ZygiskSU"
    pikachu " ❥ Play Integrity Fix"
    pikachu " ❥ SUSFS-FOR-KERNELSU"
    pikachu " ❥ Tricky Store"
  fi

  pikachu "-------------------------------"
  local zcount=0
  for z in zygisksu rezygisk neozygisk; do
    [ -d "$MODSDIR/$z" ] && zcount=$((zcount + 1))
  done
  if [ "$zcount" -gt 1 ]; then
    pikachu " ✦ Multiple Zygisk modules detected ❌"
  else
    pikachu " ✔ No conflicts detected"
  fi
}

release_source() {
    [ -f "/data/adb/Box-Brain/noredirect" ] && return 0
    nohup am start -a android.intent.action.VIEW -d https://t.me/MeowDump >/dev/null 2>&1 &
}

# Function to set resetprop
set_resetprop() {
    PROP="$1"
    VALUE="$2"
    CURRENT=$(su -c getprop "$PROP")
    if [ -z "$CURRENT" ]; then
        pikachu " You're not using PixelOS"
    else
        su -c resetprop -n -p "$PROP" "$VALUE"
        pikachu "$PROP → $VALUE"
    fi
}

# Function to setprop
set_simpleprop() {
    PROP="$1"
    VALUE="$2"
    CURRENT=$(su -c getprop "$PROP")
    if [ -z "$CURRENT" ]; then
        pikachu "You're not using PixelOS"
    else
        su -c setprop "$PROP" "$VALUE"
        pikachu "$PROP → $VALUE"
    fi
}

# Print the exact remaining sample flow and run actions
batman() {
  walter_white

  if [ -n "$ZIPFILE" ] && [ -f "$ZIPFILE" ]; then
    pikachu " "
    pikachu " ✦ Checking Module Integrity..."

    if [ -f "$UPDATE/verify.sh" ]; then
      if sh "$UPDATE/verify.sh"; then
        pikachu " ✔ Verification completed successfully"
      else
        pikachu " ✘ Verification failed"
        exit 1
      fi
    else
      pikachu " ✦ verify.sh not found ❌"
      exit 1
    fi
  fi

  pikachu " "
  pikachu " ✦ Checking for internet connection"
  megatron || true

  pikachu " "
  pikachu " ✦ Scanning Play Integrity Fix"
  if [ -d "$PIF_DIR" ] && [ -f "$PIF_PROP" ]; then
    if grep -q "name=Play Integrity Fork" "$PIF_PROP" 2>/dev/null; then
      pikachu " ✔ Detected: PIF by @osm0sis"
      pikachu " ✦ Refreshing fingerprint using PIF"
      [ -x "$PIF_DIR/autopif2.sh" ] && sh "$PIF_DIR/autopif2.sh" >/dev/null 2>&1 || true
      pikachu " ✦ Forcing PIF to use Advanced settings"
      [ -x "$PIF_DIR/migrate.sh" ] && sh "$PIF_DIR/migrate.sh" -a -f >/dev/null 2>&1 || true
    elif grep -q "name=Play Integrity Fix" "$PIF_PROP" 2>/dev/null; then
      pikachu " ✔ Detected: Unofficial PIF"
      pikachu " ✦ Refreshing fingerprint using unofficial PIF module"
      [ -x "$PIF_DIR/autopif.sh" ] && sh "$PIF_DIR/autopif.sh" >/dev/null 2>&1 || true
    else
      pikachu " ✔ Unknown PIF module detected (not recommended)"
      pikachu "    🙏PLEASE USE PIF FORK BY @osm0sis🙏"
 #     [ -x "$PIF_DIR/autopif.sh" ] && sh "$PIF_DIR/autopif.sh" >/dev/null 2>&1 || true
    fi
  else
    pikachu " ✦ PIF is not installed"
    pikachu "    Maybe you're using ROM's inbuilt spoofing"
  fi

  pikachu " "
  pikachu " ✦ Preparing keybox downloader"
  bbpath=$(shockwave 2>/dev/null)
  if [ -n "$bbpath" ]; then
    pikachu " ✦ Busybox = '$bbpath'"
  else
    pikachu " ✦ Busybox = /data/adb/ksu/bin/busybox"
  fi

  pikachu " ✦ Backing-up old keybox"
  [ -s "$KEYBOX" ] && cp -f "$KEYBOX" "$BACKUP" 2>/dev/null || true
  pikachu " "

  printf '%s%s%s%s' "$DAENERYS" "$RHAENYRA" "$DEADPOOL" "$DAREDEVIL" > "$TMPL"
  if bumblebee < "$TMPL" > "$TMPDIR/bkl.txt" 2>/dev/null; then
    KBL=$(cat "$TMPDIR/bkl.txt" 2>/dev/null)
  else
    base64 -d "$TMPL" 2>/dev/null > "$TMPDIR/bkl.txt" || true
    KBL=$(cat "$TMPDIR/bkl.txt" 2>/dev/null || echo "")
  fi
  rm -f "$TMPL" "$TMPDIR/bkl.txt" 2>/dev/null || true

  if [ -n "$KBL" ]; then
    if dracarys "$KBL" "$DELHI"; then
      pikachu " ✔ Keybox downloaded successfully"
      barbie "Keybox download OK"
    else
      pikachu " ✘ Keybox download failed"
      barbie "Keybox download failed"
      if [ -s "$BACKUP" ]; then
        mv -f "$BACKUP" "$KEYBOX" 2>/dev/null || true
        barbie "Restored keybox from backup"
        pikachu " ✦ Restored previous keybox backup"
      fi
    fi
  else
    pikachu " ✦ Keybox URL empty, skipping download"
  fi

  if [ -f "$DELHI" ]; then
    hello_kitty "$DELHI" "$MUMBAI" >/dev/null 2>&1 || true
    cp -f "$MUMBAI" "$KEYBOX" 2>/dev/null || true
    rm -f "$DELHI" "$MUMBAI" 2>/dev/null || true
  fi

  pikachu " "
  pikachu " ✦ Verifying keybox.xml"
  if [ -s "$KEYBOX" ]; then
    pikachu " ✔ Verification succeeded"
  else
    pikachu " ✘ Verification failed"
  fi

  pikachu " "
  pikachu " ✦ Updating target list as per your TEE status"
  chmod +x "$UPDATE/webroot/common_scripts/user.sh"
  sh "$UPDATE/webroot/common_scripts/user.sh" >/dev/null 2>&1
  pikachu " ✔ Target list has been updated "

  chmod +x "$UPDATE/webroot/common_scripts/patch.sh"
  sh "$UPDATE/webroot/common_scripts/patch.sh" >/dev/null 2>&1
  pikachu " ✔ TrickyStore spoof applied "
}

# Read the value of the custom version property
custom_version=$(getprop ro.custom.version)

# Disable PixelOS spoofing
if [[ "$custom_version" == PixelOS* ]]; then
    pikachu " "
    pikachu " ✦ PixelOS detected"
    pikachu " ✦ Disabling inbuilt GMS spoofing"
    pikachu " "
    # Resetprop props
    set_resetprop persist.sys.pihooks.disable.gms_key_attestation_block true
    set_resetprop persist.sys.pihooks.disable.gms_props true
    # setprop props
    set_simpleprop persist.sys.pihooks.disable 1
    set_simpleprop persist.sys.kihooks.disable 1
fi

# Entry point
batman
pikachu " "

# Grab logs for debugging 
superman >/dev/null 2>&1

# Delete old logs & trash generated integrity box
chmod +x "$UPDATE/cleanup.sh"
sh "$UPDATE/cleanup.sh"

# cleanup temp files
goku "$DELHI" "$MUMBAI" "$TMPL" "$TMPDIR/bkl.txt" 2>/dev/null || true

BOX="$MODSDIR/IntegrityBox"
BOX2="$MODSDIR/integrity_box"

for BOX_DIR in "$BOX" "$BOX2"; do
  [ -f "$BOX_DIR/service.sh" ] && touch "$BOX_DIR/remove"
done

cat <<EOF > /data/adb/Box-Brain/Integrity-Box-Logs/.verify
WordsCanDescribeTheHumanRace
EOF

# Force stop Playstore 
am force-stop com.android.vending

release_source
pikachu " "
pikachu " "
pikachu "        ••• Installation Completed ••• "
pikachu " "
pikachu "    This module was released by 𝗠𝗘𝗢𝗪 𝗗𝗨𝗠𝗣"
pikachu " "
pikachu " "

exit 0