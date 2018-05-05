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
    
    init(name: Name?, address: Address?, dateOfBirth: Date?, socialSecurityNumber: String?, type: ManagerType) throws {
        guard name != nil, !name!.isIncomplete else {
            throw FormError.invalidName("Your name is incomplete.")
        }
        
        guard !name!.containsSpecialCharacters else {
            throw FormError.invalidName("Your name contains special characters.")
        }
        
        guard dateOfBirth != nil else {
            throw FormError.invalidDate("Your birth date is not in the correct format.")
        }
        
        guard let string = socialSecurityNumber, Manager.isValidSSN(string) else {
            throw FormError.invalidNumber("Your social security number is not in the correct format.")
        }
        
        guard address != nil, !address!.isIncomplete else {
            throw FormError.invalidAddress("Your address is incomplete.")
        }
        
        guard !address!.containsSpecialCharacters else {
            throw FormError.invalidAddress("Your address consists of invalid characters.")
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.type = type
    }
    
}