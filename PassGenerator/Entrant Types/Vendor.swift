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
    let name: Name?
    let address: Address?
    let dateOfBirth: Date?
    let socialSecurityNumber: String?
    let dateOfVisit: Date?
    let company: Company
    
    init(name: Name?, dateOfBirth: Date?, socialSecurityNumber: String?, address: Address?, dateOfVisit: Date?, company: Company) throws {
        guard let date = dateOfBirth else {
            throw FormError.invalidDate("Your birth date is not in the correct format.")
        }
        
        guard dateOfVisit != nil else {
            throw FormError.invalidDate("The date of visit is not in the correct format.")
        }
        
        self.name = name
        self.address = address
        self.dateOfBirth = date
        self.socialSecurityNumber = socialSecurityNumber
        self.dateOfVisit = dateOfVisit
        self.company = company
    }
    
}
