import Foundation

enum ManagerType: String {
    case shift = "Shift Manager"
    case general = "General Manager"
    case senior = "Senior Manager"
}

extension ManagerType {
    static func all() -> [String] {
        return [ManagerType.shift.rawValue, ManagerType.general.rawValue, ManagerType.senior.rawValue]
    }
}

class Manager: Passable {
    let name: Name?
    let address: Address?
    let dateOfBirth: Date?
    let socialSecurityNumber: String?
    let type: ManagerType
    
    init(name: Name?, dateOfBirth: Date?, socialSecurityNumber: String?, address: Address?, type: ManagerType) throws {
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
        
        if type == .senior {
            guard Employee.isSenior(dateOfBirth: date) else {
                throw FormError.invalidDate("You cannot apply to be a senior manager.")
            }
        }
        
        guard let string = Employee.extractSSN(from: socialSecurityNumber) else {
            throw FormError.invalidSocialSecurityNumber("Your social security number is not in the correct format.")
        }
        
        guard let address = address, !address.isIncomplete else {
            throw FormError.invalidAddress("Your address is incomplete.")
        }
        
        guard !address.containsSpecialCharacters else {
            throw FormError.invalidAddress("Your address consists of invalid characters.")
        }
        
        self.name = name
        self.dateOfBirth = date
        self.socialSecurityNumber = string
        self.address = address
    }
    
}
