import UIKit

class FormController: UIViewController {
    
    enum Key {
        case name, dateOfBirth, address, socialSecurityNumber, projectNumber, dateOfVisit
    }
    
    // MARK: - Views
    
    @IBOutlet weak var typeSegmentedControl: SegmentedControl!
    @IBOutlet weak var subtypeSegmentedControl: SegmentedControl!
    @IBOutlet weak var formStackView: UIStackView!
    
    // MARK: - Local Variables, Constants and Computed Properties
    
    var typeText: String {
        return typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex)!
    }
    
    var subtypeText: String {
        return subtypeSegmentedControl.titleForSegment(at: subtypeSegmentedControl.selectedSegmentIndex)!
    }
    
    var passTypeIsSelected: Bool {
        return typeSegmentedControl.selectedSegmentIndex != -1 && subtypeSegmentedControl.selectedSegmentIndex != -1
    }
    
    var data: [Key: Any?] {
        var firstName = ""
        var lastName = ""
        var dateOfBirth: Date? = nil
        var socialSecurityNumber: String? = nil
        var projectNumber: Int? = nil
        var dateOfVisit: Date? = nil
        var street = ""
        var city = ""
        var state = ""
        var zipCode = ""
        
        manageForm { label, textField in
            if passTypeIsSelected && textField.state != .disabled, let type = LabelType(rawValue: label.text!), let text = textField.text {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM / dd / yyyy"
                
                switch type {
                case .firstName: firstName = text
                case .lastName: lastName = text
                case .dateOfBirth: dateOfBirth = formatter.date(from: text)
                case .socialSecurityNumber: socialSecurityNumber = text
                case .streetAddress: street = text
                case .city: city = text
                case .state: state = text
                case .zipCode: zipCode = text
                case .projectNumber: if let number = Int(text) { projectNumber = number }
                case .dateOfVisit: dateOfVisit = formatter.date(from: text)
                default: break
                }
            }
        }
        
        return [
            .name: Name(firstName, lastName),
            .dateOfBirth: dateOfBirth,
            .socialSecurityNumber: socialSecurityNumber,
            .address: Address(street: street, city: city, state: state, zipCode: zipCode),
            .projectNumber: projectNumber,
            .dateOfVisit: dateOfVisit
        ]
    }
    
    var entrant: Passable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageForm { $1.setState(to: .disabled) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let entrant = entrant, let passController = segue.destination as? PassController  {
            passController.pass = Pass(contentsOf: entrant)
        }
    }
    
    @IBAction func showCategories() {
        manageForm { $1.setState(to: .disabled) }
        
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
            if !textField.isFirstResponder {
                textField.setState(to: .normal)
            }
            
            if let labelType = LabelType(rawValue: label.text!) {
                if labelType == .companyName {
                    textField.setState(to: .disabled)
                }
                
                switch typeText {
                case "Guest":
                    if let guestType = GuestType(rawValue: subtypeText) {
                        switch labelType {
                        case .socialSecurityNumber, .projectNumber, .dateOfVisit:
                            textField.setState(to: .disabled)
                        default: break
                        }
                        
                        if guestType != .season {
                            switch labelType {
                            case .streetAddress, .city, .state, .zipCode:
                                textField.setState(to: .disabled)
                            default: break
                            }
                        }
                    }
                case "Employee":
                    if let employeeType = EmployeeType(rawValue: subtypeText) {
                        if (employeeType != .contract && labelType == .projectNumber) || labelType == .dateOfVisit {
                            textField.setState(to: .disabled)
                        }
                    }
                case "Manager":
                    if labelType == .projectNumber || labelType == .dateOfVisit {
                        textField.setState(to: .disabled)
                    }
                case "Vendor":
                    switch labelType {
                    case .socialSecurityNumber, .projectNumber, .streetAddress, .city, .state, .zipCode:
                        textField.setState(to: .disabled)
                    case .companyName:
                        textField.text = subtypeText
                    default: break
                    }
                default: break
                }
            }
        }
    }
    
    @IBAction func populateData() {
        manageForm { label, textField in
            if passTypeIsSelected, textField.state != .disabled, let type = LabelType(rawValue: label.text!) {
                textField.text = LabelType.sampleText(for: type)
            }
        }
    }
    
    @IBAction func generatePass() {
        if passTypeIsSelected {
            let name = data[.name] as? Name
            let dateOfBirth = data[.dateOfBirth] as? Date
            let socialSecurityNumber = data[.socialSecurityNumber] as? String
            let address = data[.address] as? Address
            let projectNumber = data[.projectNumber] as? Int
            let dateOfVisit = data[.dateOfVisit] as? Date
            
            do {
                switch typeText {
                case "Guest":
                    if let type = GuestType(rawValue: subtypeText) {
                        entrant = try Guest(name: name, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, address: address, type: type)
                    }
                case "Employee":
                    if let type = EmployeeType(rawValue: subtypeText) {
                        entrant = try Employee(name: name, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: projectNumber, type: type)
                    }
                case "Manager":
                    if let type = ManagerType(rawValue: subtypeText) {
                        entrant = try Manager(name: name, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, address: address, type: type)
                    }
                case "Vendor":
                    if let company = Company(rawValue: subtypeText) {
                        entrant = try Vendor(name: name, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, address: address, dateOfVisit: dateOfVisit, company: company)
                    }
                default: break
                }
            } catch let error as FormError {
                presentAlert(title: "Error", message: error.description)
            } catch {
                fatalError()
            }
        } else {
            presentAlert(title: "Error", message: "Select the type of pass you wish to generate.")
        }
    }
    
    func manageForm(_ closure: (UILabel, TextField) -> ()) {
        for stackView in formStackView.subviews {
            for view in stackView.subviews {
                if let label = view.subviews.first! as? UILabel, let textField = view.subviews.last! as? TextField {
                    closure(label, textField)
                }
            }
        }
    }
    
}
