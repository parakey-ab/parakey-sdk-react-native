# parakey-sdk-react-native

The Parakey SDK allows your users to access features of the Parakey ecosystem within your application.

## Installation

```sh
npm install https://github.com/parakey-ab/parakey-sdk-react-native#1.0.0
```

## Documentation

Detailed documentation can be found in repositories corresponding to respective native package

- [Android](https://github.com/parakey-ab/parakey-sdk-android)
- [iOS](https://github.com/parakey-ab/parakey-sdk-ios)

Instructions below specify additional steps for each platform

## iOS

- Add `ParakeySDK` dependency to your iOS project and run `pod install`

  ```ruby
  # Podfile

  # ...
  config = use_native_modules!

  pod 'ParakeySDK', :git => 'git@github.com:parakey-ab/parakey-sdk-ios.git', :tag => '0.8.1'

  use_react_native!(
  # ...
  ```

- Parakey relies on background jobs which have to register handlers during application launch. A call to `Parakey.shared.initalize()` must be present in your `AppDelegate`.

  ```swift
  // AppDelegate.swift

  import ParakeySDK

  @main
  class AppDelegate: RCTAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      // ...
      Parakey.shared.initialize()
      // ...
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  ```

- Refer to the native [documentation](#documentation) and update your `Info.plist` with additonal required properties

## Android

- Update your root `build.gradle` with:

```gradle
 allprojects {
   repositories {
     google()
     mavenCentral()
     maven {
       url = uri( "https://maven.pkg.github.com/parakey-ab/parakey-sdk-android")
       credentials {
         username = providers.environmentVariable("GITHUB_USER").get()
         password = providers.environmentVariable("GITHUB_TOKEN").get()
       }
     }
   }
 }
```

## Usage

```js
import Parakey from 'parakey-sdk-react-native';

function setup() {
  const token = "...."; // acquired through api integration
  await Parakey.initialize();

  try {
    await Parakey.configure(token);
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
The `code` is a string correspodning to a `ParakeyError` which you can find in the native [documentation](#documentation).

## Attribution

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
