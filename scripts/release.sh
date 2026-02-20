#!/bin/bash
# Updates RN adapater version and native SDK versions in preparation for github release

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

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

read_react_native_version
read_android_version
read_ios_version

replace_version 'README.md' 'npm install' $react_native_version
replace_version 'README.md' 'co.parakey:sdk:' $android_version
replace_version 'package.json' '^[[:space:]][[:space:]]"version":' $react_native_version

replace_version 'android/build.gradle' 'sdk' $android_version
replace_version 'example/android/app/build.gradle' 'sdk' $android_version

replace_version 'README.md' 'ParakeySDK' $ios_version
replace_version 'example/ios/podfile' 'ParakeySDK' $ios_version

replace_version 'scripts/generate_test_project.sh' 'parakey-sdk-react-native' $react_native_version
replace_version 'scripts/generate_test_project.sh' 'parakey-sdk-ios' $ios_version
replace_version 'scripts/generate_test_project.sh' 'co.parakey:sdk' $android_version

echo_green "All files updated"

echo -e ""
echo_yellow "Make sure to run 'pod install' in 'example/ios' to update all lock files"
echo -e "Once pushed, create github release with version: $react_native_version"
