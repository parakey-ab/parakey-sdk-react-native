import ParakeySDK
import UIKit

@objc(ParakeyBridge)
class ParakeyBridge: NSObject {
    @objc(configure:withResolver:withRejecter:)
    func configure(
        tokenBundle: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        Parakey.shared.configure(
            tokenBundle: tokenBundle,
            completion: callback(resolve: resolve, reject: reject)
        )
    }

    @objc(deconfigure:withRejecter:)
    func deconfigure(
        resolve: @escaping RCTPromiseResolveBlock,
        reject _: @escaping RCTPromiseRejectBlock
    ) {
        Parakey.shared.deconfigure()
        resolve(nil)
    }

    @objc(showScan:withRejecter:)
    func showScan(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        Parakey.shared.showScan(completion: callback(resolve: resolve, reject: reject))
    }

    @objc(setTheme:withResolver:withRejecter:)
    func setTheme(
        hexColors: NSDictionary,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        do {
            Parakey.shared.theme(
                action: try color(light: "actionLight", dark: "actionDark"),
                title: try color(light: "titleLight", dark: "titleDark")
            )
            resolve(nil)
        } catch {
            reject("INVALID_THEME_COLOR", nil, nil)
        }

        func color(light: String, dark: String) throws -> UIColor? {
            dynamicColor(light: try getColor(light), dark: try getColor(dark))
        }

        func getColor(_ name: String) throws -> UIColor? {
            guard let hexColor = hexColors[name] as? String else { return nil }
            guard let color = UIColor(hex: hexColor) else { throw NSError() }
            return color
        }
    }

    private func callback(
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) -> (ParakeyError?) -> Void {
        { error in
            if let error {
                reject(String(describing: error), nil, error)
                return
            }

            resolve(nil)
        }
    }
}


private extension UIColor {
    convenience init?(hex: String) {
        let hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: ["#"])

        guard [6, 8].contains(hex.count), let value = UInt64(hex, radix: 16) else {
            return nil
        }

        let hasAlpha = hex.count == 8
        self.init(
            red:   component(value, shift: hasAlpha ? 24 : 16),
            green: component(value, shift: hasAlpha ? 16 : 8),
            blue:  component(value, shift: hasAlpha ? 8 : 0),
            alpha: hasAlpha ? component(value, shift: 0) : 1
        )

        func component(_ value: UInt64, shift: Int) -> CGFloat {
            CGFloat((value >> shift) & 0xFF) / 255
        }
    }
}

private func dynamicColor(light: UIColor?, dark: UIColor?) -> UIColor? {
    guard let light, let dark else { return light ?? dark }
    return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
}

