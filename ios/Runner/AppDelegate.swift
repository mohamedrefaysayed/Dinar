import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // The app draws its maps with OpenStreetMap tiles through flutter_map, so
    // there is no Google Maps SDK to initialize here and no API key to keep in
    // the binary. The "open in Google Maps" navigation buttons are plain
    // https://www.google.com/maps?q=... links handed to url_launcher, which
    // needs no SDK.
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
