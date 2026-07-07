# parakey-sdk-react-native

The Parakey SDK allows your users to access features of the Parakey ecosystem within your application.

## Requirements

Minimum required React Native version: `0.80.3`

## Installation

```sh
npm install https://github.com/parakey-ab/parakey-sdk-react-native#2.2.2
```

## Documentation

Documentation can be found in the Parther API specification and repositories for respective native package

- [Partner API](https://assets.parakey.co/api/partner/index.html)
- [Android](https://github.com/parakey-ab/parakey-sdk-android)
- [iOS](https://github.com/parakey-ab/parakey-sdk-ios)

Instructions below specify additional steps for each platform

## iOS

- Add `ParakeySDK` to your `podfile` and run `pod install`

```diff
config = use_native_modules!

+ pod 'ParakeySDK', :git => 'git@github.com:parakey-ab/parakey-sdk-ios.git', :tag => '1.14.6'

use_react_native!(
```

- Parakey relies on background jobs which have to register handlers during application launch. A call to `Parakey.shared.initialize()` must be present in your `AppDelegate`.

```diff
+ import ParakeySDK

@main
class AppDelegate: RCTAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
+   Parakey.shared.initialize()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

- Refer to the native [documentation](#documentation) and update your `Info.plist` with additional required properties

## Android

- Update your root `build.gradle` with:

```diff
buildscript {
    ext {
-       minSdkVersion = 26
-       compileSdkVersion = 35
-       targetSdkVersion = 35
+       minSdkVersion = 26
+       compileSdkVersion = 36
+       targetSdkVersion = 36
    }
}

+ allprojects {
+   repositories {
+     google()
+     mavenCentral()
+     maven {
+       url = uri( "https://maven.pkg.github.com/parakey-ab/parakey-sdk-android")
+       credentials {
+           username = System.getenv("GITHUB_USER")
+           password = System.getenv("GITHUB_TOKEN")
+       }
+     }
+   }
+ }
```

- Update your `app/build.gradle` with:

```diff
dependencies {
+   implementation("co.parakey:sdk:1.22.8")
}
```

- Parakey must be initialized early in the application lifecycle via a call to `Parakey.initialize(this)` in the `onCreate` callback of the `Application`

```diff
+ import co.parakey.sdk.Parakey

class MainApplication : Application(), ReactApplication {
    override fun onCreate() {
        super.onCreate()
+       Parakey.initialize(this)
        loadReactNative(this)
    }
}
```

## Usage

```js
import Parakey, { isParakeyError } from 'parakey-sdk-react-native';

async function setup() {
  const tokenBundle = "...."; // acquired through partner API

  try {
    await Parakey.configure(tokenBundle);
  } catch(error) {
    handleError(error);
  }
}

async function show() {
  try {
    await Parakey.showScan();
  } catch(error) {
    handleError(error);
  }
}

async function unlock() {
  try {
    await Parakey.unlock("device-id");
  } catch(error) {
    handleError(error);
  }
}

function handleError(error) {
  if (isParakeyError(error)) {
    console.log("Parakey error", error.code);
  } else {
    console.log("Unknown error", error);
  }
}

async function cleanUp() {
  await Parakey.deconfigure();
}

async function theme() {
  // Colors are hex strings: RRGGBB or RRGGBBAA (# prefix optional).
  // Invalid hex rejects the promise with code invalidThemeColor.
  await Parakey.setTheme({
    actionLight: '#0055FF',
    actionDark: '#4499FF',
    titleLight: '#111111',
    titleDark: '#FFFFFF',
  });
}
```

## Error handling

Rejected promises carry a `ParakeyError` with a `code` (see the `ParakeyErrorCode` type for all codes, and the native [documentation](#documentation) for their meaning).
Use the `isParakeyError` type guard to narrow a caught error:

```ts
import { isParakeyError } from 'parakey-sdk-react-native';

try {
  await Parakey.unlock('device-id');
} catch (error) {
  if (isParakeyError(error)) {
    console.log(error.code); // e.g. "unlockFailure"
  }
}
```

## Attribution

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
