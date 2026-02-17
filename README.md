# parakey-sdk-react-native

The Parakey SDK allows your users to access features of the Parakey ecosystem within your application.

## Requirements

Minimum required React Native version: `0.80.3`

## Installation

```sh
npm install https://github.com/parakey-ab/parakey-sdk-react-native#2.0.0
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

+ pod 'ParakeySDK', :git => 'git@github.com:parakey-ab/parakey-sdk-ios.git', :tag => '1.6.11'

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
+   implementation("co.parakey:sdk:1.17.2")
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
import Parakey from 'parakey-sdk-react-native';

function setup() {
  const tokenBundle = "...."; // acquired through partner API

  try {
    await Parakey.configure(tokenBundle);
  } catch(error) {
    console.log(error.code);
  }
}

function show() {
  try {
    await Parakey.showScan();
  } catch(error) {
    console.log(error.code);
  }
}

function cleanUp() {
  await Parakey.deconfigure();
}
```

## Error handling

Errors returned by the SDK can be identified using the `code` property on the error object.
The `code` is a string corresponding to a `ParakeyError` which you can find in the native [documentation](#documentation).

## Attribution

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
