import Cocoa
import FlutterMacOS
import AVFoundation

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationDidBecomeActive(_ notification: Notification) {
        guard let viewController = NSApplication.shared.mainWindow?.contentViewController as? FlutterViewController else {
            return
        }

        // Microphone access method channel
        let microphoneChannel = FlutterMethodChannel(name: "microphone_access_macos",
                                                     binaryMessenger: viewController.engine.binaryMessenger)
        microphoneChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "requestPermission") {
                AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                    result(granted)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        // File access method channel
        let fileAccessChannel = FlutterMethodChannel(name: "file_access_macos",
                                                     binaryMessenger: viewController.engine.binaryMessenger)
        fileAccessChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "requestPermission") {
                let panel = NSOpenPanel()
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.allowsMultipleSelection = false
                panel.begin { (response) -> Void in
                    if response == .OK {
                        result(true)
                    } else {
                        result(false)
                    }
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
    }
}
