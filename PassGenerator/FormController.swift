import UIKit

class FormController: UIViewController {
    
    @IBOutlet weak var entrantTypeSegmentedControl: SegmentedControl!
    @IBOutlet weak var entrantSubtypeSegmentedControl: SegmentedControl!
    @IBOutlet weak var formStackView: UIStackView!
    
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var populateDataButton: UIButton!
    
    var typeIsSelected: Bool {
        return entrantTypeSegmentedControl.selectedSegmentIndex != -1
    }
    
    var subtypeIsSelected: Bool {
        return entrantSubtypeSegmentedControl.selectedSegmentIndex != -1
    }
    
    var data: [String: Any?] {
        var firstName = ""
        var lastName = ""
        var dateOfBirth: Date? = nil
        var socialSecurityNumber: String? = nil
        var dateOfVisit: Date? = nil
        var street = ""
        var city = ""
        var state = ""
        var zipCode = 0
        
        doSomething { label, textField in
            if let type = LabelType(rawValue: label.text!), let text = textField.text {
                switch type {
                case .firstName: firstName = text
                case .lastName: lastName = text
                case .dateOfBirth:
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM / DD / YYYY"
                    dateOfBirth = formatter.date(from: text)
                case .socialSecurityNumber: socialSecurityNumber = text
                case .streetAddress: street = text
                case .city: city = text
                case .state: state = text
                case .zipCode: if let number = Int(text) { zipCode = number }
                case .dateOfVisit:
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM / DD / YYYY"
                    dateOfVisit = formatter.date(from: text)
                }
            }
        }
        
        return [
            "name": Name(firstName, lastName),
            "dateOfBirth": dateOfBirth,
            "socialSecurityNumber": socialSecurityNumber,
            "address": Address(street: street, city: city, state: state, zipCode: zipCode),
            "dateOfVisit": dateOfVisit
        ]
    }
    
    var entrant: Passable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if entrant != nil, let passController = segue.destination as? PassController  {
            passController.pass = Pass(contentsOf: entrant!)
        }
    }
    
    @IBAction func showCategories() {
        let titles: [String]
        
        switch entrantTypeSegmentedControl.titleForSegment(at: entrantTypeSegmentedControl.selectedSegmentIndex)! {
        case "Guest":
            titles = GuestType.all()
        case "Employee":
            titles = EmployeeType.all()
        case "Manager":
            titles = ManagerType.all()
        case "Vendor":
            titles = Company.all()
        default:
            fatalError()
        }
        
        entrantSubtypeSegmentedControl.removeAllSegments()
        
        for i in 0..<titles.count {
            entrantSubtypeSegmentedControl.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
    }
    
    @IBAction func populateData() {
        doSomething { label, textField in
            if let type = LabelType(rawValue: label.text!) {
                textField.text = LabelType.text(for: type)
            }
        }
    }
    
    @IBAction func generatePass() {
        if typeIsSelected && subtypeIsSelected {
            let name = data["name"] as! Name?
            let dateOfBirth = data["dateOfBirth"] as! Date?
            let socialSecurityNumber = data["socialSecurityNumber"] as! String?
            let address = data["address"] as! Address?
            
            do {
                let selectedIndex = entrantSubtypeSegmentedControl.selectedSegmentIndex
                let text = entrantSubtypeSegmentedControl.titleForSegment(at: selectedIndex)!
                
                switch entrantTypeSegmentedControl.titleForSegment(at: entrantTypeSegmentedControl.selectedSegmentIndex)! {
                case "Guest":
                    if let type = GuestType(rawValue: text) {
                        entrant = try Guest(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: type)
                    }
                case "Employee":
                    if let type = EmployeeType(rawValue: text) {
                        entrant = try Employee(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, projectNumber: nil, type: type)
                    }
                case "Manager":
                    if let type = ManagerType(rawValue: text) {
                        entrant = try Manager(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: type)
                    }
                case "Vendor":
                    if let company = Company(rawValue: text) {
                        entrant = try Vendor(name: name, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, company: company, dateOfVisit: nil)
                    }
                default:
                    fatalError()
                }
            } catch let error as FormError {
                presentAlert(title: "Error", message: error.description)
            } catch {
                fatalError()
            }
        }
        
        if entrant == nil {
            presentAlert(title: "No Data Provided", message: "Please enter required information to generate your pass.")
        }
    }
    
    func doSomething(_ closure: (UILabel, TextField) -> Void) {
        for stackView in formStackView.subviews {
            for view in stackView.subviews {
                if typeIsSelected && subtypeIsSelected {
                    let label = view.subviews.first! as! UILabel
                    let textField = view.subviews.last! as! TextField
                    
                    if textField.state != .disabled {
                        closure(label, textField)
                    }
                }
            }
        }
    }
    
    func presentAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}
