#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

validate_semver() {
  if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid format"
    exit 1
  fi
}

replace_version() {
  local file=$1
  local query=$2
  local new_version=$3

  sed -i '' "/$query/s/[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/$new_version/" "$file"

  if ! [ $? -eq 0 ]; then
    echo "Couldn't update $file_path"
    exit 1
  fi
}

read -p "Enter react-native version (x.y.z): " react_native_version
validate_semver $react_native_version;
read -p "Enter android version (x.y.z): " android_version
validate_semver $android_version;
read -p "Enter iOS version (x.y.z): " ios_version
validate_semver $ios_version;

replace_version 'README.md' 'npm install' $react_native_version
replace_version 'package.json' '^[[:space:]][[:space:]]"version":' $react_native_version

replace_version 'android/build.gradle' 'sdk' $android_version

replace_version 'README.md' 'ParakeySDK' $ios_version
replace_version 'example/ios/podfile' 'ParakeySDK' $ios_version
echo -e "${GREEN}All files updated${RESET}"

echo -e ""
echo -e "${YELLOW}Make sure to run 'pod install' in 'example/ios' to update all lock files${RESET}"
echo -e "Once pushed, create github release with version: $react_native_version"
