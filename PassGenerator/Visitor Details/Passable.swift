import Foundation

struct FormChecker {
    static func ssnMatchesFormat(_ string: String) -> Bool {
        let pattern = "\\s*\\d{3}\\s*-?\\s*\\d{2}\\s*-?\\s*\\d{4}\\s*"
        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        return expression.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count)).count == 1
    }
}

protocol Passable {
    var name: Name? { get }
    var address: Address? { get }
    var socialSecurityNumber: String? { get }
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
