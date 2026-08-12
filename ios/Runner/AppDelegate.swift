import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // The Google Maps iOS SDK aborts the app with an uncaught NSException the
    // first time a GoogleMap is rendered unless it has been initialized with an
    // API key. Opening the profile (and the edit-location screen) renders a map,
    // which is why the app was closing suddenly on iOS. This is the same key
    // Android uses (AndroidManifest.xml); for the tiles to actually load it must
    // have "Maps SDK for iOS" enabled and either no application restriction or
    // one scoped to the bundle id com.iraq.dinar.
    GMSServices.provideAPIKey("AIzaSyCRd5dwYr2acqEL3ueRObc_4HI4i8bxCfQ")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
