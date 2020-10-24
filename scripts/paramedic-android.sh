#!/bin/sh

set -euo pipefail

$ANDROID_SDK_ROOT/emulator/emulator -list-avds
echo "Starting emulator..."
nohup $ANDROID_SDK_ROOT/emulator/emulator -avd test -no-audio -no-snapshot -no-window > /dev/null 2>&1 &
$ANDROID_SDK_ROOT/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed | tr -d '\r') ]]; do sleep 1; done; input keyevent 82'
$ANDROID_SDK_ROOT/platform-tools/adb devices
echo "Emulator started"

cordova-paramedic --cleanUpAfterRun --platform android --plugin .
