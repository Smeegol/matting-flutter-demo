import Flutter
import UIKit
import opencv2

public class MattingPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "matting_plugin", binaryMessenger: registrar.messenger())
        let instance = MattingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "startMatting":
            result(startMatting(call.arguments))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startMatting(_ arguments: Any?) -> String? {
        guard let dict = arguments as? [String: Any],
              let originPath = dict["originPath"] as? String,
              let maskPath = dict["maskPath"] as? String else {
            print("Params not satisfied")
            return nil
        }
        
        let originMat = Imgcodecs.imread(filename: originPath, flags: ImreadModes.IMREAD_COLOR.rawValue)
        let maskMat = Imgcodecs.imread(filename: maskPath, flags: ImreadModes.IMREAD_GRAYSCALE.rawValue)
        if originMat.empty() || originMat.empty() {
            print("Images not found")
            return nil
        }
        if originMat.width() != maskMat.width() || originMat.height() != maskMat.height() {
            print("Images' sizes not same")
            return nil
        }
        
        let customMaskMat = customMask(maskMat: maskMat)
        let resultMat = applyMask(originMat: originMat, maskMat: customMaskMat)
        
        guard let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Caches directory path not found")
            return nil
        }
        let fileURL = cachePath.appendingPathComponent("result.png")
        let result = Imgcodecs.imwrite(filename: fileURL.relativePath, img: resultMat)
//        let params = IntVector([ImwriteFlags.IMWRITE_PNG_COMPRESSION.rawValue, 0,
//                                ImwriteFlags.IMWRITE_PNG_STRATEGY.rawValue, ImwritePNGFlags.IMWRITE_PNG_STRATEGY_DEFAULT.rawValue])
//        let result = Imgcodecs.imwrite(filename: fileURL.relativePath, img: resultMat, params: params)
        if result {
            return fileURL.relativePath
        } else {
            print("Save to Caches directory failed")
            return nil
        }
    }
    
    private func customMask(maskMat: Mat) -> Mat {
        let newMaskMat = maskMat
        
//        // Gaussian Blur
//        let newMaskMat = Mat()
//        Imgproc.GaussianBlur(src: maskMat, dst: newMaskMat, ksize: Size(width: 15, height: 15), sigmaX: 0)
        
//        // Bilateral Filtering
//        let newMaskMat = Mat()
//        Imgproc.bilateralFilter(src: maskMat, dst: newMaskMat, d: 15, sigmaColor: 75, sigmaSpace: 75)
        
//        Imgproc.threshold(src: newMaskMat, dst: newMaskMat, thresh: 127, maxval: 255, type: ThresholdTypes.THRESH_BINARY)
        
        return newMaskMat
    }
    
    private func applyMask(originMat: Mat, maskMat: Mat) -> Mat {
        let resultMat = Mat(size: originMat.size(), type: CvType.CV_8UC4, scalar: Scalar(0, 0, 0, 0))
        let rgbResultMat = Mat(size: originMat.size(), type: CvType.CV_8UC3)
        originMat.copy(to: rgbResultMat, mask: maskMat)
        
        var rgbaChannels = Array(repeating: Mat(), count: 4)
        Core.split(m: rgbResultMat, mv: &rgbaChannels)
        
        let alphaChannel = Mat()
        maskMat.convert(to: alphaChannel, rtype: CvType.CV_8UC1)
        rgbaChannels.append(alphaChannel)
        
        Core.merge(mv: rgbaChannels, dst: resultMat)
        return resultMat
    }
    
}
