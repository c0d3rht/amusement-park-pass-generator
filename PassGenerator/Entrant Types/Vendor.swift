import Foundation

enum Company: String {
    case acme = "ACME"
    case orkin = "Orkin"
    case fedex = "FedEx"
    case nw = "NW Electrical"
}

extension Company {
    static func all() -> [String] {
        return [Company.acme.rawValue, Company.orkin.rawValue, Company.fedex.rawValue, Company.nw.rawValue]
    }
}

class Vendor: Passable {
    var name: Name?
    var address: Address?
    var dateOfBirth: Date?
    var socialSecurityNumber: String?
    let company: Company
    let dateOfVisit: Date?
    
    init(name: Name?, address: Address?, dateOfBirth: Date?, socialSecurityNumber: String?, company: Company, dateOfVisit: Date?) throws {
        guard dateOfBirth != nil else {
            throw FormError.invalidDate("Your birth date is not in the correct format.")
        }
        
        guard dateOfVisit != nil else {
            throw FormError.invalidDate("The date of visit is not in the correct format.")
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.socialSecurityNumber = socialSecurityNumber
        self.company = company
        self.dateOfVisit = dateOfVisit
    }
    
}
