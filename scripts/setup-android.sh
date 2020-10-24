#!/bin/sh

set -euo pipefail

npm install -g cordova
npm install -g github:apache/cordova-paramedic

echo "y" | $ANDROID_SDK_ROOT/tools/bin/sdkmanager 'system-images;android-29;google_apis;x86_64'
echo "no" | $ANDROID_SDK_ROOT/tools/bin/avdmanager create avd --force --name test --package 'system-images;android-29;google_apis;x86_64'
