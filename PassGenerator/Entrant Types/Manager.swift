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
    var name: Name?
    var address: Address?
    var dateOfBirth: Date?
    var socialSecurityNumber: String?
    let type: ManagerType
    
    init(name: Name?, dateOfBirth: Date?, socialSecurityNumber: String?, address: Address?, type: ManagerType) throws {
        guard let name = name, !name.isIncomplete else {
            throw FormError.invalidName("Your name is incomplete.")
        }
        
        guard !name.containsSpecialCharacters else {
            throw FormError.invalidName("Your name contains special characters.")
        }
        
        guard let date = dateOfBirth else {
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
        
        self.name = name
        self.dateOfBirth = date
        self.socialSecurityNumber = string
        self.address = address
        self.type = type
    }
    
}
