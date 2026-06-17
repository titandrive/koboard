#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
ANDROID_JAR="$SDK/platforms/android-34/android.jar"
D8="$SDK/build-tools/36.1.0/d8"
JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
JAVAC="${JAVAC:-$JAVA_HOME/bin/javac}"
BUILD="$ROOT/build/android"

rm -rf "$BUILD"
mkdir -p "$BUILD/classes" "$BUILD/dex"

"$JAVAC" -source 8 -target 8 -bootclasspath "$ANDROID_JAR" \
    -d "$BUILD/classes" \
    "$ROOT"/android_src/org/koreader/koboard/*.java

CLASS_FILES=()
while IFS= read -r -d '' class_file; do
    CLASS_FILES+=("$class_file")
done < <(find "$BUILD/classes" -name '*.class' -print0)

JAVA_HOME="$JAVA_HOME" "$D8" --min-api 1 --lib "$ANDROID_JAR" \
    --output "$BUILD/dex" "${CLASS_FILES[@]}"
cp "$BUILD/dex/classes.dex" "$ROOT/build/koboard_ic.dex"
