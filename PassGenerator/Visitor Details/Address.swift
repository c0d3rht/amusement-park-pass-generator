import Foundation

class Address: Equatable, CustomStringConvertible {
    let street: String
    let city: String
    let state: String
    let zipCode: Int
    
    var description: String {
        return "\(street), \(city), \(state) - \(zipCode)"
    }
    
    init(street: String, city: String, state: String, zipCode: Int) throws {
        guard !street.isEmpty && !city.isEmpty && !state.isEmpty else {
            throw FormError.invalidAddress("Your address is incomplete.")
        }
        
        guard city.rangeOfCharacter(from: .decimalDigits) == nil && state.rangeOfCharacter(from: .decimalDigits) == nil && String(zipCode).count <= 6 else {
            throw FormError.invalidAddress("Your address consists of invalid characters.")
        }
        
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.description == rhs.description
    }
}
