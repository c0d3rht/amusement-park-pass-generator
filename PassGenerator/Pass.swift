import Foundation

protocol PassDelegate: class {
    func didSwipeWhenAccessGranted(for type: AccessType)
    func didSwipeWhenAccessDenied(for type: AccessType)
    func didSwipeDuringProcessingTime(seconds: Double)
    func processingTimeDidElapse()
}

class Pass {

    let entrant: Passable
    
    fileprivate var timer = Timer()
    static let processingDuration = 5.0
    
    var lastTimeSwiped: Date? = nil {
        didSet {
            if let previousDate = oldValue, let existingDate = lastTimeSwiped, existingDate < previousDate.addingTimeInterval(Pass.processingDuration) {
                lastTimeSwiped = previousDate
            }
        }
    }
    
    weak var delegate: PassDelegate?
    
    init(contentsOf entrant: Passable) {
        self.entrant = entrant
    }
    
    func hasAccess<T: AccessType>(to type: T) -> Bool {
        switch type {
        case is AccessibleArea:
            return accessibleAreas.contains(type as! AccessibleArea)
        case is RideAccess:
            return rideAccess.contains(type as! RideAccess)
        case is Discount:
            return (type as! Discount).isAvailable()
        default: return false
        }
    }
    
    func swipe<T: AccessType>(for type: T) {
        let currentTime = Date()
        lastTimeSwiped = currentTime
        
        if let date = lastTimeSwiped {
            if date == currentTime {
                if hasAccess(to: type) {
                    delegate?.didSwipeWhenAccessGranted(for: type)
                } else {
                    delegate?.didSwipeWhenAccessDenied(for: type)
                }
            } else {
                delegate?.didSwipeDuringProcessingTime(seconds: Pass.processingDuration)
            }
            
            if !timer.isValid {
                var secondsLeft = Pass.processingDuration
                
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
                    if secondsLeft > 0 {
                        secondsLeft -= 1
                    } else {
                        self.delegate?.processingTimeDidElapse()
                        self.timer.invalidate()
                    }
                }
            }
        }
    }
    
}

extension Pass: CustomStringConvertible {
    
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
    
    var accessibleAreas: [AccessibleArea] {
        switch entrant {
        case is Employee:
            let employee = entrant as! Employee
            
            switch employee.type {
            case .food:
                return [.amusement, .kitchen]
            case .ride:
                return [.amusement, .rideControl]
            case .maintenance:
                return [.amusement, .kitchen, .rideControl, .maintenance]
            case .contract:
                switch employee.projectNumber {
                case 1001:
                    return [.amusement, .rideControl]
                case 1002:
                    return [.amusement, .rideControl, .maintenance]
                case 1003:
                    return [.amusement, .kitchen, .rideControl, .maintenance, .office]
                case 2001:
                    return [.office]
                case 2002:
                    return [.kitchen, .maintenance]
                default:
                    return []
                }
            }
        case is Manager:
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        case is Vendor:
            switch (entrant as! Vendor).company {
            case .acme:
                return [.kitchen]
            case .orkin:
                return [.amusement, .kitchen, .rideControl]
            case .fedex:
                return [.maintenance, .office]
            case .nwElectrical:
                return [.amusement, .kitchen, .rideControl, .maintenance, .office]
            }
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
    
    var discount: Discount {
        switch entrant {
        case is Guest:
            switch (entrant as! Guest).type {
            case .vip, .season:
                return Discount(food: 10, merchandise: 20)
            case .senior:
                return Discount(food: 10, merchandise: 10)
            default:
                return Discount.none
            }
        case is Employee where (entrant as! Employee).type != .contract:
            return Discount(food: 15, merchandise: 25)
        case is Manager:
            return Discount(food: 25, merchandise: 25)
        default:
            return Discount.none
        }
    }
    
}
