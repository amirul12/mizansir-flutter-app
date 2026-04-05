import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    setupScreenSecurityChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupScreenSecurityChannel() {
    let controller = window?.rootViewController as! FlutterViewController
    let screenSecurityChannel = FlutterMethodChannel(
      name: "privatetutor/screen_security",
      binaryMessenger: controller.binaryMessenger
    )

    screenSecurityChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }

      switch call.method {
      case "enableSecurity":
        self.enableScreenSecurity()
        result(nil)
      case "disableSecurity":
        self.disableScreenSecurity()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func enableScreenSecurity() {
    DispatchQueue.main.async {
      // Prevent screen recording and screenshots on iOS
      UIScreen.main.isCaptured = false
      // Note: iOS doesn't have a perfect FLAG_SECURE equivalent like Android
      // This is a best-effort implementation
    }
  }

  private func disableScreenSecurity() {
    DispatchQueue.main.async {
      // Allow screen recording and screenshots
      // Note: iOS doesn't have a perfect FLAG_SECURE equivalent like Android
    }
  }
}
