import UIKit

class SegmentedControl: UISegmentedControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.4)
        ], for: .normal)
        
        setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.white
        ], for: .selected)
    }
    
    @IBInspectable var fontSize: CGFloat = 0.0 {
        didSet {
            if let color = titleTextAttributes(for: .normal)?[NSAttributedStringKey.foregroundColor] as? UIColor {
                setTitleTextAttributes([
                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
                    NSAttributedStringKey.foregroundColor: color
                ], for: .normal)
            }
        }
    }
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
}

extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
}

class TextField: UITextField {
    
    let insets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 8
        enable()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    func enable() {
        isEnabled = true
        textColor = UIColor.black.withAlphaComponent(0.25)
        backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
    }
    
    func disable() {
        isEnabled = false
        textColor = UIColor.black.withAlphaComponent(0.1)
        backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
    }
    
}

extension FormController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        }
        
        textField.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 7.5
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        
        textField.layer.add(animation, forKey: "shadowOpacity")
        textField.layer.shadowOpacity = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            (textField as! TextField).enable()
        }
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.3
        
        textField.layer.add(animation, forKey: "shadowOpacity")
        textField.layer.shadowOpacity = 0
    }
    
    enum LabelType: String {
        case firstName = "First Name"
        case lastName = "Last Name"
        case dateOfBirth = "Date of Birth"
        case socialSecurityNumber = "Social Security Number"
        case dateOfVisit = "Date of Visit"
        case streetAddress = "Street Address"
        case city = "City"
        case state = "State"
        case zipCode = "Zip Code"
        
        static func text(for type: LabelType) -> String? {
            switch type {
            case .firstName:
                return "John"
            case .lastName:
                return "Doe"
            case .dateOfBirth:
                return "04 / 25 / 2000"
            case .socialSecurityNumber:
                return "123-45-6789"
            case .dateOfVisit:
                return "04 / 25 / 2018"
            case .streetAddress:
                return "1 Infinite Loop"
            case .city:
                return "Cupertino"
            case .state:
                return "California"
            case .zipCode:
                return "95014"
            }
        }
    }
    
}
