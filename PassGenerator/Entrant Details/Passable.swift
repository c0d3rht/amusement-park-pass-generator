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
    case invalidNumber(String)
    case invalidDate(String)
    
    var description: String {
        switch self {
        case .invalidName(let message): return message
        case .invalidAddress(let message): return message
        case .invalidNumber(let message): return message
        case .invalidDate(let message): return message
        }
    }
}

// MARK: - Extensions

extension Date {
    func compare(years: Int) -> ComparisonResult {
        if abs(timeIntervalSinceNow) < Double(years * 31536000) {
            return ComparisonResult.orderedAscending
        }
        
        return ComparisonResult.orderedDescending
    }
}

extension Passable {
    static func isValidSSN(_ string: String) -> Bool {
        let pattern = "\\s*(\\d{3})\\s*-?\\s*(\\d{2})\\s*-?\\s*(\\d{4})\\s*"
        let expression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        return expression.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count)).count == 1
    }
}
