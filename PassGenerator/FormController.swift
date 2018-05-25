import UIKit

class FormController: UIViewController {
    
    enum Key {
        case name, dateOfBirth, address, socialSecurityNumber, projectNumber, dateOfVisit
    }
    
    // MARK: - Views and Constraints
    
    @IBOutlet weak var typeSegmentedControl: SegmentedControl!
    @IBOutlet weak var subtypeSegmentedControl: SegmentedControl!
    @IBOutlet weak var formStackView: UIStackView!
    
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var actionContainerTopConstraint: NSLayoutConstraint!
    
    let datePicker = UIDatePicker()
    let projectNumberPicker = UIPickerView()
    
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
                switch type {
                case .firstName: firstName = text
                case .lastName: lastName = text
                case .dateOfBirth: dateOfBirth = dateFormatter.date(from: text)
                case .socialSecurityNumber: socialSecurityNumber = text
                case .streetAddress: street = text
                case .city: city = text
                case .state: state = text
                case .zipCode: zipCode = text
                case .projectNumber: if let number = Int(text) { projectNumber = number }
                case .dateOfVisit: dateOfVisit = dateFormatter.date(from: text)
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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / dd / yyyy"
        
        return formatter
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let entrant = entrant, let passController = segue.destination as? PassController  {
            passController.pass = Pass(contentsOf: entrant)
        }
    }
    
    @IBAction func showCategories() {
        manageForm { $1.setAppearance(to: .disabled) }
        
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
                textField.setAppearance(to: .normal)
            }
            
            if let labelType = LabelType(rawValue: label.text!) {
                if labelType == .companyName {
                    textField.setAppearance(to: .disabled)
                }
                
                switch typeText {
                case "Guest":
                    if let guestType = GuestType(rawValue: subtypeText) {
                        switch labelType {
                        case .socialSecurityNumber, .projectNumber, .dateOfVisit:
                            textField.setAppearance(to: .disabled)
                        default: break
                        }
                        
                        if guestType != .season {
                            switch labelType {
                            case .streetAddress, .city, .state, .zipCode:
                                textField.setAppearance(to: .disabled)
                            default: break
                            }
                        }
                    }
                case "Employee":
                    if let employeeType = EmployeeType(rawValue: subtypeText) {
                        if (employeeType != .contract && labelType == .projectNumber) || labelType == .dateOfVisit {
                            textField.setAppearance(to: .disabled)
                        }
                    }
                case "Manager":
                    if labelType == .projectNumber || labelType == .dateOfVisit {
                        textField.setAppearance(to: .disabled)
                    }
                case "Vendor":
                    switch labelType {
                    case .socialSecurityNumber, .projectNumber, .streetAddress, .city, .state, .zipCode:
                        textField.setAppearance(to: .disabled)
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
                let title: String
                
                switch error {
                case .invalidName: title = "Invalid Name"
                case .invalidDate: title = "Invalid Date"
                case .invalidSocialSecurityNumber: title = "Invalid SSN"
                case .invalidAddress: title = "Invalid Address"
                case .invalidProjectNumber: title = "Invalid Project Number"
                }
                
                presentAlert(title: title, message: error.description)
            } catch {
                fatalError()
            }
        } else {
            presentAlert(title: "Error", message: "Select the type of pass you wish to generate.")
        }
    }
    
}
