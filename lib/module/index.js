"use strict";

import { NativeModules, Platform } from 'react-native';
const LINKING_ERROR = `The package 'parakey-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` + Platform.select({
  ios: "- You have run 'pod install'\n",
  default: ''
}) + '- You rebuilt the app after installing the package\n' + '- You are not using Expo Go\n';
const PARAKEY_ERROR_CODES = [
// Native SDK errors
'unlockFailure', 'unlockCanceled', 'accessNotFound', 'invalidCredentials', 'invalidTokenBundle', 'configureFailure', 'sessionMissing', 'operationInProgress',
// Bridge specific errors
'invalidThemeColor', 'noAndroidActivity'];
export function isParakeyError(error) {
  return typeof error === 'object' && error !== null && 'code' in error && typeof error.code === 'string' && PARAKEY_ERROR_CODES.includes(error.code);
}
const Parakey = NativeModules.ParakeyBridge ? NativeModules.ParakeyBridge : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
export default Parakey;
export const {
  configure,
  deconfigure,
  showScan,
  setTheme,
  unlock
} = Parakey;
//# sourceMappingURL=index.js.map