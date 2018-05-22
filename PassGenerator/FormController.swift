import UIKit

class FormController: UIViewController {
    
    @IBOutlet weak var typeSegmentedControl: SegmentedControl!
    @IBOutlet weak var subtypeSegmentedControl: SegmentedControl!
    @IBOutlet weak var formStackView: UIStackView!
    
    var typeText: String {
        return typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex)!
    }
    
    var subtypeText: String {
        return subtypeSegmentedControl.titleForSegment(at: subtypeSegmentedControl.selectedSegmentIndex)!
    }
    
    var typeIsSelected: Bool {
        return typeSegmentedControl.selectedSegmentIndex != -1
    }
    
    var subtypeIsSelected: Bool {
        return subtypeSegmentedControl.selectedSegmentIndex != -1
    }
    
    var data: [String: Any?] {
        var firstName = ""
        var lastName = ""
        var dateOfBirth: Date? = nil
        var socialSecurityNumber: String? = nil
        var projectNumber: Int? = nil
        var dateOfVisit: Date? = nil
        var street = ""
        var city = ""
        var state = ""
        var zipCode = 0
        
        manageForm { label, textField in
            if typeIsSelected && subtypeIsSelected, textField.state != .disabled, let type = LabelType(rawValue: label.text!), let text = textField.text {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM / dd / yyyy"
                
                switch type {
                case .firstName: firstName = text
                case .lastName: lastName = text
                case .dateOfBirth:
                    dateOfBirth = formatter.date(from: text)
                case .socialSecurityNumber: socialSecurityNumber = text
                case .streetAddress: street = text
                case .city: city = text
                case .state: state = text
                case .zipCode: if let number = Int(text) { zipCode = number }
                case .projectNumber: if let number = Int(text) { projectNumber = number }
                case .dateOfVisit:
                    dateOfVisit = formatter.date(from: text)
                default: break
                }
            }
        }
        
        return [
            Keys.name: Name(firstName, lastName),
            Keys.dateOfBirth: dateOfBirth,
            Keys.socialSecurityNumber: socialSecurityNumber,
            Keys.address: Address(street: street, city: city, state: state, zipCode: zipCode),
            Keys.projectNumber: projectNumber,
            Keys.dateOfVisit: dateOfVisit
        ]
    }
    
    var entrant: Passable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        formStackView.translatesAutoresizingMaskIntoConstraints = false
        
//        for stackView in formStackView.subviews {
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        manageForm {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            $1.translatesAutoresizingMaskIntoConstraints = false
            $1.disable()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let entrant = entrant, let passController = segue.destination as? PassController  {
            passController.pass = Pass(contentsOf: entrant)
        }
    }
    
    @IBAction func showCategories() {
        manageForm { $1.disable() }
        
        let titles: [String]
        
        switch typeText {
        case "Guest":
            titles = GuestType.all()
        case "Employee":
            titles = EmployeeType.all()
        case "Manager":
            titles = ManagerType.all()
        case "Vendor":
            titles = Company.all()
        default:
            titles = []
        }
        
        subtypeSegmentedControl.removeAllSegments()
        
        for i in 0..<titles.count {
            subtypeSegmentedControl.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
    }
    
    @IBAction func toggleFields() {
        manageForm { label, textField in
            textField.enable()
            
            if let type = LabelType(rawValue: label.text!), type == .companyName {
                textField.disable()
            }
        }
        
        switch typeText {
        case "Guest":
            if let type = GuestType(rawValue: subtypeText) {
                manageForm { label, textField in
                    if let type = LabelType(rawValue: label.text!) {
                        switch type {
                        case .socialSecurityNumber, .projectNumber, .dateOfVisit:
                            textField.disable()
                        default:
                            break
                        }
                    }
                }
                
                switch type {
                case .classic, .vip, .child, .senior:
                    manageForm { label, textField in
                        if let type = LabelType(rawValue: label.text!) {
                            switch type {
                            case .streetAddress, .city, .state, .zipCode:
                                textField.disable()
                            default:
                                break
                            }
                        }
                    }
                case .season:
                    break
                }
            }
        case "Employee":
            manageForm { label, textField in
                if let type = LabelType(rawValue: label.text!), type == .dateOfVisit {
                    textField.disable()
                }
            }
            
            if let type = EmployeeType(rawValue: subtypeText), type != .contract {
                manageForm { label, textField in
                    if let type = LabelType(rawValue: label.text!), type == .projectNumber {
                        textField.disable()
                    }
                }
            }
        case "Manager":
            manageForm { label, textField in
                if let type = LabelType(rawValue: label.text!), type == .projectNumber || type == .dateOfVisit {
                    textField.disable()
                }
            }
        case "Vendor":
            manageForm { label, textField in
                if let type = LabelType(rawValue: label.text!) {
                    switch type {
                    case .socialSecurityNumber, .projectNumber, .streetAddress, .city, .state, .zipCode:
                        textField.disable()
                    case .companyName:
                        textField.text = subtypeText
                    default:
                        break
                    }
                }
            }
        default:
            break
        }
    }
    
    @IBAction func populateData() {
        manageForm { label, textField in
            if typeIsSelected && subtypeIsSelected, textField.state != .disabled, let type = LabelType(rawValue: label.text!) {
                textField.text = LabelType.sampleText(for: type)
            }
        }
    }
    
    @IBAction func generatePass() {
        if typeIsSelected && subtypeIsSelected {
            let name = data[Keys.name] as? Name
            let dateOfBirth = data[Keys.dateOfBirth] as? Date
            let socialSecurityNumber = data[Keys.socialSecurityNumber] as? String
            let address = data[Keys.address] as? Address
            let projectNumber = data[Keys.projectNumber] as? Int
            let dateOfVisit = data[Keys.dateOfVisit] as? Date
            
            do {
                switch typeText {
                case "Guest":
                    if let type = GuestType(rawValue: subtypeText) {
                        entrant = try Guest(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: type)
                    }
                case "Employee":
                    if let type = EmployeeType(rawValue: subtypeText) {
                        entrant = try Employee(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, projectNumber: projectNumber, type: type)
                    }
                case "Manager":
                    if let type = ManagerType(rawValue: subtypeText) {
                        entrant = try Manager(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: type)
                    }
                case "Vendor":
                    if let company = Company(rawValue: subtypeText) {
                        entrant = try Vendor(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, company: company, dateOfVisit: dateOfVisit)
                    }
                default:
                    break
                }
            } catch let error as FormError {
                presentAlert(title: "Error", message: error.description)
            } catch {
                fatalError()
            }
        }
        
        if entrant == nil {
            presentAlert(title: "Error", message: "Select the type of pass you wish to generate.")
        }
    }
    
    func manageForm(_ closure: (UILabel, TextField) -> ()) {
        for stackView in formStackView.subviews {
            for view in stackView.subviews {
                let label = view.subviews.first! as! UILabel
                let textField = view.subviews.last! as! TextField
                
                closure(label, textField)
            }
        }
    }
    
    func presentAlert(title: String?, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    struct Keys {
        static let name = "name"
        static let dateOfBirth = "dateOfBirth"
        static let socialSecurityNumber = "socialSecurityNumber"
        static let address = "address"
        static let projectNumber = "projectNumber"
        static let dateOfVisit = "dateOfVisit"
    }
    
}
