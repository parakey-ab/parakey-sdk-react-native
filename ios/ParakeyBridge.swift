import ParakeySDK

@objc(ParakeyBridge)
class ParakeyBridge: NSObject {
  @objc(initialize:withRejecter:)
  func initialize(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    // no-op, initialization performed in AppDelegate
    // present only for symmetry with Android
    resolve(nil)
  }

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
    reject: @escaping RCTPromiseRejectBlock
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
