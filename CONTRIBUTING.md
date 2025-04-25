## Development workflow

This project is a monorepo managed using [Yarn workspaces](https://yarnpkg.com/features/workspaces). It contains the following packages:

> Since the project relies on Yarn workspaces, you cannot use [`npm`](https://github.com/npm/cli) for development.

- The library package in the root directory.
- An example app in the `example/` directory.

To get started with the project, run `yarn` in the root directory to install the required dependencies for each package:

```sh
yarn
```

The [example app](/example/) demonstrates usage of the library. You need to run it to test any changes you make.

It is configured to use the local version of the library, so any changes you make to the library's source code will be reflected in the example app. Changes to the library's JavaScript code will be reflected in the example app without a rebuild, but native code changes will require a rebuild of the example app.

If you want to use Android Studio or XCode to edit the native code, you can open the `example/android` or `example/ios` directories respectively in those editors. To edit the Objective-C or Swift files, open `example/ios/ParakeySdkReactNativeExample.xcworkspace` in XCode and find the source files at `Pods > Development Pods > parakey-sdk-react-native`.

To edit the Java or Kotlin files, open `example/android` in Android studio and find the source files at `parakey-sdk-react-native` under `Android`.

You can use various commands from the root directory to work with the project.

To start the packager:

```sh
yarn example start
```

To run the example app on Android:

```sh
yarn example android
```

To run the example app on iOS:

```sh
yarn example ios
```

Make sure your code passes TypeScript and ESLint. Run the following to verify:

```sh
yarn typecheck
yarn lint
```

To fix formatting errors, run the following:

```sh
yarn lint --fix
```

Before commiting changes to the TypeScript interface build the library:
```sh
yarn build
```

Update native library versions in:
- `example/ios/podfile`
- `android/build.gradle`

Update react-native package in:
- `package.json`

### Scripts

The `package.json` file contains various scripts for common tasks:

- `yarn`: setup project by installing dependencies.
- `yarn typecheck`: type-check files with TypeScript.
- `yarn lint`: lint files with ESLint.
- `yarn example start`: start the Metro server for the example app.
- `yarn example android`: run the example app on Android.
- `yarn example ios`: run the example app on iOS.
