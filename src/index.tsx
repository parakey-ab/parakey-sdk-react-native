import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'parakey-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

interface ParakeyInterface {
  initialize(): Promise<void>;
  configure(tokenBundle: string): Promise<void>;
  deconfigure(): Promise<void>;
  showScan(): Promise<void>;
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
export const { initialize, configure, deconfigure, showScan } = Parakey;
