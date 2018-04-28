import Foundation

protocol PassDelegate {
    func didSwipeWhenAccessGranted(_ pass: Pass)
    func didSwipeWhenAccessDenied(_ pass: Pass)
}

class Pass {
    
    let visitor: Passable
    
    var accessibleAreas: [AccessibleArea] {
        switch visitor {
        case is Guest:
            return [.amusement]
        case is Employee:
            switch (visitor as! Employee).type {
            case .food:
                return [.amusement, .kitchen]
            case .ride:
                return [.amusement, .rideControl]
            case .maintenance:
                return [.amusement, .kitchen, .rideControl, .maintenance]
            }
        case is Manager:
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        default:
            return []
        }
    }
    
    var rideAccess: [RideAccess] {
        if visitor is Guest && (visitor as! Guest).type == .vip {
            return [.allRides, .skipRides]
        }
        
        return [.allRides]
    }
    
    var discount: Discount? {
        if visitor is Guest && (visitor as! Guest).type == .vip {
            return (food: 10, merchandise: 20)
        }
        
        switch visitor {
        case is Employee:
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
    
    var delegate: PassDelegate?
    
    init(contentsOf visitor: Passable) {
        self.visitor = visitor
    }
    
    func hasAccess(to area: AccessibleArea) -> Bool {
        return accessibleAreas.contains(area)
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
