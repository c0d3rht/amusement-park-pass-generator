import Foundation

enum GuestType: String {
    case classic = "Classic"
    case vip = "VIP"
    case child = "Child"
    case season = "Season"
    case senior = "Senior"
}

extension GuestType {
    static func all() -> [String] {
        return [GuestType.classic.rawValue, GuestType.vip.rawValue, GuestType.child.rawValue, GuestType.season.rawValue, GuestType.senior.rawValue]
    }
}

class Guest: Passable {
    var name: Name?
    var address: Address?
    var dateOfBirth: Date?
    var socialSecurityNumber: String?
    let type: GuestType
    
    init(name: Name?, dateOfBirth: Date?, socialSecurityNumber: String?, address: Address?, type: GuestType) throws {
        if type == .child || type == .season || type == .senior {
            if type == .season || type == .senior {
                guard let name = name, !name.isIncomplete else {
                    throw FormError.invalidName("Your name is incomplete.")
                }
                
                guard !name.containsSpecialCharacters else {
                    throw FormError.invalidName("Your name contains special characters.")
                }
                
                if type == .season {
                    guard let address = address, !address.isIncomplete else {
                        throw FormError.invalidAddress("Your address is incomplete.")
                    }
                    
                    guard !address.containsSpecialCharacters else {
                        throw FormError.invalidAddress("Your address consists of invalid characters.")
                    }
                }
            }
            
            guard let date = dateOfBirth else {
                throw FormError.invalidDate("Your birth date is not in the correct format.")
            }
            
            if type == .child {
                guard date.compare(years: 5) == .orderedAscending else {
                    throw FormError.invalidDate("Your child is over the age of 5 years.")
                }
            } else if type == .senior {
                guard date.compare(years: 65) == .orderedDescending else {
                    throw FormError.invalidDate("Your child is over the age of 5 years.")
                }
            }
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.type = type
    }
    
}
