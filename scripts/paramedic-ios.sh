#!/bin/sh

set -euo pipefail

cordova-paramedic --cleanUpAfterRun --platform ios --plugin .
