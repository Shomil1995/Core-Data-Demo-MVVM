//
//  Utility.swift

import Darwin


//MARK: - Colors
extension UIColor {
    class func LoginShadowGreen() -> UIColor { return UIColor(r: 86, g: 195, b: 230) }
    class func BlueStart() -> UIColor { return UIColor(r: 14, g: 91, b: 218)}
    class func BlueEnd() -> UIColor { return UIColor(r: 15, g: 128, b: 250)}
    class func StepGrayColor() -> UIColor { return UIColor(r: 196, g: 196, b: 196)}
    class func BlueTheme() -> UIColor { return UIColor(named: "BlueTheme") ?? .blue}
    class func LightGrayBorder() -> UIColor { return UIColor(named: "LightGrayBorder") ?? .gray}
    class func LightGray() -> UIColor { return UIColor(named: "LightGray") ?? .gray}
    class func Yellow() -> UIColor { return UIColor(named: "Yellow") ?? .yellow}
    
}

//MARK: - Font Name
enum Font {
    static let poppinsTextRegular                 = "Poppins-Regular"
    static let poppinsTextBold                    = "Poppins-Bold"
    static let poppinsTextMedium                  = "Poppins-Medium"
    static let poppinsTextSemiBold                  = "Poppins-SemiBold"
}
extension UIFont {
    class func poppinsTextRegular(size: CGFloat) -> UIFont { return UIFont(name: Font.poppinsTextRegular, size: size) ?? UIFont.systemFont(ofSize: size) }
    class func poppinsTextMedium(size: CGFloat) -> UIFont { return UIFont(name: Font.poppinsTextMedium, size: size) ?? UIFont.systemFont(ofSize: size) }
    class func poppinsTextBold(size: CGFloat) -> UIFont { return UIFont(name: Font.poppinsTextBold, size: size) ?? UIFont.systemFont(ofSize: size) }
    class func poppinsTextSemiBold(size: CGFloat) -> UIFont { return UIFont(name: Font.poppinsTextSemiBold, size: size) ?? UIFont.systemFont(ofSize: size) }
    
}

//MARK: - Message's
enum AlertMessage {
  
    static let networkConnection = "You are not connected to internet. Please connect and try again"
    
    
    
    //Validation Messages
    static let fullName = "Please enter full name"
    static let validEmail = "Please enter valid email"
    static let email = "Please enter email"
    static let phone = "Please enter phone number"
    static let validphone = "Please enter valid phone number"
    static let city = "Please enter city"
    static let state = "Please select state"
    static let country = "Please select country"
    
    //Webservice Fail Message
    static let error = "Something went wrong. Please try after sometime"
    
    //Camera, Images and ALbums Related Messages
    static let msgPhotoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let msgCameraPermission = "Please enable camera access from Privacy Settings"
    static let msgNoCamera = "Device Has No Camera"
    
    //iTune Store Link not available Message
    static let msgiTuneStoreLink = "App is not Live yet. Sorry, you cannot Share App now. Please come after sometime."
}

var webServiceURL = WebServiceURL()
//MARK: - Web Service URLs
struct WebServiceURL {
     static let countryList = "https://api.countrystatecity.in/v1/countries"
}

//MARK: - Web Service Parameters
enum WebServiceParameter {
    static let email = "email"
    static let fullName = "full_name"
    static let image = "image"
    static let phone = "phone"
    static let city = "city"
    static let country = "country"
    static let state = "state"
}


//MARK: - Constants
struct Constants {
    
    //MARK: - Global Utility
    static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let pageLimit = 50
    static var keyWindow : UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    //MARK: - Device Type
    enum UIUserInterfaceIdiom : Int{
        case Unspecified
        case Phone
        case Pad
    }
    
    //MARK: - Screen Size
    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    //MARK: - DateFormat
    struct DateFormat {
        static let date = "dd/MM/yyyy"
        static let time = "hh:mm a"
    }
}

//MARK: - DateTime Format
enum DateAndTimeFormatString {
    static let yyyymmddhhmmss = "yyyy-MM-dd HH:mm:ss"
    static let MMMddyyyhhmmsssa = "MMM dd, yyyy hh:mm a"
    static let ddMMM = "dd MMM"
    static let ddMMMYYYY = "dd-MMM-YYYY"
    static let MMddYYYY = "MM/dd/yyyy"
    static let YYYYMMdd = "YYYY/MM/dd"
    
}
