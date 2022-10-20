//
//  Utility.swift

import UIKit
import SwiftUI


//MARK: - Variable Declaration
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
var hud : MBProgressHUD = MBProgressHUD()
var strDeviceUUID : String!

struct Utility {
    
    //MARK: - Show/Hide Loader Method
    func showLoader() {
        DispatchQueue.main.async {
            //            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            hud = MBProgressHUD.showAdded(to: UIApplication.shared.windows.first!, animated: true)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            //            if UIApplication.shared.isNetworkActivityIndicatorVisible {
            //                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //            }
            hud.removeFromSuperview()
        }
    }
    
    //MARK: - WSFail Response Method
    func wsFailResponseMessage(responseData : AnyObject) -> String {
        
        var strResponseData = String()
        
        if let tempResponseData = responseData as? String {
            strResponseData = tempResponseData
        }
        
        if(isObjectNotNil(object: strResponseData as AnyObject)) && strResponseData != "" {
            return responseData as! String
        } else {
            return "Something went wrong, please try after some time"
        }
    }
    
    //MARK: - Check Null or Nil Object
    func isObjectNotNil(object:AnyObject!) -> Bool {
        if let _:AnyObject = object
        {
            return true
        }
        
        return false
    }
    /// This function set empty Image and message for UITableView by passing message.
    /// - Parameters:
    ///   - image: Image displayed, That going to display when no data in UITableView
    ///   - message1: Empty message, That going to display when no data in UITableView (Defult: "No Result Found.")
    ///   - message2: Empty message, That going to display when no data in UITableView (Defult: "No Result Found.")
    ///   - arr: Array which is used in displaying UITableView
    ///   - tbl: UITableView
    ///   - separatorStyle: UITableViewCell.SeparatorStyle
    static func tblEmptyBackground<T>(_ image: UIImage, message1: String = "No Result Found.",message2: String = "No Result Found." , arr : Array<T>, tbl: UITableView, separatorStyle : UITableViewCell.SeparatorStyle = .none) -> Int{
        
        if arr.count > 0 {
            tbl.backgroundView = nil
            tbl.separatorStyle = separatorStyle
            return 1
            
        }
        
        let noDataView : UIView = UIView()
        tbl.backgroundView = noDataView
        noDataView.anchor(top: tbl.topAnchor, left: tbl.leftAnchor, bottom: tbl.bottomAnchor, right: tbl.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: tbl.bounds.size.width, heightConstant: tbl.bounds.size.height)
        
        let noDataImage : UIImageView = UIImageView(image: image)
        noDataImage.contentMode = .scaleAspectFill
        noDataView.addSubview(noDataImage)
        noDataImage.anchorCenterXToSuperview()
        noDataImage.anchor(top: noDataView.topAnchor, topConstant: noDataView.bounds.size.width/4, widthConstant: noDataView.bounds.size.width/2, heightConstant: noDataView.bounds.size.width/2)
        
        let noDataLabel1 : UILabel = UILabel()
        noDataLabel1.text = message1
        noDataLabel1.textColor = .black
        noDataLabel1.numberOfLines = 0
        noDataLabel1.font = UIFont.poppinsTextMedium(size: 16)
        noDataLabel1.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel1)
        noDataLabel1.anchor(top: noDataImage.bottomAnchor, left: noDataView.leftAnchor, right: noDataView.rightAnchor, topConstant: 10, leftConstant: 15, rightConstant: 15)
        
        let noDataLabel2 : UILabel = UILabel()
        noDataLabel2.text = message2
        noDataLabel2.textColor = .gray
        noDataLabel2.numberOfLines = 0
        noDataLabel2.font = UIFont.poppinsTextMedium(size: 14)
        noDataLabel2.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel2)
        noDataLabel2.anchor(top: noDataLabel1.bottomAnchor, left: noDataView.leftAnchor, right: noDataView.rightAnchor, topConstant: 10, leftConstant: 15, rightConstant: 15)
        
        return 0
    }
    /// This function set empty message for UITableView by passing message.
    /// - Parameters:
    ///   - message: Empty message, That going to display when no data in UITableView (Defult: "No Result Found.")
    ///   - arr: Array which is used in displaying UITableView
    ///   - tbl: UITableView
    ///   - separatorStyle: UITableViewCell.SeparatorStyle
    static func tblEmptyMessageWithArr<T>(_ message:String = "No Result Found." , arr : Array<T>, tbl:UITableView , separatorStyle : UITableViewCell.SeparatorStyle = .none) -> Int {
        if arr.count > 0 {
            tbl.backgroundView = nil
            tbl.separatorStyle = separatorStyle
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: tbl.bounds.size.width,
                          height: tbl.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = message
        noDataLabel.textColor = .gray
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataLabel.font = UIFont.poppinsTextMedium(size: 20)
        tbl.backgroundView = noDataLabel
        tbl.separatorStyle = .none
        return 0
    }
    /// This function set empty message for UICollectionView by passing message.
    /// - Parameters:
    ///   - message: Empty message, That going to display when no data in UICollectionView (Defult: "No Result Found.")
    ///   - arr: Array which is used in displaying UICollectionView
    ///   - cv: UICollectionView
    ///   - textAlignment: NSTextAlignment , These constants specify text alignment.
    static func cvEmptyMessageWithArr<T>(_ message:String = "No Result Found." , arr : Array<T>?, cv:UICollectionView ,textAlignment:NSTextAlignment  = .center) -> Int {
        if (arr?.count ?? 0) > 0 {
            cv.backgroundView = nil
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: cv.bounds.size.width,
                          height: cv.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = message
        noDataLabel.textColor = .gray
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = textAlignment
        noDataLabel.font = UIFont.poppinsTextMedium(size: 20)
        cv.backgroundView = noDataLabel
        return 0
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    
    func setNavigationInGoogleMaps(_ lat : Double , longi : Double) {
        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                if lat != 0 && longi != 0 {
                    if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi )&directionsmode=driving") {
                        UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                    }
                }
            }
            else {
                openTrackerInBrowser(lat, longi: longi)
            }
        }
        else
        {
            openTrackerInBrowser(lat, longi: longi)
        }
    }
    func openTrackerInBrowser(_ lat : Double , longi : Double){
        if lat != 0 && longi != 0 {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func getTimeSlotString(_ timeStamp : Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h a" //"h:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"
        guard let time1 = timeformatter.date(from: time1Str),
              let time2 = timeformatter.date(from: time2Str) else { return "" }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        return "\(Int(minute)) Mins"
    }
    static func setUpZAlertView() {
        ZAlertView.positiveColor            = UIColor.BlueTheme()
        ZAlertView.negativeColor            = UIColor.BlueTheme()
        ZAlertView.showAnimation            = .flyBottom
        ZAlertView.hideAnimation            = .flyTop
        ZAlertView.duration                 = 0.5
        ZAlertView.alertTitleFont           = UIFont.poppinsTextSemiBold(size: 22)
        ZAlertView.messageFont              = UIFont.poppinsTextRegular(size: 14)
        ZAlertView.buttonFont               = UIFont.poppinsTextMedium(size: 16)
        ZAlertView.titleColor               = .black
        ZAlertView.messageColor             = .lightGray
        ZAlertView.buttonTitleColor         = .white
    }
    
    
}

//MARK: - Color Functions
func setLblComponents(lblColor : UIColor , lblFont : String , lblBgColor : UIColor , lblFontSize : String , component : UILabel) {
    
    component.textColor = lblBgColor
    component.backgroundColor = lblBgColor
}

//MARK: - DispatchQueue
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func mainThread(_ completion: @escaping () -> ()) {
    DispatchQueue.main.async {
        completion()
    }
}

//userInteractive
//userInitiated
//default
//utility
//background
//unspecified
func backgroundThread(_ qos: DispatchQoS.QoSClass = .background , completion: @escaping () -> ()) {
    DispatchQueue.global(qos:qos).async {
        completion()
    }
}
// MARK: - Platform
struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

// MARK: - Documents Directory Clear
func clearTempFolder() {
    let fileManager = FileManager.default
    let tempFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
        }
    } catch {
        print("Could not clear temp folder: \(error)")
    }
}

// MARK: - Alert and Action Sheet Controller
func showAlertView(_ strAlertTitle : String, strAlertMessage : String) -> UIAlertController {
    let alert = UIAlertController(title: strAlertTitle, message: strAlertMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
    }))
    return alert
}

//MARK: - Navigation
func viewController(withID ID : String , storyBoard : String) -> UIViewController {
    let mainStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
    let controller = mainStoryboard.instantiateViewController(withIdentifier: ID)
    return controller
}

//MARK: - UIButton Corner Radius
func cornerLeftButton(btn : UIButton) -> UIButton {
    
    let path = UIBezierPath(roundedRect:btn.bounds, byRoundingCorners:[.topLeft, .bottomLeft], cornerRadii: CGSize.init(width: 10, height: 10))
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = path.cgPath
    btn.layer.mask = maskLayer
    
    return btn
}

func cornerRightButton(btn : UIButton) -> UIButton {
    
    let path = UIBezierPath(roundedRect:btn.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize.init(width: 10, height: 10))
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = path.cgPath
    btn.layer.mask = maskLayer
    
    return btn
}

//MARK: - UITextField Corner Radius
func cornerLeftTextField(textfield : UITextField) -> UITextField {
    
    let path = UIBezierPath(roundedRect:textfield.bounds, byRoundingCorners:[.topLeft, .bottomLeft], cornerRadii: CGSize.init(width: 2.5, height: 2.5))
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = path.cgPath
    textfield.layer.mask = maskLayer
    
    return textfield
}



func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

//MARK: - Image Upload WebService Methods
func generateBoundaryString() -> String{
    return "Boundary-\(UUID().uuidString)"
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


//MARK: - Camera Permissions Methods
func checkCameraPermissionsGranted() -> Bool {
    var cameraPermissionStatus : Bool = false
    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
        // Already Authorized
        cameraPermissionStatus = true
        return true
    } else {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
            if granted == true {
                cameraPermissionStatus = granted
                print("Granted access to Camera");
            } else {
                cameraPermissionStatus = granted
                print("Not granted access to Camera");
            }
        })
        return cameraPermissionStatus
    }
}

//MARK: - Photo Library Permissions Methods
func checkPhotoLibraryPermissionsGranted() -> Bool {
    var photoLibraryPermissionStatus : Bool = false
    let status = PHPhotoLibrary.authorizationStatus()
    if (status == PHAuthorizationStatus.authorized) {
        photoLibraryPermissionStatus = true
    } else if (status == PHAuthorizationStatus.denied) {
        photoLibraryPermissionStatus = false
    } else if (status == PHAuthorizationStatus.notDetermined) {
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            if (newStatus == PHAuthorizationStatus.authorized) {
                photoLibraryPermissionStatus = true
            } else {
                photoLibraryPermissionStatus = false
            }
        })
    } else if (status == PHAuthorizationStatus.restricted) {
        photoLibraryPermissionStatus = false
    }
    return photoLibraryPermissionStatus
}

func saveImage(data: Data) -> URL? {
    
    let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
    do {
        let targetURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString + ".jpg")
        try data.write(to: targetURL)
        return targetURL
    } catch {
        print(error.localizedDescription)
        return nil
    }
}



//MARK: - String RBG to UIColor
func convertStringtoUIColor(strColor : String) -> UIColor {
    
    var color = UIColor()
    
    if strColor.contains("rgba") {
        var strFinalColor = strColor.replacingOccurrences(of: "rgba(", with: "", options: .literal, range: nil)
        strFinalColor = strFinalColor.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        
        var arrRGBA = strFinalColor.components(separatedBy: ",")
        arrRGBA = arrRGBA.map { $0.trimmingCharacters(in: .whitespaces) }
        color = UIColor(r: Int(arrRGBA[0])!, g: Int(arrRGBA[1])!, b: Int(arrRGBA[2])!, a: CGFloat(Int(arrRGBA[3])!))
    } else if strColor.contains("rgb") {
        var strFinalColor = strColor.replacingOccurrences(of: "rgb(", with: "", options: .literal, range: nil)
        strFinalColor = strFinalColor.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        
        var arrRGB = strFinalColor.components(separatedBy: ",")
        arrRGB = arrRGB.map { $0.trimmingCharacters(in: .whitespaces) }
        color = UIColor(r: Int(arrRGB[0])!, g: Int(arrRGB[1])!, b: Int(arrRGB[2])!)
    }
    
    return color
}

//MARK: - String to CGFloat Method
func stringtoCGFloat(strFontSize : String) -> CGFloat {
    return CGFloat(truncating: NumberFormatter().number(from: strFontSize)!)
}

//MARK: - String to Image Method
func stringToImage(strImage : String?) -> UIImage? {
    if strImage != "" {
        if let data = try? Data(contentsOf: URL(string: strImage!)!) {
            return UIImage(data: data)
        }
    }
    return nil
}

//MARK: - Check Device JailBreak
func isJailbroken() -> Bool {
#if arch(i386) || arch(x86_64)
    // This is a Simulator not an idevice
    return false
#else
    let fm = FileManager.default
    if(fm.fileExists(atPath: "/private/var/lib/apt")) {
        // This Device is jailbroken
        return true
    } else {
        // Continue the device is not jailbroken
        return false
    }
#endif
}

//MARK: - Notification Enable/Disable Check Method
func isNotificationEnabled(completion:@escaping (_ enabled:Bool)->()) {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
            let status =  (settings.authorizationStatus == .authorized)
            completion(status)
        })
    } else {
        if let status = UIApplication.shared.currentUserNotificationSettings?.types{
            let status = status.rawValue != UIUserNotificationType(rawValue: 0).rawValue
            completion(status)
        }else{
            completion(false)
        }
    }
}

extension UIButton {
    func setImgWithNuke(_ imgPath : String?, placeholder : UIImage = #imageLiteral(resourceName: "LodingPlaceholder"), isBackground : Bool = false) {
        if let imgUrl = URL(string: (imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) {
            self.setBackgroundImage(nil, for: .normal)
            self.setImage(placeholder, for: .normal)
            ImagePipeline.shared.loadImage(with: imgUrl, progress: nil) { response in
                self.setBackgroundImage(nil, for: .normal)
                self.setImage(nil, for: .normal)
                switch response {
                case .success(let img):
                    if isBackground {
                        self.setBackgroundImage(img.image, for: .normal)
                    } else {
                        self.setImage(img.image, for: .normal)
                    }
                case .failure(let error):
                    if isBackground {
                        self.setBackgroundImage(placeholder, for: .normal)
                    } else {
                        self.setImage(placeholder, for: .normal)
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    func setImgFullUrlWithNuke(_ imgPath : String, placeholder : UIImage = #imageLiteral(resourceName: "LodingPlaceholder") , isBackground : Bool = false) {
        if let imgUrl = URL(string: (imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) {
            self.setBackgroundImage(nil, for: .normal)
            self.setImage(placeholder, for: .normal)
            ImagePipeline.shared.loadImage(with: imgUrl, progress: nil) { response in
                self.setBackgroundImage(nil, for: .normal)
                self.setImage(nil, for: .normal)
                switch response {
                case .success(let img):
                    if isBackground {
                        self.setBackgroundImage(img.image, for: .normal)
                    } else {
                        self.setImage(img.image, for: .normal)
                    }
                case .failure(let error):
                    if isBackground {
                        self.setBackgroundImage(placeholder, for: .normal)
                    } else {
                        self.setImage(placeholder, for: .normal)
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}

func setThumbnailFrom(path: URL , handler: @escaping (_ img: UIImage?) -> Void) {
    backgroundThread(.utility) {
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            mainThread {
                handler(thumbnail)
            }
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            //            return nil
            
        }
    }
}


final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

final class ContentHeightCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
final class ContentWidthCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width , height: UIView.noIntrinsicMetric)
    }
}
final class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width , height: contentSize.height)
    }
}
class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}


func convertVideo(to outputFileType: AVFileType, withInputURL inputURL: URL?, outputURL: URL?, handler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
    do {
        if let outputURL = outputURL {
            try FileManager.default.removeItem(at: outputURL)
        }
    } catch {
    }
    var asset: AVURLAsset? = nil
    if let inputURL = inputURL {
        asset = AVURLAsset(url: inputURL, options: nil)
    }
    var exportSession: AVAssetExportSession? = nil
    if let asset = asset {
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
    }
    exportSession?.outputURL = outputURL
    exportSession?.outputFileType = outputFileType
    exportSession?.exportAsynchronously(completionHandler: {
        DispatchQueue.main.async(execute: {
            //Your main thread code goes in here
            handler(exportSession)
            
        })
        //         [exportSession release];
    })
}


public extension UIDevice {
    
    /// pares the deveice name as the standard name
    var modelId: String {
#if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
#else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
#endif
        return identifier
    }
}


class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popStyle: Bool = false
    
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        tz.view.shadowColorView = .black
        tz.view.shadowRadiusView = 5
        tz.view.shadowOpacityView = 0.3
        
        
        let f = transitionContext.finalFrame(for: tz)
        //        f = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height - 60)
        let fOff = f.offsetBy(dx: -f.width, dy: 0)
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        //        fz.view.shadowColorView = .black
        //        fz.view.shadowRadiusView = 5
        //        fz.view.shadowOpacityView = 0.3
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: -f.width, dy: 0)
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
}


extension UIAlertController{
    func addCustomFontToActionTitle(strTitle : String , style : UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title:strTitle, style: style,handler: handler)
        //        let attributedText = NSMutableAttributedString(string: strTitle)
        //        let range = NSRange(location: 0, length: attributedText.length)
        //        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: range)
        //        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.poppinsTextRegular(size: 18), range: range)
        //        mainThread {
        //            guard let label = (action.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        //            label.attributedText = attributedText
        ////            self.setAttributedText(attributedText,superview : self.view)
        //        }
        self.addAction(action)
    }
}

func format(number: Double) -> String? {

    let sign = ((number < 0) ? "-" : "" )
    let num = fabs(number)

    // If its only three digit:
    if (num < 1000.0){
        return String(format:"\(sign)%g", num)
    }

    // Otherwise
    let exp: Int = Int(log10(num)/3.0)
    let units: [String] = ["K","M","B","T","P","E"]

    let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10

    return String(format:"\(sign)%g\(units[exp-1])", roundedNum)
}
