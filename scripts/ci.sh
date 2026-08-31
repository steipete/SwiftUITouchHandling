#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p build
work_dir=$(mktemp -d "$PWD/build/ci.XXXXXX")
device_id=""
cleanup() {
    if [[ -n "$device_id" ]]; then
        xcrun simctl shutdown "$device_id" >/dev/null 2>&1 || true
        xcrun simctl delete "$device_id"
    fi
    rm -rf "$work_dir"
}
trap cleanup EXIT

runtime=${SIMULATOR_RUNTIME:-com.apple.CoreSimulator.SimRuntime.iOS-26-5}
device_id=$(xcrun simctl create SwiftUITouchHandling-CI com.apple.CoreSimulator.SimDeviceType.iPhone-17 "$runtime")
xcrun simctl boot "$device_id"
xcrun simctl bootstatus "$device_id" -b
xcodebuild -version

build_args=(
    -project SwiftUITouchHandling.xcodeproj
    -scheme SwiftUITouchHandling
    -derivedDataPath "$work_dir/DerivedData"
    CODE_SIGNING_ALLOWED=NO
)

xcodebuild "${build_args[@]}" -configuration Debug \
    -destination "platform=iOS Simulator,id=$device_id" \
    -parallel-testing-enabled NO test

xcodebuild "${build_args[@]}" -configuration Release \
    -destination 'generic/platform=iOS' build

xcodebuild "${build_args[@]}" -configuration Release \
    -destination "platform=iOS Simulator,id=$device_id" build

app_path="$work_dir/DerivedData/Build/Products/Release-iphonesimulator/SwiftUITouchHandling.app"
xcrun simctl install "$device_id" "$app_path"
launch_output=$(xcrun simctl launch --terminate-running-process "$device_id" com.steipete.SwiftUITouchHandling)
printf '%s\n' "$launch_output"
app_pid=${launch_output##*: }
if [[ ! "$app_pid" =~ ^[1-9][0-9]*$ ]]; then
    echo 'Simulator did not return an application PID.' >&2
    exit 1
fi
sleep 3
kill -0 "$app_pid"
echo 'Live smoke passed: Release app remains running after 3 seconds.'
