import Foundation

protocol PassDelegate {
    func didSwipeWhenAccessGranted(_ pass: Pass)
    func didSwipeWhenAccessDenied(_ pass: Pass)
}

class Pass {

    let entrant: Passable
    
    var accessibleAreas: [AccessibleArea] {
        switch entrant {
        case is Employee:
            switch (entrant as! Employee).type {
            case .food, .contract:
                return [.amusement, .kitchen]
            case .ride:
                return [.amusement, .rideControl]
            case .maintenance:
                return [.amusement, .kitchen, .rideControl, .maintenance]
            }
        case is Manager:
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        case is Vendor:
            return [.amusement, .kitchen]
        default:
            return [.amusement]
        }
    }
    
    var rideAccess: [RideAccess] {
        switch entrant {
        case is Guest:
            switch (entrant as! Guest).type {
            case .vip, .season, .senior:
                return [.allRides, .skipRides]
            default:
                return [.allRides]
            }
        case is Employee where (entrant as! Employee).type != .contract, is Manager:
            return [.allRides]
        default:
            return []
        }
    }
    
    var discount: Discount? {
        switch entrant {
        case is Guest:
            switch (entrant as! Guest).type {
            case .vip, .season:
                return (food: 10, merchandise: 20)
            case .senior:
                 return (food: 10, merchandise: 10)
            default:
                return nil
            }
        case is Employee where (entrant as! Employee).type != .contract:
            return (food: 15, merchandise: 25)
        case is Manager:
            return (food: 25, merchandise: 25)
        default:
            return nil
        }
    }
    
    var lastTimeSwiped: Date? = nil {
        didSet {
            if let oldValue = oldValue, let newValue = lastTimeSwiped, newValue < oldValue.addingTimeInterval(5) {
                lastTimeSwiped = oldValue
            }
        }
    }
    
    var type: String {
        switch entrant {
        case is Guest:
            return (entrant as! Guest).type.rawValue + " Pass"
        case is Employee:
            switch (entrant as! Employee).type {
            case .maintenance, .contract:
                return (entrant as! Employee).type.rawValue + " Employee"
            default:
                return (entrant as! Employee).type.rawValue
            }
        case is Manager:
            return (entrant as! Manager).type.rawValue
        case is Vendor:
            return "Vendor Pass"
        default:
            return ""
        }
    }
    
    var delegate: PassDelegate?
    
    init(contentsOf entrant: Passable) {
        self.entrant = entrant
    }
    
    func hasAccess(to area: AccessibleArea) -> Bool {
        return accessibleAreas.contains(area)
    }
    
    func hasAccess(to access: RideAccess) -> Bool {
        return rideAccess.contains(access)
    }
    
    func swipe() {
        let currentTime = Date()
        lastTimeSwiped = currentTime
        
        if lastTimeSwiped == currentTime {
            delegate?.didSwipeWhenAccessGranted(self)
        } else {
            delegate?.didSwipeWhenAccessDenied(self)
        }
    }
    
}
