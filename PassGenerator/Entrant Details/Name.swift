import Foundation

struct Name: CustomStringConvertible {
    let firstName: String
    let lastName: String
    
    var isIncomplete: Bool {
        return firstName.isEmpty || lastName.isEmpty
    }
    
    var containsSpecialCharacters: Bool {
        return firstName.rangeOfCharacter(from: .decimalDigits) != nil || lastName.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    init(_ firstName: String, _ lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
