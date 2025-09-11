#!/system/bin/sh

debug="/data/adb/service.d"
mkdir -p "$debug"

cat <<'EOF' > "$debug/debug.sh"
#!/system/bin/sh
L="/data/adb/Box-Brain/Integrity-Box-Logs/debug.log"

# Logger
meow() {
    echo "$1" | tee -a "$L"
}

# Safeguard: if nodebug exists, skip execution
if [ -f "/data/adb/Box-Brain/nodebug" ]; then
    meow "[Anti-Debug] Disabled by default (nodebug flag present) skipping cleanup."
    exit 0
fi

# Get current fingerprint
fp=$(getprop ro.build.fingerprint)

echo "$fp" | grep -q "userdebug"
if [ $? -eq 0 ]; then
    meow "Debug fingerprint detected. Cleaning it up..."

    fp_clean=${fp/userdebug/user}
    fp_clean=${fp_clean/test-keys/release-keys}
    fp_clean=${fp_clean/dev-keys/release-keys}

    resetprop ro.build.fingerprint "$fp_clean"
    resetprop ro.build.type "user"
    resetprop ro.build.tags "release-keys"

    meow "Cleaned fingerprint applied:"
    meow "$fp_clean"
    meow " "
    meow " "
else
    meow "Fingerprint already clean. No changes made."
fi
EOF

###cat <<'EOF' > "/data/adb/Box-Brain/Integrity-Box-Logs/hello.sh"
#!/system/bin/sh

# Config Paths
###MODULE_DIR="/data/adb/modules/zygisk"
###HASH_DIR="/data/adb/Box-Brain/.hashes"
###LOG_FILE="$MODULE_DIR/.tamper.log"
###ALERT_LOG="/sdcard/tamper_alerts.log"
###SELF="/data/adb/service.d/hello.sh"

# BusyBox
###BUSYBOX=$(for p in /data/adb/modules/busybox-ndk/system/*/busybox \
###                  /data/adb/ksu/bin/busybox \
###                  /data/adb/ap/bin/busybox \
###                  /data/adb/magisk/busybox \
###                  /system/bin/busybox \
###                  /system/xbin/busybox; do [ -x "$p" ] && { echo "$p"; break; }; done)
###[ -z "$BUSYBOX" ] && { echo "BusyBox not found"; exit 1; }

###PRIME="
###webroot/index.html.bak
###webroot/index.html
###webroot/mona.ttf
###webroot/old.md
###webroot/lang
###system.prop
###tamper.log
###disable
###remove
###update
###"

# Prepare
###mkdir -p "$HASH_DIR" "$(dirname "$ALERT_LOG")"
###touch "$LOG_FILE" "$ALERT_LOG"
###touch "$ALERT_LOG"

# Lock important files
###for f in "$MODULE_DIR/module.prop" "$MODULE_DIR/uninstall.sh" "$SELF" "$LOG_FILE"; do
###    chattr +i "$f" 2>/dev/null
###done

# Logging
###log_tamper() {
###    local msg="$1"
###    local timestamp="$($BUSYBOX date "+%d/%m %a %I:%M:%S %p")"
###    chattr -i "$LOG_FILE" 2>/dev/null
###    echo "$timestamp Tampering detected: $msg" >> "$LOG_FILE"
###    echo "$timestamp Tampering detected: $msg" >> "$ALERT_LOG"
###    chattr +i "$LOG_FILE" 2>/dev/null
###}

# Check if file should be excluded
###is_excluded() {
###    for pattern in $PRIME; do
###        case "$1" in
###            *"$pattern"*) return 0 ;;
###        esac
###    done
###    return 1
###}

#### Generate hash database
###lock() {
###    find "$MODULE_DIR" -type f ! -path "$HASH_DIR/*" | while read -r f; do
###        rel_path="${f#$MODULE_DIR/}"
###        is_excluded "$rel_path" && continue
###
###        hash=$($BUSYBOX sha256sum "$f" | awk '{print $1}')
###        echo "$hash" > "$HASH_DIR/$(echo "$rel_path" | $BUSYBOX tr '/' '_').sha256"
###    done
###    echo "All files hashed (SHA256)"
###}

# Watchdog
###watchdog() {
###    while true; do
###        [ ! -d "$HASH_DIR" ] && {
###            log_tamper ".hashes folder missing"
###            rm -rf "$MODULE_DIR"
###            exit 2
###        }
###
###        find "$MODULE_DIR" -type f ! -path "$HASH_DIR/*" | while read -r f; do
###            rel_path="${f#$MODULE_DIR/}"
###            is_excluded "$rel_path" && continue
###
###            hash_file="$HASH_DIR/$(echo "$rel_path" | $BUSYBOX tr '/' '_').sha256"
###
###            if [ ! -f "$hash_file" ]; then
###                log_tamper "$rel_path (missing hash)"
###                rm -rf "$MODULE_DIR"
###                exit 2
###            fi
###
###            current_hash=$($BUSYBOX sha256sum "$f" | awk '{print $1}')
###            expected_hash=$(cat "$hash_file")
###
###            if [ "$current_hash" != "$expected_hash" ]; then
###                log_tamper "$rel_path (tampered)"
###                chattr -i "$MODULE_DIR/module.prop" 2>/dev/null
###                sed -i "s|^description=.*|description=$(tr '\n' ' ' < "$LOG_FILE" | sed 's/ *$//')|" "$MODULE_DIR/module.prop"
###                chattr +i "$MODULE_DIR/module.prop" 2>/dev/null
###                rm -rf "$MODULE_DIR"
###                touch "$MODULE_DIR/disable"
###                exit 2
###            fi
###        done
###
###        # Re-apply immutables
###        for f in "$SELF" "$MODULE_DIR/module.prop" "$MODULE_DIR/uninstall.sh"; do
###            chattr +i "$f" 2>/dev/null
###        done
###
###        sleep 5
###    done
###}

# Respawn watchdog if killed
###respawn_watchdog() {
###    while true; do
###        running=$($BUSYBOX ps | $BUSYBOX grep "$(basename "$SELF") watch" | $BUSYBOX grep -v grep)
###        [ -z "$running" ] && nohup sh "$SELF" watch &>/dev/null &
###        sleep 10
###    done
###}

# Entrypoint
###case "$1" in
###    lock)
###        lock
###        nohup sh "$SELF" watch &>/dev/null &
###        nohup sh "$SELF" respawn &>/dev/null &
###        ;;
###    watch|verify)
###        watchdog
###        ;;
###    respawn)
###        respawn_watchdog
###        ;;
###    *)
###        echo "SKILL ISSUE"
###        ;;
###esac
###EOF

cat <<'EOF' > "/data/adb/Box-Brain/Integrity-Box-Logs/description.sh"

#!/system/bin/sh
MODULE="/data/adb/modules"
MODDIR="$MODULE/zygisk"
PIF="$MODULE/playintegrityfix"
SHAMIKO="$MODULE/zygisk_shamiko"
NOHELLO="$MODULE/zygisk_nohello"
TRICKY_STORE="$MODULE/tricky_store"
SUSFS="$MODULE/susfs4ksu"

###chattr -i "$MODDIR/.tamper.log"

# Lists for sorted display
ENABLED_LIST=""
DISABLED_LIST=""

append_item() {
    if [ -z "$1" ]; then
        echo "$2"
    else
        echo "$1 | $2"
    fi
}

# Check and sort modules
[ -d "$SHAMIKO" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "Shamiko ✔") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "Shamiko ✘")
[ -d "$TRICKY_STORE" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "TrickyStore ✔") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "TrickyStore ✘")
[ -d "$NOHELLO" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "NoHello ✔") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "NoHello ✘")
[ -d "$SUSFS" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "SusFS ✔") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "SusFS ✘")
[ -d "$PIF" ] && ENABLED_LIST=$(append_item "$ENABLED_LIST" "PIF ✔") || DISABLED_LIST=$(append_item "$DISABLED_LIST" "PIF ✘")

# Risky Apps Detection (Count)
RISKY_APPS="com.rifsxd.ksunext
me.weishu.kernelsu
com.google.android.hmal
com.reveny.vbmetafix.service
me.twrp.twrpapp
com.termux
com.slash.batterychargelimit
io.github.vvb2060.keyattestation
io.github.muntashirakon.AppManager
io.github.vvb2060.mahoshojo
com.reveny.nativecheck
icu.nullptr.nativetest
io.github.huskydg.memorydetector
org.akanework.checker
icu.nullptr.applistdetector
io.github.rabehx.securify
krypton.tbsafetychecker
me.garfieldhan.holmes
com.byxiaorun.detector
com.kimchangyoun.rootbeerFresh.sample"

RISKY_COUNT=0

# Check risky packages
for PKG in $RISKY_APPS; do
    if pm list packages | grep -q "$PKG"; then
        RISKY_COUNT=$((RISKY_COUNT + 1))
    fi
done

# Check spoofed apps
for PKG in $(pm list packages -3 | cut -d':' -f2); do
    VERSION=$(dumpsys package "$PKG" | grep versionName | head -n 1 | awk -F= '{print $2}')
    if echo "$VERSION" | grep -qi "spoofed"; then
        RISKY_COUNT=$((RISKY_COUNT + 1))
    fi
done

# Total Modules Count
ALL_COUNT=$(find "$MODULE" -mindepth 1 -maxdepth 1 -type d | wc -l)

# Get system info
DEVICE_MODEL=$(getprop ro.product.system.model)
[ -z "$DEVICE_MODEL" ] && DEVICE_MODEL=$(getprop ro.build.product)
ANDROID_VERSION=$(getprop ro.build.version.release)
SELINUX=$(getenforce)
PATCH=$(getprop ro.build.version.security_patch)
SELINUX_RAW=$(getenforce)
if [ "$SELINUX_RAW" = "Enforcing" ]; then
    SELINUX="🟢"
else
    SELINUX="🔴"
fi

# Get Play Store version
PSTORE_VER=$(dumpsys package com.android.vending 2>/dev/null | grep -m 1 versionName | awk -F= '{print $2}' | awk '{print $1}')
[ -z "$PSTORE_VER" ] && PSTORE_VER="N/A"

# Kernel check
BANNED_KERNELS="AICP arter97 blu_spark CAF cm crDroid crdroid CyanogenMod Deathly EAS eas ElementalX Elite franco hadesKernel Lineage LineageOS mokee MoRoKernel Noble Optimus SlimRoms Sultan"
KERNEL_NAME=$(uname -r)
KERNEL_STATUS="🟢"
for banned in $BANNED_KERNELS; do
    if echo "$KERNEL_NAME" | grep -iqE "(^|[^a-zA-Z0-9])$banned([^a-zA-Z0-9]|$)"; then
        KERNEL_STATUS="🔴"
        break
    fi
done

# TEE status check
TEE_FILE="/data/adb/tricky_store/tee_status"
if [ -f "$TEE_FILE" ]; then
    TEE_VAL=$(grep -m1 "teeBroken=" "$TEE_FILE" | cut -d'=' -f2)
    case "$TEE_VAL" in
        true)  TEE_STATUS="🔴" ;;
        false) TEE_STATUS="🟢" ;;
        *)     TEE_STATUS="🟢" ;;
    esac
else
    TEE_STATUS="🟢"
fi

# ROM signature check
if [ -f /system/etc/security/otacerts.zip ]; then
    ROM_SIGN=$(unzip -l /system/etc/security/otacerts.zip 2>/dev/null | grep -i ".pem" | awk '{print $4}' | head -n 1)
    case "$ROM_SIGN" in
        *release*) ROM_SIGN_STATUS="🟢" ;;
        *test*)    ROM_SIGN_STATUS="🔴" ;;
        *)         ROM_SIGN_STATUS="🟢" ;;
    esac
else
    ROM_SIGN_STATUS="⚪"
fi

# Final description
ALL_MODULES="$ENABLED_LIST"
[ -n "$DISABLED_LIST" ] && ALL_MODULES="$ALL_MODULES | $DISABLED_LIST"
description="description=𝗮𝘀𝘀𝗶𝘀𝘁 𝗺𝗼𝗱𝗲: $ALL_MODULES  | 𝗞𝗲𝗿𝗻𝗲𝗹: $KERNEL_STATUS | 𝗥𝗢𝗠 𝗦𝗶𝗴𝗻: $ROM_SIGN_STATUS | 𝗦𝗘.𝗟𝗶𝗻𝘂𝘅: $SELINUX | 𝗣𝘀𝘁𝗼𝗿𝗲: $PSTORE_VER | 𝗔𝗹𝗹: $ALL_COUNT | 𝗥𝗶𝘀𝗸𝘆: $RISKY_COUNT | A$ANDROID_VERSION $DEVICE_MODEL | 𝗣𝗮𝘁𝗰𝗵: $PATCH" # | 𝗧𝗘𝗘: $TEE_STATUS

# Update module.prop
###chattr -i "$MODDIR/module.prop"
sed -i "s/^description=.*/$description/" "$MODDIR/module.prop"
###chattr +i "$MODDIR/module.prop"

###sh /data/adb/Box-Brain/Integrity-Box-Logs/hello.sh lock
###sh /data/adb/Box-Brain/Integrity-Box-Logs/hello.sh verify
EOF

chmod 755 "$debug/debug.sh"
###chmod 755 "/data/adb/Box-Brain/Integrity-Box-Logs/hello.sh"
chmod 755 "/data/adb/Box-Brain/Integrity-Box-Logs/description.sh"

if [ -f "/data/adb/modules/zygisk/customize.sh" ]; then
  rm -rf "/data/adb/modules/zygisk/customize.sh"
fi

if [ -f "/data/adb/modules/integrity_box/.tamper.log" ]; then
  chattr -i /data/adb/modules/integrity_box/.tamper.log
  rm -rf "/data/adb/modules/integrity_box/.tamper.log"
fi