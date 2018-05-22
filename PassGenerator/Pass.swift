import Foundation

protocol PassDelegate: class {
    func didSwipeWhenAccessGranted()
    func didSwipeWhenAccessDenied()
    func didSwipeDuringProcessingTime(seconds: Double)
    func processingTimeDidElapse()
}

class Pass: CustomStringConvertible {

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
        case is Guest:
            return [.amusement]
        default:
            return []
        }
    }
    
    var rideAccess: [RideAccess] {
        switch entrant {
        case is Guest:
            switch (entrant as! Guest).type {
            case .vip, .season, .senior:
                return [.allRides, .skipQueues]
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
    
    let messageDuration = 5.0
    var lastTimeSwiped: Date? = nil {
        didSet {
            if let previousDate = oldValue, let existingDate = lastTimeSwiped, existingDate < previousDate.addingTimeInterval(messageDuration) {
                lastTimeSwiped = previousDate
            }
        }
    }
    
    var description: String {
        switch entrant {
        case is Guest:
            return (entrant as! Guest).type.rawValue + " Pass"
        case is Employee:
            let employee = entrant as! Employee
            let type = employee.type
            
            switch type {
            case .maintenance:
                return type.rawValue + " Employee"
            case .contract:
                return type.rawValue + " Employee (\(employee.projectNumber!))"
            default:
                return type.rawValue
            }
        case is Manager:
            return (entrant as! Manager).type.rawValue
        case is Vendor:
            return "Vendor Pass"
        default:
            return "Unidentified Pass"
        }
    }
    
    weak var delegate: PassDelegate?
    
    init(contentsOf entrant: Passable) {
        self.entrant = entrant
    }
    
    func hasAccess<T: AccessType>(to type: T) -> Bool {
        switch type {
        case is AccessibleArea: return accessibleAreas.contains(type as! AccessibleArea)
        case is RideAccess: return rideAccess.contains(type as! RideAccess)
        default: return false
        }
    }
    
    func swipe<T: AccessType>(for type: T) {
        let currentTime = Date()
        lastTimeSwiped = currentTime
        
        if let date = lastTimeSwiped {
            if date == currentTime {
                if hasAccess(to: type) {
                    delegate?.didSwipeWhenAccessGranted()
                } else {
                    delegate?.didSwipeWhenAccessDenied()
                }
            } else {
                delegate?.didSwipeDuringProcessingTime(seconds: messageDuration)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + messageDuration) {
                self.delegate?.processingTimeDidElapse()
            }
        }
    }
    
}

