import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import UserNotifications     // ✅ Bildirim API'sı
import CoreLocation          // ✅ Konum API'sı

@main
@objc class AppDelegate: FlutterAppDelegate {
  let locationManager = CLLocationManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Firebase ve Google Maps setup
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyCn74lr8Dcp8CMOvz-VcTEXJshyCSwxFQg")

    // ✅ Flutter pluginleri kaydet
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Flutter ana view controller
    if let controller = window?.rootViewController as? FlutterViewController {

      // 🔔 Notification izin kanalı
      let notificationChannel = FlutterMethodChannel(
        name: "wetieko/notification_permission",
        binaryMessenger: controller.binaryMessenger
      )

      notificationChannel.setMethodCallHandler { (call, result) in
        if call.method == "getNotificationStatus" {
          UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
              switch settings.authorizationStatus {
              case .authorized:
                print("🔔 iOS native: Bildirim izni açık ✅")
                result("authorized")
              case .provisional:
                print("🟡 iOS native: Provisional (sessiz) bildirim izni ✅")
                result("provisional")
              case .denied:
                print("🔕 iOS native: Bildirim izni kapalı ❌")
                result("denied")
              case .notDetermined:
                print("❔ iOS native: Henüz sorulmamış")
                result("notDetermined")
              default:
                result("unknown")
              }
            }
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }

      // 📍 Konum izin kanalı
      let locationChannel = FlutterMethodChannel(
        name: "Wetieko/location_permission",
        binaryMessenger: controller.binaryMessenger
      )

      locationChannel.setMethodCallHandler { (call, result) in
        if call.method == "getLocationStatus" {
          let status = CLLocationManager.authorizationStatus()
          DispatchQueue.main.async {
            switch status {
            case .authorizedAlways:
              print("📍 iOS native: Konum izni - Always ✅")
              result("always")
            case .authorizedWhenInUse:
              print("📍 iOS native: Konum izni - When In Use ✅")
              result("whenInUse")
            case .denied:
              print("🚫 iOS native: Konum izni reddedildi ❌")
              result("denied")
            case .restricted:
              print("⛔️ iOS native: Konum erişimi kısıtlı (ör. aile kontrolü)")
              result("restricted")
            case .notDetermined:
              print("❔ iOS native: Konum izni henüz sorulmamış")
              result("notDetermined")
            @unknown default:
              result("unknown")
            }
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Universal Link’leri destekle
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      print("📲 Universal Link yakalandı: \(url)")

      _ = super.application(
        application,
        continue: userActivity,
        restorationHandler: restorationHandler
      )
      return true
    }
    return false
  }
}
