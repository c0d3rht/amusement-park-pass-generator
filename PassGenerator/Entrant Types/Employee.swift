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
    
    init(name: Name?, address: Address?, dateOfBirth: Date?, socialSecurityNumber: String?, projectNumber: Int?, type: EmployeeType) throws {
        guard let name = name, !name.isIncomplete else {
            throw FormError.invalidName("Your name is incomplete.")
        }
        
        guard !name.containsSpecialCharacters else {
            throw FormError.invalidName("Your name contains special characters.")
        }
        
        guard dateOfBirth != nil else {
            throw FormError.invalidDate("Your birth date is not in the correct format.")
        }
        
        guard let string = socialSecurityNumber, Employee.isValidSSN(string) else {
            throw FormError.invalidNumber("Your social security number is not in the correct format.")
        }
        
        guard let address = address, !address.isIncomplete else {
            throw FormError.invalidAddress("Your address is incomplete.")
        }
        
        guard !address.containsSpecialCharacters else {
            throw FormError.invalidAddress("Your address consists of invalid characters.")
        }
        
        if type == .contract {
            guard projectNumber != nil else {
                throw FormError.invalidNumber("Your project is not listed in our database.")
            }
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.projectNumber = projectNumber
        self.type = type
    }
    
}
