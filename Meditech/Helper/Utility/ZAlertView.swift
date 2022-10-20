
import UIKit
import Accelerate

@objc open class ZAlertView: UIViewController {
    
    public enum AlertType: Int {
        case alert
        case confirmation
        case multipleChoice
    }
    
    public enum ShowAnimation: Int {
        case fadeIn
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
    }
    
    public enum HideAnimation: Int {
        case fadeOut
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
        
    }
    
    public typealias TouchHandler = (ZAlertView) -> ()

    static let Padding: CGFloat               = 15
    static let InnerPadding: CGFloat          = 12
    static let CornerRadius: CGFloat          = 8
    static let ButtonHeight: CGFloat          = 50
    static let ButtonSectionExtraGap: CGFloat = 12
    static let TextFieldHeight: CGFloat       = 40
    static let AlertWidth: CGFloat            = UIScreen.main.bounds.width * 0.77
    static let AlertHeight: CGFloat           = 65
    static let BackgroundAlpha: CGFloat       = 0.5
    
    // MARK: - Global
    public static var padding: CGFloat               = ZAlertView.Padding
    public static var innerPadding: CGFloat          = ZAlertView.InnerPadding
    public static var cornerRadius: CGFloat          = ZAlertView.CornerRadius
    public static var buttonHeight: CGFloat          = ZAlertView.ButtonHeight
    public static var buttonSectionExtraGap: CGFloat = ZAlertView.ButtonSectionExtraGap
    public static var textFieldHeight: CGFloat       = ZAlertView.TextFieldHeight
    public static var backgroundAlpha: CGFloat       = ZAlertView.BackgroundAlpha
    public static var blurredBackground: Bool        = false
    public static var showAnimation: ShowAnimation   = .fadeIn
    public static var hideAnimation: HideAnimation   = .fadeOut
    public static var duration:CGFloat               = 0.3
    public static var initialSpringVelocity:CGFloat  = 0.5
    public static var damping:CGFloat                = 0.5
    public static var statusBarStyle: UIStatusBarStyle?
    
    
    // Font
    public static var alertTitleFont: UIFont?
    public static var messageFont: UIFont?
    public static var buttonFont: UIFont?
    
    // Color
    public static var positiveColor: UIColor?            = UIColor(red:0.09, green:0.47, blue:0.24, alpha:1.0)
    public static var negativeColor: UIColor?            = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1.0)
    public static var neutralColor: UIColor?             = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    public static var titleColor: UIColor?               = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var buttonTitleColor: UIColor?         = UIColor.white
    public static var messageColor: UIColor?             = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var cancelTextColor: UIColor?          = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var normalTextColor: UIColor?          = UIColor.white
    public static var textFieldTextColor: UIColor?       = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var textFieldBorderColor: UIColor?     = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var textFieldBackgroundColor: UIColor? = UIColor.white
    
    // MARK: -
    open var alertType: AlertType = AlertType.alert
    open var alertTitle: String?
    open var message: String?
    open var messageAttributedString: NSAttributedString?
    
    open var okTitle: String? {
        didSet {
            btnOk.setTitle(okTitle, for: .normal)
        }
    }
    
    open var cancelTitle: String? {
        didSet {
            btnCancel.setTitle(cancelTitle, for: .normal)
        }
    }
    
    open var closeTitle: String? {
        didSet {
            btnClose.setTitle(closeTitle, for: .normal)
        }
    }
    
    open var allowTouchOutsideToDismiss: Bool = true {
        didSet {
            weak var weakSelf = self
            if weakSelf != nil {
                if allowTouchOutsideToDismiss == false {       
                    weakSelf!.tapOutsideTouchGestureRecognizer.removeTarget(weakSelf!, action: #selector(ZAlertView.dismissAlertView))
                }
                else {
                    weakSelf!.tapOutsideTouchGestureRecognizer.addTarget(weakSelf!, action: #selector(ZAlertView.dismissAlertView))
                }
            }
        }
    }
    fileprivate var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    open var isOkButtonLeft: Bool = false
    open var width: CGFloat = ZAlertView.AlertWidth
    open var height: CGFloat = ZAlertView.AlertHeight

    // Master views
    open var backgroundView: UIView!
    open var alertView: UIView!
    
    // View components
    var lbTitle: UILabel!
    var lbMessage: UILabel!
    var btnOk: ZButton!
    var btnCancel: ZButton!
    var btnClose: ZButton!
    var buttons: [ZButton] = []
    var textFields: [ZTextField] = []
    
    // Handlers
    open var cancelHandler: TouchHandler? = { alertView in
        alertView.dismissAlertView()
    }{
        didSet {
            btnCancel.touchHandler = cancelHandler
        }
    }
    
    open var okHandler: TouchHandler? {
        didSet {
            btnOk.touchHandler = okHandler
        }
    }
    
    open var closeHandler: TouchHandler? {
        didSet {
            btnClose.touchHandler = closeHandler
        }
    }
    
    // Windows
    var previousWindow: UIWindow!
    var alertWindow: UIWindow!
    
    // Old frame
    var oldFrame: CGRect!
    
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
    }
    
    public init(title: String?, message: String?, alertType: AlertType) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
        self.alertTitle = title
        self.alertType = alertType
        self.message = message
    }
    
    public convenience init(title: String?, message: String?, closeButtonText: String?, closeButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.alert)
        self.closeTitle = closeButtonText
        btnClose.setTitle(closeTitle, for: .normal)
        self.closeHandler = closeButtonHandler
        self.btnClose.touchHandler = self.closeHandler
    }
    
    public convenience init(title: String?, message: String?, okButtonText: String?, cancelButtonText: String?) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: .normal)
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: .normal)
    }
    
    public convenience init(title: String?, message: String?, isOkButtonLeft: Bool? = false, okButtonText: String? = nil, cancelButtonText: String? = nil, okButtonHandler: TouchHandler? = nil, cancelButtonHandler: TouchHandler? = nil) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        if let okLeft = isOkButtonLeft {
            self.isOkButtonLeft = okLeft
        }
        self.message = message
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: .normal)
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: .normal)
        self.okHandler = okButtonHandler
        self.btnOk.touchHandler = self.okHandler
        self.cancelHandler = cancelButtonHandler
        self.btnCancel.touchHandler = self.cancelHandler
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWindow() {
        if viewNotReady() {
            return
        }
        let window = UIWindow(frame: (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.bounds)!)
        self.alertWindow = window
        self.alertWindow.windowLevel = UIWindow.Level.alert
        self.alertWindow.backgroundColor = UIColor.clear
        self.alertWindow.rootViewController = self
        self.previousWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }
    
    func setupViews() {
        if viewNotReady() {
            return
        }
        self.view = UIView(frame: (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.bounds)!)
        
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        
        // Gesture for background
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(ZAlertView.dismissAlertView))
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        self.view.addSubview(backgroundView)
        
        // Setup alert view
        self.alertView                    = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.alertView.backgroundColor    = UIColor.white
        self.alertView.layer.cornerRadius = ZAlertView.CornerRadius
        self.view.addSubview(alertView)
        
        // Setup title
        self.lbTitle               = UILabel()
        self.lbTitle.textAlignment = NSTextAlignment.center
        self.lbTitle.textColor     = ZAlertView.titleColor
        self.lbTitle.font          = ZAlertView.alertTitleFont ?? UIFont.boldSystemFont(ofSize: 16)
        self.alertView.addSubview(lbTitle)
        
        // Setup message
        self.lbMessage               = UILabel()
        self.lbMessage.textAlignment = NSTextAlignment.center
        self.lbMessage.numberOfLines = 0
        self.lbMessage.textColor     = ZAlertView.messageColor
        self.lbMessage.font          = ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14)
        self.alertView.addSubview(lbMessage)
        
        // Setup OK Button
        self.btnOk = ZButton(touchHandler: self.okHandler)
        if let okTitle = self.okTitle {
            self.btnOk.setTitle(okTitle, for: .normal)
        } else {
            self.btnOk.setTitle("OK", for: .normal)
        }
        self.btnOk.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnOk.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnOk)
        
        // Setup Cancel Button
        self.btnCancel = ZButton(touchHandler: self.cancelHandler)
        if let cancelTitle = self.cancelTitle {
            self.btnCancel.setTitle(cancelTitle, for: .normal)
        } else {
            self.btnCancel.setTitle("Cancel", for: .normal)
        }
        self.btnCancel.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnCancel.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnCancel)
        
        // Setup Close button
        self.btnClose = ZButton(touchHandler: self.closeHandler)
        if let closeTitle = self.closeTitle {
            self.btnClose.setTitle(closeTitle, for: .normal)
        } else {
            self.btnClose.setTitle("Close", for: .normal)
        }
        self.btnClose.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnClose.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnClose)
    }
    
    // MARK: - Life cycle
    
    open override func viewWillAppear(_ animated: Bool) {
        registerKeyboardEvents()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        unregisterKeyboardEvents()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var hasContent = false
        
        if ZAlertView.blurredBackground {
            self.backgroundView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            self.backgroundView.addSubview(UIImageView(image: UIImage.imageFromScreen().applyBlurWithRadius(2, tintColor: UIColor(white: 0.5, alpha: 0.7), saturationDeltaFactor: 1.8)))
        } else {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
        }
        
        if let title = self.alertTitle {
            hasContent      = true
            self.height     = ZAlertView.padding
            lbTitle.text    = title
            let size        = lbTitle.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbTitle.frame   = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
            height          += childHeight
        } else {
            self.height = 0
        }
        
        if let message = self.message {
            hasContent      = true
            self.height     += ZAlertView.padding
            lbMessage.text  = message
            let size        = lbMessage.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbMessage.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
            height          += childHeight
        } else if let messageAttributedString = self.messageAttributedString {
            hasContent               = true
            self.height              += ZAlertView.padding
            lbMessage.attributedText = messageAttributedString
            let size                 = lbMessage.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight          = size.height
            lbMessage.frame          = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
            height                   += childHeight
        }
        
        if textFields.count > 0 {
            hasContent = true
            for textField in textFields {
                self.height += ZAlertView.innerPadding
                textField.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: ZAlertView.textFieldHeight)
                self.height += ZAlertView.textFieldHeight
            }
        }
        
        self.height += ZAlertView.padding
        
        switch alertType {
        case .alert:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth             = width -  ZAlertView.padding * 2
            btnClose.frame              = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            btnClose.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnClose.frame.size), for: .normal)
            btnClose.layer.cornerRadius = ZAlertView.cornerRadius
            btnClose.clipsToBounds      = true
            btnClose.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControl.Event.touchUpInside)
            self.height                 += ZAlertView.buttonHeight
            
        case .confirmation:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth = (width - ZAlertView.padding * 2 - ZAlertView.innerPadding) / 2
            
            if isOkButtonLeft {
                btnOk.frame = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
                btnCancel.frame = CGRect(x: ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            } else {
                btnCancel.frame = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
                btnOk.frame = CGRect(x: ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            }
            
            btnCancel.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.negativeColor, size: btnCancel.frame.size), for: .normal)
            btnCancel.layer.cornerRadius = ZAlertView.cornerRadius
            btnCancel.clipsToBounds = true
            self.btnCancel.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControl.Event.touchUpInside)
            
            btnOk.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnOk.frame.size), for: .normal)
            btnOk.layer.cornerRadius = ZAlertView.cornerRadius
            btnOk.clipsToBounds = true
            self.btnOk.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControl.Event.touchUpInside)
            self.height += ZAlertView.buttonHeight
            
        case .multipleChoice:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            for button in buttons {
                button.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: ZAlertView.buttonHeight)
                if button.color != nil {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(button.color!, size: button.frame.size), for: .normal)
                } else {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.neutralColor, size: button.frame.size), for: .normal)
                }
                if button.titleColor != nil {
                    button.setTitleColor(button.titleColor!, for: .normal)
                } else {
                    button.setTitleColor(ZAlertView.buttonTitleColor, for: .normal)
                }
                button.layer.cornerRadius = ZAlertView.cornerRadius
                button.clipsToBounds = true
                self.height += ZAlertView.buttonHeight
                if button != buttons.last {
                    self.height += ZAlertView.innerPadding
                }
            }
        }
        
        self.height += ZAlertView.padding
        let bounds = UIScreen.main.bounds
        self.alertView.frame = CGRect(x: bounds.width/2 - width/2, y: bounds.height/2 - height/2, width: width, height: height)
    }
    
    // MARK: - Override methods
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let statusBarStyle = ZAlertView.statusBarStyle {
            return statusBarStyle
        }
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarStyle ?? .default
        } else {
            return UIApplication.shared.statusBarStyle
        }
    }
    
    // MARK: - Convenient helpers
    
    open func addTextField(_ identifier: String, placeHolder: String) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.default,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, isSecured: Bool) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.default,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: true)
    }
    
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: keyboardType,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType, font: UIFont, padding: CGFloat, isSecured: Bool) {
        let textField                = ZTextField(identifier: identifier)
        textField.leftView           = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: ZAlertView.textFieldHeight))
        textField.rightView          = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: ZAlertView.textFieldHeight))
        textField.leftViewMode       = UITextField.ViewMode.always
        textField.rightViewMode      = UITextField.ViewMode.always
        textField.keyboardType       = keyboardType
        textField.font               = font
        textField.placeholder        = placeHolder
        textField.layer.cornerRadius = ZAlertView.cornerRadius
        textField.layer.borderWidth  = 1

        if ZAlertView.textFieldBorderColor != nil {
            textField.layer.borderColor = ZAlertView.textFieldBorderColor!.cgColor
        } else if ZAlertView.positiveColor != nil {
            textField.layer.borderColor = ZAlertView.positiveColor!.cgColor
        }
        
        if ZAlertView.textFieldBackgroundColor != nil {
            textField.backgroundColor = ZAlertView.textFieldBackgroundColor
        }
        
        if ZAlertView.textFieldTextColor != nil {
            textField.textColor = ZAlertView.textFieldTextColor
        }
        
        textField.clipsToBounds = true
        if isSecured {
            textField.isSecureTextEntry = true
        }
        textFields.append(textField)
        self.alertView.addSubview(textField)
    }
    
    open func addButton(_ title: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: color, titleColor: titleColor, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, hexColor: String, hexTitleColor: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: UIColor.color(hexColor), titleColor: UIColor.color(hexTitleColor), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, touchHandler: @escaping TouchHandler) {
        addButton(title, font: font, color: nil, titleColor: nil, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        weak var weakSelf = self
        let button              = ZButton(touchHandler: touchHandler)
        button.setTitle(title, for: .normal)
        button.color            = color
        button.titleColor       = titleColor
        button.titleLabel?.font = font
        button.addTarget(weakSelf!, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControl.Event.touchUpInside)
        buttons.append(button)
        self.alertView.addSubview(button)
    }
    
    open func getTextFieldWithIdentifier(_ identifier: String) -> UITextField? {
        return textFields.filter({ textField in
            textField.identifier == identifier
        }).first
    }
    
    @objc func buttonDidTouch(_ sender: ZButton) {
        weak var weakSelf = self
        if let listener = sender.touchHandler {
            if (weakSelf != nil) {
                listener(weakSelf!)
            }
        }
    }
    
    // MARK: - Handle keyboard
    
    func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(ZAlertView.keyboardDidShow(_:)), name:UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZAlertView.keyboardDidHide(_:)), name:UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.oldFrame = self.alertView.frame
            let extraHeight = (oldFrame.size.height + oldFrame.origin.y) - (self.view.frame.size.height - keyboardSize.height)
            if extraHeight > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.alertView.frame = CGRect(x: self.oldFrame.origin.x, y: self.oldFrame.origin.y - extraHeight - 8, width: self.oldFrame.size.width, height: self.oldFrame.size.height)
                })
            }
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        if self.oldFrame == nil {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alertView.frame = self.oldFrame
        })
    }
    
    func unregisterKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Show & hide
    
    open func show() {
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        showWithDuration(Double(ZAlertView.duration))
    }
    
    @objc open func dismissAlertView() {
        
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        dismissWithDuration(0.3)
    }
    
    open func showWithDuration(_ duration: Double) {
        if viewNotReady() {
            return
        }
        
        if ZAlertView.damping <= 0
        {
            ZAlertView.damping = 0.1
        }
        else if ZAlertView.damping >= 1
        {
            ZAlertView.damping = 1
        }
        
        if ZAlertView.initialSpringVelocity <= 0
        {
            ZAlertView.initialSpringVelocity = 0.1
        }
        else if ZAlertView.initialSpringVelocity >= 1
        {
            ZAlertView.initialSpringVelocity = 1
        }
        

        self.alertWindow.makeKeyAndVisible()
        switch ZAlertView.showAnimation {
        case .fadeIn:
            self.view.alpha = 0
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.alpha = 1
            }) 
        case .flyLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .flyRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = 1
            }) 
        case .flyBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .flyTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .bounceTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height*4, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
              
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
            case .bounceBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        case .bounceLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
           self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
        case .bounceRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        }
    }
    
    open func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.view.removeFromSuperview()
                self.alertWindow.isHidden = true
                self.alertWindow = nil
                self.previousWindow.makeKeyAndVisible()
                self.previousWindow = nil
            }
        }
        
        switch ZAlertView.hideAnimation {
        case .fadeOut:
            self.view.alpha = 1
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.view.alpha = 0
            }, completion: completion)
        case .flyLeft:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyRight:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
            
        case .bounceBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
       
        case .bounceTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)

        case .bounceLeft:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .bounceRight:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
        }
    }
    
    func viewNotReady() -> Bool {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first == nil
    }
    
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutSubviews()
        self.view.setNeedsDisplay()
    }
    
    // MARK: - Subclasses
    
    class ZButton: UIButton {
        
        var touchHandler: TouchHandler?
        
        var color: UIColor?
        var titleColor: UIColor? {
            didSet {
                weak var weakSelf = self
                weakSelf?.setTitleColor(titleColor, for: .normal)
            }
        }
        
        init(touchHandler: TouchHandler?) {
            super.init(frame: CGRect.zero)
            self.touchHandler = touchHandler
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class ZTextField: UITextField {
        
        var identifier: String!
        
        init(identifier: String) {
            super.init(frame: CGRect.zero)
            self.identifier = identifier
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
    }
}

fileprivate extension UIColor {
    class func color(_ hexString: String) -> UIColor? {
        if (hexString.count > 7 || hexString.count < 7) {
            return nil
        } else {
            let hexInt = Int(String(hexString[hexString.index(hexString.startIndex, offsetBy: 1)...]), radix: 16)
            if let hex = hexInt {
                let components = (
                    R: CGFloat((hex >> 16) & 0xff) / 255,
                    G: CGFloat((hex >> 08) & 0xff) / 255,
                    B: CGFloat((hex >> 00) & 0xff) / 255
                )
                return UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1)
            } else {
                return nil
            }
        }
    }
}

fileprivate extension UIImage {
    class func imageWithSolidColor(_ color: UIColor?, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if color != nil {
            color!.setFill()
        } else {
            UIColor.black.setFill()
        }
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageFromScreen() -> UIImage {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let rect = keyWindow?.bounds
        UIGraphicsBeginImageContextWithOptions((rect?.size)!, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        keyWindow?.layer.render(in: context!)
        let capturedScreen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedScreen!;
    }
    
    func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if self.cgImage == nil {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(Float.ulpOfOne)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectInContext = UIGraphicsGetCurrentContext()
            
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext!)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = createEffectBuffer(effectOutContext!)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                
                let inputRadius = blurRadius * screenScale
                let cal = CGFloat(sqrt(2 * .pi)) / 4 + 0.5
                let calculateRadius = floor(inputRadius * 3.0 * cal)
                var radius = UInt32(calculateRadius)
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i in 0...matrixSize-1 {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
