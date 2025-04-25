interface ParakeyInterface {
    initialize(): Promise<void>;
    configure(tokenBundle: string): Promise<void>;
    deconfigure(): Promise<void>;
    showScan(): Promise<void>;
}
declare const Parakey: ParakeyInterface;
export default Parakey;
export declare const initialize: () => Promise<void>, configure: (tokenBundle: string) => Promise<void>, deconfigure: () => Promise<void>, showScan: () => Promise<void>;
//# sourceMappingURL=index.d.ts.map