import Foundation

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
    case invalidDate(String)
    case invalidProjectNumber(String)
    
    var description: String {
        switch self {
        case .invalidName(let message): return message
        case .invalidDate(let message): return message
        case .invalidSocialSecurityNumber(let message): return message
        case .invalidAddress(let message): return message
        case .invalidProjectNumber(let message): return message
        }
    }
}

// MARK: - Extensions

extension Passable {
    
    static func isChild(dateOfBirth date: Date) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year], from: date, to: Date())
        return dateComponents.year! <= 5
    }
    
    static func isSenior(dateOfBirth date: Date) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year], from: date, to: Date())
        return dateComponents.year! >= 65
    }
    
    static func isValidSSN(_ string: String) -> Bool {
        let pattern = "\\W\\s*(\\d{3})\\s*-?\\s*(\\d{2})\\s*-?\\s*(\\d{4})\\W\\s*"
        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        return expression.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count)).count == 1
    }
    
}
