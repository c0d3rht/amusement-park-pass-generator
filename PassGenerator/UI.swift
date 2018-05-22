import UIKit

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

class TextField: UITextField {
    
    var label: UILabel? {
        if let superview = superview {
            for view in superview.subviews {
                if view != self, let label = view as? UILabel {
                    return label
                }
            }
        }
        
        return nil
    }
    
    let insets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        enable()
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowRadius = 5
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    func enable() {
        isEnabled = true
        
        label?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        textColor = UIColor.black.withAlphaComponent(0.25)
        
        if isFirstResponder {
            backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        } else {
            backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        }
    }
    
    func disable() {
        isEnabled = false
        text = nil
        
        label?.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        textColor = UIColor.black.withAlphaComponent(0.1)
//        backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
        backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
    }
    
}

extension FormController: UITextFieldDelegate {
    
    enum LabelType: String {
        case firstName = "First Name"
        case lastName = "Last Name"
        case dateOfBirth = "Date of Birth"
        case socialSecurityNumber = "Social Security Number"
        case projectNumber = "Project #"
        case dateOfVisit = "Date of Visit"
        case companyName = "Company Name"
        case streetAddress = "Street Address"
        case city = "City"
        case state = "State"
        case zipCode = "Zip Code"
        
        static func sampleText(for type: LabelType) -> String? {
            switch type {
            case .firstName:
                return "John"
            case .lastName:
                return "Doe"
            case .dateOfBirth:
                return "04 / 25 / 2000"
            case .socialSecurityNumber:
                return "123-45-6789"
            case .projectNumber:
                return "1001"
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
            default:
                return nil
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            if let textField = textField as? TextField {
                textField.label?.textColor = UIColor(red: 0.54, green: 0.44, blue: 0.66, alpha: 1)
            }
            
            textField.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        }
        
        animator.startAnimation()
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        
        textField.layer.add(animation, forKey: animation.keyPath)
        textField.layer.shadowOpacity = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            if let textField = textField as? TextField {
                textField.enable()
            }
        }
        
        animator.startAnimation()
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.3
        
        textField.layer.add(animation, forKey: animation.keyPath)
        textField.layer.shadowOpacity = 0.0
    }
    
}
