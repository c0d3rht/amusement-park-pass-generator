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
