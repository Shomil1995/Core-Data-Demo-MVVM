

import CoreGraphics

// MARK: - Properties
public extension Double {
	
	/// : Int.
	var int: Int {
		return Int(self)
	}
	
	/// : Float.
	var float: Float {
		return Float(self)
	}
	
	/// : CGFloat.
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
    
    var toString: String {
        return String(format: "%.2f", self)
    }
}

// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// : Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Double, rhs: Double) -> Double {
	// http://nshipster.com/swift-operators/
	return pow(lhs, rhs)
}

prefix operator √
/// : Square root of double.
///
/// - Parameter double: double value to find square root for.
/// - Returns: square root of given double.
public prefix func √ (double: Double) -> Double {
	// http://nshipster.com/swift-operators/
	return sqrt(double)
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
