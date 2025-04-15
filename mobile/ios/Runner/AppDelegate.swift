import UIKit
import Flutter
import flutter_local_notifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Set the API key for Google Maps
    GMSServices.provideAPIKey("AIzaSyBuzx5SWnDiopA8ZyssPuP0PdWEJRGHmOA")

    // Register plugins

    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        if error == nil {
            if success {
                print("Permission granted")
                // Register for remote notifications
                let application = UIApplication.shared
                application.registerForRemoteNotifications()
            } else {
                print("Permission denied")
            }
        } else {
            print(error!)
        }
    }

    // Set up FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    // Set notification delegate for iOS 10+
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
