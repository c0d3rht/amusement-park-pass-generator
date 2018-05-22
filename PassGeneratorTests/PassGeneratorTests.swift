import XCTest
@testable import PassGenerator

class PassGeneratorTests: XCTestCase {
    
    var fullName: Name!
    var address: Address!
    var socialSecurityNumber: String!
    var dateOfBirth: Date!
    
    var entrant: Passable!
    var pass: Pass!
    
    var dateFormatter: TestDateFormatter!
    
    override func setUp() {
        super.setUp()
        
        fullName = Name("John", "Doe")
        address = Address(street: "1 Infinite Loop", city: "Cupertino", state: "California", zipCode: 95014)
        socialSecurityNumber = " 123    45     -   6789   "
        dateOfBirth = Date(timeIntervalSince1970: 956620800000)
        
        dateFormatter = TestDateFormatter()
    }
    
    override func tearDown() {
        super.tearDown()
        
        fullName = nil
        address = nil
        socialSecurityNumber = nil
        dateOfBirth = nil
        
        entrant = nil
        pass = nil
        
        dateFormatter = nil
    }
    
    // MARK: - Tests on Guest Types
    
//    func testClassicGuest() {
//        handleErrors {
//            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .classic))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertTrue(pass.discount == nil)
//    }
//
//    func testVIPGuest() {
//        handleErrors {
//            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .vip))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertTrue(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    func testChildGuest() {
//        handleErrors {
//            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .child))
//        }
//
//        XCTAssertTrue(dateOfBirth.timeIntervalSinceNow > 157680000)
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertTrue(pass.discount == nil)
//    }
//
//    func testSeasonGuest() {
//        handleErrors {
//            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .season))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertTrue(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    func testSeniorGuest() {
//        handleErrors {
//            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .senior))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertTrue(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    // MARK: - Tests on Employee Types
//
//    func testFoodEmployee() {
//        handleErrors {
//            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .food))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertTrue(pass.hasAccess(to: .kitchen))
//        XCTAssertFalse(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    func testRideEmployee() {
//        handleErrors {
//            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .ride))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertFalse(pass.hasAccess(to: .kitchen))
//        XCTAssertTrue(pass.hasAccess(to: .rideControl))
//        XCTAssertFalse(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    func testMaintenanceEmployee() {
//        handleErrors {
//            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .maintenance))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertTrue(pass.hasAccess(to: .kitchen))
//        XCTAssertTrue(pass.hasAccess(to: .rideControl))
//        XCTAssertTrue(pass.hasAccess(to: .maintenance))
//        XCTAssertFalse(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
////    func testContractEmployee() {
////        handleErrors {
////            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .maintenance))
////        }
////
////        XCTAssertTrue(pass.hasAccess(to: .amusement))
////        XCTAssertTrue(pass.hasAccess(to: .kitchen))
////        XCTAssertTrue(pass.hasAccess(to: .rideControl))
////        XCTAssertFalse(pass.hasAccess(to: .maintenance))
////        XCTAssertFalse(pass.hasAccess(to: .office))
////
////        XCTAssertTrue(pass.hasAccess(to: .allRides))
////        XCTAssertFalse(pass.hasAccess(to: .skipRides))
////
////        XCTAssertFalse(pass.discount == nil)
////    }
//
//    // MARK: - Tests on Manager Type(s)
//
//    func testManager() {
//        handleErrors {
//            pass = Pass(contentsOf: try Manager(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .general))
//        }
//
//        XCTAssertTrue(pass.hasAccess(to: .amusement))
//        XCTAssertTrue(pass.hasAccess(to: .kitchen))
//        XCTAssertTrue(pass.hasAccess(to: .rideControl))
//        XCTAssertTrue(pass.hasAccess(to: .maintenance))
//        XCTAssertTrue(pass.hasAccess(to: .office))
//
//        XCTAssertTrue(pass.hasAccess(to: .allRides))
//        XCTAssertFalse(pass.hasAccess(to: .skipQueues))
//
//        XCTAssertFalse(pass.discount == nil)
//    }
//
//    // MARK: - Tests for Accessibility
//
//    func testSwipeAccess() {
//        handleErrors {
//            pass = Pass(contentsOf: try Manager(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .general))
//            pass.delegate = Greeter()
//        }
//
//        pass.swipe() // Access Granted
//
//        if let date = pass.lastTimeSwiped {
//            pass.lastTimeSwiped = date.addingTimeInterval(3)
//            XCTAssertFalse(pass.lastTimeSwiped! == date.addingTimeInterval(3))
//        }
//
//        pass.swipe() // Access Denied
//    }
    
    // MARK: - Helper Methods
    
    func handleErrors(_ closure: () throws -> Void) {
        do {
            try closure()
        } catch let error as FormError {
            print(error.description)
            XCTFail()
        } catch {
            print("\(error)")
            XCTFail()
        }
    }
    
}

// MARK: - Helper Classes

class TestDateFormatter: DateFormatter {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        dateFormat = "dd LLLL"
    }
    
}

//class Greeter: PassDelegate {
//    let formatter = TestDateFormatter()
//    
//    func didSwipeWhenAccessGranted(_ pass: Pass) {
//        if let date = pass.entrant.dateOfBirth, formatter.string(from: Date()) == formatter.string(from: date) {
//            print("\nHappy Birthday!\n")
//        }
//    }
//    
//    func didSwipeWhenAccessDenied(_ pass: Pass) {
//        print("Access Denied")
//    }
//    
//    func didSwipeDuringProcessingTime(_ pass: Pass) {
//        print("\nPlease wait for 5 seconds.\n")
//    }
//    
//}
