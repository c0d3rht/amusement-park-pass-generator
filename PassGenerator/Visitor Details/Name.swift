import Foundation

class Name: Equatable, CustomStringConvertible {
    let firstName: String
    let lastName: String
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    init(_ firstName: String, _ lastName: String) throws {
        guard !firstName.isEmpty && !lastName.isEmpty else {
            throw FormError.invalidName("Your name is incomplete.")
        }
        
        guard firstName.rangeOfCharacter(from: .decimalDigits) == nil && lastName.rangeOfCharacter(from: .decimalDigits) == nil else {
            throw FormError.invalidName("Your name contains special characters.")
        }
        
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static func == (lhs: Name, rhs: Name) -> Bool {
        return lhs.description == rhs.description
    }
}
