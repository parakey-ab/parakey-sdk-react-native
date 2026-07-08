import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'parakey-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

interface ParakeyInterface {
  configure(tokenBundle: string): Promise<void>;
  deconfigure(): Promise<void>;
  showScan(): Promise<void>;
  unlock(deviceID: string): Promise<void>;
  setTheme(hexColors: {
    actionLight?: string;
    actionDark?: string;
    titleLight?: string;
    titleDark?: string;
  }): Promise<void>;
}

const PARAKEY_ERROR_CODES = [
  'unlockFailure',
  'unlockCanceled',
  'accessNotFound',
  'invalidCredentials',
  'invalidTokenBundle',
  'configureFailure',
  'sessionMissing',
  'invalidThemeColor',
  'noAndroidActivity',
  'operationInProgress',
] as const;

export type ParakeyErrorCode = (typeof PARAKEY_ERROR_CODES)[number];

export interface ParakeyError {
  code: ParakeyErrorCode;
}

export function isParakeyError(error: unknown): error is ParakeyError {
  return (
    typeof error === 'object' &&
    error !== null &&
    'code' in error &&
    typeof (error as any).code === 'string' &&
    PARAKEY_ERROR_CODES.includes((error as any).code)
  );
}

const Parakey: ParakeyInterface = NativeModules.ParakeyBridge
  ? NativeModules.ParakeyBridge
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default Parakey;
export const { configure, deconfigure, showScan, setTheme, unlock } = Parakey;
