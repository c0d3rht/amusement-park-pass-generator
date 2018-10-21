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
        return dateComponents.year! >= 40
    }
    
    static func extractSSN(from string: String) -> String? {
        let pattern = "\\s*(\\d{3})\\s*-?\\s*(\\d{2})\\s*-?\\s*(\\d{4})\\s*"
        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = expression.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count))
        
        let text = matches.map { String(string[Range($0.range, in: string)!]) }.first
        return text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
}
