#!/bin/bash

# Interactive steps for setting up a fresh RN project with the Paraket RN SDK
#
# NOTE:
#   Automating this fully with git patches turned out complicated as differnt RN verions
#   vary their file content just enough to make generating clean patches not possible

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo "Setup a new react-native project, ommit '--version' for latest"
echo_green "npx @react-native-community/cli@latest init ParakeyReactSample --version X.X.X"
prompt_enter_to_continue

echo "Add React Native adapter to package.json 'dependencies', set version accordingly"
echo_green '"parakey-sdk-react-native": "github:parakey-ab/parakey-sdk-react-native#1.1.2",'
prompt_enter_to_continue

echo "Add to ios/Podfile, update version accordingly"
echo_grey "config = use_native_modules!"
echo_green "pod 'ParakeySDK', :git => 'git@github.com:parakey-ab/parakey-sdk-ios.git', :tag => '0.19.1'"
echo_grey "use_react_native!("
prompt_enter_to_continue

echo "Add to Info.plist dict"
text="$(cat <<'EOF'
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
	<string>co.parakey.updateSecurity</string>
	<string>co.parakey.updateAccess</string>
</array>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Parakey uses Bluetooth in order to discover and interact with locks</string>
<key>NSFaceIDUsageDescription</key>
<string>Certain locks require biometric authentication in order to unlock</string>
<key>UIBackgroundModes</key>
<array>
	<string>bluetooth-central</string>
	<string>processing</string>
	<string>fetch</string>
</array>
EOF
)"
echo_green "$text"
prompt_enter_to_continue

echo "Add to app delegate"
echo_green "import ParakeySDK"
echo_green "Parakey.shared.initialize()"
prompt_enter_to_continue

echo "Add to root build.gradle"
text="$(cat <<'EOF'
allprojects {
  repositories {
    google()
    mavenCentral()
    maven {
      url = uri( "https://maven.pkg.github.com/parakey-ab/parakey-sdk-android")
      credentials {
          username = System.getenv("GITHUB_USER")
          password = System.getenv("GITHUB_TOKEN")
      }
    }
  }
}
EOF
)"
echo_green "$text"
prompt_enter_to_continue
