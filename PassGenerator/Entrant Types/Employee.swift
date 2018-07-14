import Foundation

enum EmployeeType: String {
    case food = "Food Services"
    case ride = "Ride Services"
    case maintenance = "Maintenance"
    case contract = "Contract"
}

extension EmployeeType {
    static func all() -> [String] {
        return [EmployeeType.food.rawValue, EmployeeType.ride.rawValue, EmployeeType.maintenance.rawValue, EmployeeType.contract.rawValue]
    }
}

class Employee: Passable {
    let name: Name?
    let address: Address?
    let dateOfBirth: Date?
    let socialSecurityNumber: String?
    let projectNumber: Int?
    let type: EmployeeType
    
    static let registeredProjectNumbers = [1001, 1002, 1003, 2001, 2002]
    
    init(name: Name?, dateOfBirth: Date?, socialSecurityNumber: String?, address: Address?, projectNumber: Int?, type: EmployeeType) throws {
        self.type = type
        
        guard let name = name, !name.isIncomplete else {
            throw FormError.invalidName("Your name is incomplete.")
        }
        
        guard !name.containsSpecialCharacters else {
            throw FormError.invalidName("Your name contains special characters.")
        }
        
        guard let date = dateOfBirth else {
            throw FormError.invalidDate("Your birth date is not in the correct format.")
        }
        
        guard let string = socialSecurityNumber, let extractedString = Employee.extractSSN(from: string) else {
            throw FormError.invalidSocialSecurityNumber("Your social security number is not in the correct format.")
        }
        
        guard let address = address, !address.isIncomplete else {
            throw FormError.invalidAddress("Your address is incomplete.")
        }
        
        guard !address.containsSpecialCharacters else {
            throw FormError.invalidAddress("Your address consists of invalid characters.")
        }
        
        if type == .contract {
            guard let number = projectNumber, Employee.registeredProjectNumbers.contains(number) else {
                throw FormError.invalidProjectNumber("Your project is not listed in our database.")
            }
        }
        
        self.name = name
        self.dateOfBirth = date
        self.socialSecurityNumber = extractedString
        self.address = address
        self.projectNumber = projectNumber
    }
    
}
