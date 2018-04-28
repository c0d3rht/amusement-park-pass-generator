import Foundation

enum GuestType: String {
    case classic = "Classic"
    case vip = "VIP"
    case child = "Child"
}

extension GuestType {
    static func all() -> [String] {
        return [GuestType.classic.rawValue, GuestType.vip.rawValue, GuestType.child.rawValue]
    }
}

class Guest: Passable {
    
    var name: Name?
    var address: Address?
    var dateOfBirth: Date?
    var socialSecurityNumber: Int?
    let type: GuestType
    
    init(name: Name?, address: Address?, dateOfBirth: Date?, socialSecurityNumber: Int?, type: GuestType) throws {
        if type == .child {
            guard dateOfBirth != nil else {
                throw FormError.invalidDateOfBirth("Your birth date is not in the correct format.")
            }
            
            guard dateOfBirth!.timeIntervalSinceNow > 157680000 else {
                throw FormError.invalidDateOfBirth("Your child is over the age of 5 years.")
            }
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.type = type
    }
    
}
