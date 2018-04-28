import Foundation

enum AccessibleArea: String {
    case amusement = "Amusement"
    case kitchen = "Kitchen"
    case rideControl = "Ride Control"
    case maintenance = "Maintenance"
    case office = "Office"
}

enum RideAccess: String {
    case allRides = "Access all rides"
    case skipRides = "Skip ride queues"
}

typealias Discount = (food: Int, merchandise: Int)
