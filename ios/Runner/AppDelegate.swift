import UIKit
import Flutter
import os.log

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)
    
    
    
       let channelName = "tips.word.wordfinderx/image"
       let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
       
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController as! FlutterBinaryMessenger)

       methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
           if (call.method == "find_board") {
            
            let argsMap = call.arguments as! NSDictionary
                
            let path = argsMap.value(forKey: "filePath") as? String
            
            let image = UIImage(named: path ?? "")
            
            var directory = self.getDocumentsDirectory();
            //var outputPath = directory.absoluteString;
            
            
            let randomString = UUID().uuidString;
            
            var outputPath = "image"+randomString+".png";
            
            //this is response.
            let output = LaneDetectorBridge().detectLane(in: image)
    
            //let newImage = OpenCVWrapper.getGrayScale(image)
            
           // let p1 = newImage.path;
            
            var p :String = "";
            
            if let data = output?.pngData() {
                let filename = self.getDocumentsDirectory().appendingPathComponent(outputPath)
                print("path sent back to flutter \(filename.path ?? "no path found")")
                p = filename.path;
                    try? data.write(to: filename)
                }
            
            
        
            //path being returned is invalid probably
            
            //let me fix this.
            
           // print("path sent by flutter \(output ?? "no path found")")
            
            result(p)
            
    
           }
       }
    
    
    
    
    
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
