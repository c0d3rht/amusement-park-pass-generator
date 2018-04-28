import Foundation

protocol Passable {
    var name: Name? { get }
    var address: Address? { get }
    var socialSecurityNumber: Int? { get }
    var dateOfBirth: Date? { get }
}

enum FormError: Error {
    case invalidName(String)
    case invalidAddress(String)
    case invalidSocialSecurityNumber(String)
    case invalidDateOfBirth(String)
    
    var description: String {
        switch self {
        case .invalidName(let message): return message
        case .invalidAddress(let message): return message
        case .invalidSocialSecurityNumber(let message): return message
        case .invalidDateOfBirth(let message): return message
        }
    }
}
