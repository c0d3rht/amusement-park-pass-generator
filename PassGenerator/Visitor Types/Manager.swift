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
    var socialSecurityNumber: Int?
    let type: ManagerType
    
    init(name: Name?, address: Address?, dateOfBirth: Date?, socialSecurityNumber: Int?, type: ManagerType) throws {
        guard dateOfBirth != nil else {
            throw FormError.invalidDateOfBirth("Your birth date is not in the correct format.")
        }
        
        guard let number = socialSecurityNumber, String(number).count == 9 else {
            throw FormError.invalidSocialSecurityNumber("Your social security number is not in the correct format.")
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.type = type
    }
    
}