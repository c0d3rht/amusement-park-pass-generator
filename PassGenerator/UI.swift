import UIKit

// MARK: - Custom Views -

class SegmentedControl: UISegmentedControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)
            ], for: .normal)
        
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
    }
    
    @IBInspectable var fontSize: CGFloat = 0.0 {
        didSet {
            if let color = titleTextAttributes(for: .normal)?[NSAttributedString.Key.foregroundColor] as? UIColor {
                setTitleTextAttributes([
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
                    NSAttributedString.Key.foregroundColor: color
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
        
        setupUI()
        setAppearance(to: .normal)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    func setupUI() {
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowRadius = 5
        
        if let placeholder = placeholder {
            let attributedString = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.1)])
            attributedPlaceholder = attributedString
        }
    }
    
    func setAppearance(to state: UIControl.State) {
        isEnabled = state == .normal || state == .focused
        
        switch state {
        case .normal:
            label?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            textColor = UIColor.black.withAlphaComponent(0.25)
            backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
            
            if layer.shadowOpacity == 1.0 {
                let animation = CABasicAnimation(keyPath: "shadowOpacity")
                animation.fromValue = 1.0
                animation.toValue = 0.0
                animation.duration = 0.3

                layer.add(animation, forKey: animation.keyPath)
                layer.shadowOpacity = 0.0
            }
        case .focused:
            label?.textColor = UIColor(red: 0.54, green: 0.44, blue: 0.66, alpha: 1)
            textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.3
            
            layer.add(animation, forKey: animation.keyPath)
            layer.shadowOpacity = 1.0
        case .disabled:
            text = nil
            label?.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            
            textColor = UIColor.black.withAlphaComponent(0.1)
            backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
            layer.shadowOpacity = 0.0
        default: break
        }
    }
    
}


// MARK: - Extensions -

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

extension UIViewController {
    func presentAlert(title: String?, message: String? = nil, actionTitle: String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}

extension FormController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func manageForm(_ closure: (UILabel, TextField) -> ()) {
        for stackView in formStackView.subviews {
            for view in stackView.subviews {
                if let label = view.subviews.first! as? UILabel, let textField = view.subviews.last! as? TextField {
                    closure(label, textField)
                }
            }
        }
    }
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        datePicker.datePickerMode = .date
        projectNumberPicker.delegate = self
        projectNumberPicker.dataSource = self
        
        manageForm { label, textField in
            textField.setAppearance(to: .disabled)
            
            if let labelType = LabelType(rawValue: label.text!) {
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
                switch labelType {
                case .dateOfBirth, .dateOfVisit:
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerWillEndEditing))
                    toolbar.setItems([doneButton], animated: false)
                    
                    textField.inputView = datePicker
                    textField.inputAccessoryView = toolbar
                case .projectNumber:
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerViewWillEndEditing))
                    toolbar.setItems([doneButton], animated: false)
                    
                    textField.inputView = projectNumberPicker
                    textField.inputAccessoryView = toolbar
                default: break
                }
            }
        }
    }
    
    // MARK: - TextField
    
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
                return "08 / 07 / 1975"
            case .socialSecurityNumber:
                return "123-45-6789"
            case .projectNumber:
                return "2002"
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
                textField.setAppearance(to: .focused)
            }
        }
        
        animator.startAnimation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            if let textField = textField as? TextField {
                textField.setAppearance(to: .normal)
            }
        }
    
        animator.startAnimation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIPickerView
    
    @objc func datePickerWillEndEditing() {
        manageForm { label, textField in
            if let type = LabelType(rawValue: label.text!), type == .dateOfBirth || type == .dateOfVisit {
                textField.text = dateFormatter.string(from: datePicker.date)
            }
        }
        
        view.endEditing(true)
    }
    
    @objc func pickerViewWillEndEditing() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Employee.registeredProjectNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Employee.registeredProjectNumbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manageForm { label, textField in
            if let type = LabelType(rawValue: label.text!), type == .projectNumber {
                textField.text = "\(Employee.registeredProjectNumbers[row])"
            }
        }
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            actionContainerTopConstraint.constant = frame.size.height - actionContainer.frame.height
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        actionContainerTopConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
}
