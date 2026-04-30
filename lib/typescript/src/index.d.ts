interface ParakeyInterface {
    configure(tokenBundle: string): Promise<void>;
    deconfigure(): Promise<void>;
    showScan(): Promise<void>;
    setTheme(hexColors: {
        actionLight?: string;
        actionDark?: string;
        titleLight?: string;
        titleDark?: string;
    }): Promise<void>;
}
declare const Parakey: ParakeyInterface;
export default Parakey;
export declare const configure: (tokenBundle: string) => Promise<void>, deconfigure: () => Promise<void>, showScan: () => Promise<void>, setTheme: (hexColors: {
    actionLight?: string;
    actionDark?: string;
    titleLight?: string;
    titleDark?: string;
}) => Promise<void>;
//# sourceMappingURL=index.d.ts.map