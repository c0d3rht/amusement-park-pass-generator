import Foundation

struct Address: CustomStringConvertible {
    let street: String
    let city: String
    let state: String
    let zipCode: String
    
    var isIncomplete: Bool {
        return street.isEmpty || city.isEmpty || state.isEmpty
    }
    
    var containsSpecialCharacters: Bool {
        return city.rangeOfCharacter(from: .decimalDigits) != nil || state.rangeOfCharacter(from: .decimalDigits) != nil || zipCode.rangeOfCharacter(from: .decimalDigits) == nil
    }
    
    var description: String {
        return "\(street), \(city), \(state) - \(zipCode)"
    }
    
    init(street: String, city: String, state: String, zipCode: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}
