#!/bin/bash

# Set destination folder
DESTINATION="$HOME/Downloads"

# Check if adb is installed
if ! command -v adb &> /dev/null; then
    echo "ADB not found! Please install it using 'brew install android-platform-tools'."
    exit 1
fi

# Check if a device is connected
if ! adb devices | grep -q "device$"; then
    echo "No device detected! Please connect your device and enable USB debugging."
    exit 1
fi

# Get the package name from user
read -p "Enter the package name of the app (e.g., com.example.app): " PACKAGE

# Find the APK path on the device
APK_PATH=$(adb shell pm path "$PACKAGE" | awk -F':' '{print $2}' | tr -d '\r')

# Check if APK path is found
if [ -z "$APK_PATH" ]; then
    echo "Failed to find APK for package: $PACKAGE"
    exit 1
fi

# Set the output filename
APK_FILENAME="${PACKAGE}.apk"

# Pull the APK to the Downloads folder with the package name as the filename
echo "Pulling APK from device..."
adb pull "$APK_PATH" "$DESTINATION/$APK_FILENAME"

echo "APK saved as $APK_FILENAME in $DESTINATION"
