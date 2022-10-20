

import UIKit

@IBDesignable
class ShadowButton: UIButton {

    let layer1 = CALayer(), layer2 = CALayer(), layer3 = CALayer(), layer4 = CALayer()
    
    let shadowView = ButtonInnerShadowView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer1.backgroundColor = UIColor(hex: "F1F3F6").cgColor
        layer1.cornerRadius = 5

        [layer1, layer2, layer3].forEach {
            $0.masksToBounds = false
            $0.frame = layer.bounds
            layer.insertSublayer($0, at: 0)
        }
        
        layer2.applySketchShadow(color: UIColor.white, alpha: 1, x: -10, y: -10, blur: 24, spread: 0)
        layer3.applySketchShadow(color: UIColor(hex: "DDE2EE"), alpha: 1, x: 10, y: 10, blur: 24, spread: 0)
        self.cornerRadiusView = 5
        self.borderWidthView = 1
        self.borderColorView = .white
        
        shadowView.frame = layer.bounds
        self.insertSubview(shadowView, at: 3)
    }

    #if !TARGET_INTERFACE_BUILDER
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutSubviews()
    }
    #endif
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layoutSubviews()
    }
    
}

class ButtonInnerShadowView: UIView {

    let layer1 = CALayer(), layer2 = CALayer(), gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
//        layer1.frame = layer.bounds
//        layer1.applySketchShadow(color: UIColor.black, alpha: 0.04, x: 0, y: 0, blur: 20, spread: 0)
//        layer.insertSublayer(layer1, at: 0)
//        layer2.frame = layer.bounds
//        layer2.applySketchShadow(color: UIColor.white, alpha: 0.25, x: 20, y: 20, blur: 20, spread: 0)
//        layer.insertSublayer(layer2, at: 0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.25),  UIColor.white.withAlphaComponent(0.25)]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)

    }

    #if !TARGET_INTERFACE_BUILDER
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutSubviews()
    }
    #endif
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layoutSubviews()
    }
    
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    
    let dx = -spread
    let rect = bounds.insetBy(dx: dx, dy: dx)
    shadowPath = UIBezierPath(rect: rect).cgPath
  }
}
