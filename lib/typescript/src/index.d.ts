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
declare const PARAKEY_ERROR_CODES: readonly ["unlockFailure", "unlockCanceled", "accessNotFound", "invalidCredentials", "invalidTokenBundle", "configureFailure", "sessionMissing", "operationInProgress", "invalidThemeColor", "noAndroidActivity"];
export type ParakeyErrorCode = (typeof PARAKEY_ERROR_CODES)[number];
export interface ParakeyError {
    code: ParakeyErrorCode;
}
export declare function isParakeyError(error: unknown): error is ParakeyError;
declare const Parakey: ParakeyInterface;
export default Parakey;
export declare const configure: (tokenBundle: string) => Promise<void>, deconfigure: () => Promise<void>, showScan: () => Promise<void>, setTheme: (hexColors: {
    actionLight?: string;
    actionDark?: string;
    titleLight?: string;
    titleDark?: string;
}) => Promise<void>, unlock: (deviceID: string) => Promise<void>;
//# sourceMappingURL=index.d.ts.map