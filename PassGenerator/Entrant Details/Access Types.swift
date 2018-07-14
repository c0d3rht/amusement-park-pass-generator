import Foundation

protocol AccessType {}

enum AccessibleArea: String, AccessType {
    case amusement = "Amusement"
    case kitchen = "Kitchen"
    case rideControl = "Ride Control"
    case maintenance = "Maintenance"
    case office = "Office"
}

enum RideAccess: String, AccessType {
    case allRides = "All Rides"
    case skipQueues = "Skip Queues"
}

struct Discount: AccessType, Equatable {
    let food: Int
    let merchandise: Int
}

extension Discount {
    static let none = Discount(food: 0, merchandise: 0)
    
    func isAvailable() -> Bool {
        return self != Discount.none
    }
}
