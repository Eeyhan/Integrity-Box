#!/system/bin/sh

UPDATE="/data/adb/modules_update/zygisk"
HASHFILE="$UPDATE/meow"

[ ! -f "$HASHFILE" ] && echo "❌ Missing hash file: $HASHFILE" && exit 1

FAIL=0
PASS=0

while IFS='|' read -r RELPATH MD5_HASH SHA1_HASH SHA256_HASH SHA512_HASH SALT_FIELD; do
    FILE="$UPDATE/$RELPATH"
    [ ! -f "$FILE" ] && FAIL=$((FAIL+1)) && continue

    # Extract expected hashes
    EXPECT_MD5=${MD5_HASH#SPIDERMAN:}
    EXPECT_SHA1=${SHA1_HASH#SUPERMAN:}
    EXPECT_SHA256=${SHA256_HASH#BATMAN:}
    EXPECT_SHA512=${SHA512_HASH#IRONMAN:}
    SALT=${SALT_FIELD#BY:}

    # Compute actual hashes with salt
    ACTUAL_MD5=$( (echo -n "$SALT" && cat "$FILE") | md5sum | awk '{print $1}' )
    ACTUAL_SHA1=$( (echo -n "$SALT" && cat "$FILE") | sha1sum | awk '{print $1}' )
    ACTUAL_SHA256=$( (echo -n "$SALT" && cat "$FILE") | sha256sum | awk '{print $1}' )
    ACTUAL_SHA512=$( (echo -n "$SALT" && cat "$FILE") | sha512sum | awk '{print $1}' )

    if [ "$ACTUAL_MD5" = "$EXPECT_MD5" ] && \
       [ "$ACTUAL_SHA1" = "$EXPECT_SHA1" ] && \
       [ "$ACTUAL_SHA256" = "$EXPECT_SHA256" ] && \
       [ "$ACTUAL_SHA512" = "$EXPECT_SHA512" ]; then
        PASS=$((PASS+1))
    else
        FAIL=$((FAIL+1))
    fi
done < "$HASHFILE"

echo "-------------------------------"
echo " ♞ Files Verified: $((PASS + FAIL))"
echo " ✔ Passed: $PASS"
echo " ✘ Failed: $FAIL"
echo "-------------------------------"
[ $FAIL -eq 0 ] || exit 1