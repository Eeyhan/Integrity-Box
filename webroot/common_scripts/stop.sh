#!/system/bin/sh

file="/sdcard/stop"
shamiko="/data/adb/shamiko/whitelist"
nohello="/data/adb/nohello/whitelist"

popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n imagine.detecting.ablank.app/mona.meow.MainActivity > /dev/null
    sleep 0.5
}

# Create the stop file
if ! touch "$file"; then
  popup "❌ Failed to create stop file"
  exit 1
#else
#   popup "✅ Auto Whitelist Mode disabled"
fi

# Delete Shamiko whitelist if it exists
[ -f "$shamiko" ] && {
  rm -f "$shamiko"
  popup "🛑 Shamiko auto-whitelist stopped"
}

# Delete NoHello whitelist if it exists
[ -f "$nohello" ] && {
  rm -f "$nohello"
  popup "🛑 NoHello auto-whitelist stopped"
}

exit 0