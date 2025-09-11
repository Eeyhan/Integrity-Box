#!/system/bin/sh

L="/data/adb/Box-Brain/Integrity-Box-Logs/prop_detection.log"
TIME=$(date "+%Y-%m-%d %H:%M:%S")
Q="------------------------------------------"
R="════════════════════════════"

log() { echo -e "$1" | tee -a "$L"; }

# Start fresh
echo -e "$Q" > "$L"
echo -e "- INTEGRITY-BOX PROP DUMP | $TIME" >> "$L"
echo -e "$Q\n" >> "$L"

# Log props by category
print_props() {
    local title="$1"
    shift
    local props="$@"
    log "- $title"
    for prop in $props; do
        value=$(getprop "$prop")
        [ -n "$value" ] && log "   └─ $prop = $value"
    done
    log "$Q\n"
}

# Categories & Props
print_props "Root & Debuggable Props" \
    ro.secure ro.debuggable service.adb.root init.svc.adbd init.svc.magiskd ro.build.selinux ro.boot.selinux

print_props "Verified Boot & AVB Props" \
    ro.boot.verifiedbootstate ro.boot.vbmeta.device_state ro.boot.flash.locked ro.boot.veritymode \
    ro.boot.verifiedstate ro.boot.avb_version

print_props "Build & Signature Info" \
    ro.build.tags ro.build.type ro.build.user ro.build.host \
    ro.build.version.incremental ro.build.version.release \
    ro.build.display.id ro.build.version.security_patch

log "- Emulator / Virtual Machine Check"
SHOW_EMU_SECTION=0
EMULATOR_PROPS="ro.kernel.qemu ro.hardware ro.product.device ro.product.manufacturer"

for prop in $EMULATOR_PROPS; do
    val=$(getprop "$prop")
    case "$val" in
        *goldfish*|*ranchu*|*emulator*|*genymotion*|*vbox*|*qemu*)
            [ "$SHOW_EMU_SECTION" -eq 0 ] && log "- Emulator / Virtual Machine Check" && SHOW_EMU_SECTION=1
            log "   └─ ⚠️ $prop = $val"
            ;;
    esac
done
[ "$SHOW_EMU_SECTION" -eq 1 ] && log "$Q\n"

log "- Play Integrity / SafetyNet Check"
SHOW_INTEGRITY_SECTION=0

FINGERPRINT=$(getprop ro.build.fingerprint | tr '[:upper:]' '[:lower:]')
BRAND=$(getprop ro.product.brand | tr '[:upper:]' '[:lower:]')
MODEL=$(getprop ro.product.model | tr '[:upper:]' '[:lower:]')
MANUFACTURER=$(getprop ro.product.manufacturer | tr '[:upper:]' '[:lower:]')

# Detect spoofed props (e.g., Pixel brand on non-Pixel fingerprint)
if echo "$BRAND" | grep -qE "google|pixel"; then
    if ! echo "$FINGERPRINT" | grep -qE "google|pixel"; then
        [ "$SHOW_INTEGRITY_SECTION" -eq 0 ] && log "- Play Integrity / SafetyNet Check" && SHOW_INTEGRITY_SECTION=1
        log "   └─ ⚠️ Possibly spoofed brand: ro.product.brand = $BRAND"
    fi
fi

if echo "$MODEL" | grep -qE "pixel"; then
    if ! echo "$FINGERPRINT" | grep -qE "google|pixel"; then
        [ "$SHOW_INTEGRITY_SECTION" -eq 0 ] && log "- Play Integrity / SafetyNet Check" && SHOW_INTEGRITY_SECTION=1
        log "   └─ ⚠️ Possibly spoofed model: ro.product.model = $MODEL"
    fi
fi

# Detect missing values
INTEGRITY_PROPS="ro.build.characteristics ro.boot.hardware.keystore ro.product.first_api_level ro.build.flavor"
for prop in $INTEGRITY_PROPS; do
    val=$(getprop "$prop")
    if [ -z "$val" ]; then
        [ "$SHOW_INTEGRITY_SECTION" -eq 0 ] && log "- Play Integrity / SafetyNet Check" && SHOW_INTEGRITY_SECTION=1
        log "   └─ ⚠️ Missing or empty: $prop"
    fi
done

[ "$SHOW_INTEGRITY_SECTION" -eq 1 ] && log "$Q\n"

print_props "Fingerprint & ROM Identity" \
    ro.build.fingerprint ro.system.build.fingerprint ro.product.system.fingerprint \
    ro.system_ext.build.fingerprint ro.vendor.build.fingerprint

print_props "DRM / Keystore / GMS" \
    ro.hardware.keystore drm.service.enabled ro.com.google.gmsversion \
    ro.com.google.clientidbase ro.config.dmverity ro.crypto.state

print_props "OEM / Bootloader State" \
    ro.oem_unlock_supported ro.boot.bootloader ro.boot.bootdevice \
    ro.boot.verifiedboot ro.boot.veritymode ro.boot.slot_suffix

# End
log "- Prop Dump Complete ✅"
echo -e "$R" >> "$L"
log "Log saved to $L"