import XCTest
@testable import PassGenerator

class PassGeneratorTests: XCTestCase {
    
    var fullName: Name!
    var address: Address!
    var socialSecurityNumber: String!
    var dateOfBirth: Date!
    
    var visitor: Passable!
    var pass: Pass!
    
    var dateFormatter: TestDateFormatter!
    
    override func setUp() {
        super.setUp()
        
        handleErrors {
            fullName = try Name("John", "Doe")
            address = try Address(street: "1 Infinite Loop", city: "Cupertino", state: "California", zipCode: 95014)
        }
        
        socialSecurityNumber = "123 - 45 - 6789"
        dateOfBirth = Date(timeIntervalSince1970: 956620800000)
        
        dateFormatter = TestDateFormatter()
    }
    
    override func tearDown() {
        super.tearDown()
        
        fullName = nil
        address = nil
        socialSecurityNumber = nil
        dateOfBirth = nil
        
        visitor = nil
        pass = nil
        
        dateFormatter = nil
    }
    
    // MARK: - Tests for Guest Types
    
    func testClassicGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .classic))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertFalse(pass.hasAccess(to: .kitchen))
        XCTAssertFalse(pass.hasAccess(to: .rideControl))
        XCTAssertFalse(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertTrue(pass.discount == nil)
    }
    
    func testVIPGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .vip))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertFalse(pass.hasAccess(to: .kitchen))
        XCTAssertFalse(pass.hasAccess(to: .rideControl))
        XCTAssertFalse(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))

        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertTrue(pass.rideAccess.contains(.skipRides))

        XCTAssertFalse(pass.discount == nil)
    }
    
    func testChildGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .child))
        }
        
        XCTAssertTrue(dateOfBirth.timeIntervalSinceNow > 157680000)
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertFalse(pass.hasAccess(to: .kitchen))
        XCTAssertFalse(pass.hasAccess(to: .rideControl))
        XCTAssertFalse(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertTrue(pass.discount == nil)
    }
    
    // MARK: - Tests for Employee Types
    
    func testFoodEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .food))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertTrue(pass.hasAccess(to: .kitchen))
        XCTAssertFalse(pass.hasAccess(to: .rideControl))
        XCTAssertFalse(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertFalse(pass.discount == nil)
    }
    
    func testRideEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .ride))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertFalse(pass.hasAccess(to: .kitchen))
        XCTAssertTrue(pass.hasAccess(to: .rideControl))
        XCTAssertFalse(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertFalse(pass.discount == nil)
    }
    
    func testMaintenanceEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .maintenance))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertTrue(pass.hasAccess(to: .kitchen))
        XCTAssertTrue(pass.hasAccess(to: .rideControl))
        XCTAssertTrue(pass.hasAccess(to: .maintenance))
        XCTAssertFalse(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertFalse(pass.discount == nil)
    }
    
    // MARK: - Tests for Manager Type(s)
    
    func testManager() {
        handleErrors {
            pass = Pass(contentsOf: try Manager(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .general))
        }
        
        XCTAssertTrue(pass.hasAccess(to: .amusement))
        XCTAssertTrue(pass.hasAccess(to: .kitchen))
        XCTAssertTrue(pass.hasAccess(to: .rideControl))
        XCTAssertTrue(pass.hasAccess(to: .maintenance))
        XCTAssertTrue(pass.hasAccess(to: .office))
        
        XCTAssertTrue(pass.rideAccess.contains(.allRides))
        XCTAssertFalse(pass.rideAccess.contains(.skipRides))
        
        XCTAssertFalse(pass.discount == nil)
    }
    
    // MARK: - Tests for Accessibility
    
    func testSwipeAccess() {
        handleErrors {
            pass = Pass(contentsOf: try Manager(name: fullName, address: address, dateOfBirth: dateOfBirth, socialSecurityNumber: socialSecurityNumber, type: .general))
        }
        
        pass.delegate = Greeter()
        pass.swipe()
        
        if let date = pass.lastTimeSwiped {
            pass.lastTimeSwiped = date.addingTimeInterval(3)
            XCTAssertFalse(pass.lastTimeSwiped! == date.addingTimeInterval(3))
        }
    }
    
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

// MARK: - Helpers

class TestDateFormatter: DateFormatter {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        dateFormat = "dd LLLL"
    }
    
}

class Greeter: PassDelegate {
    let formatter = TestDateFormatter()
    
    func didSwipeWhenAccessGranted(_ pass: Pass) {
        if let date = pass.visitor.dateOfBirth, formatter.string(from: Date()) == formatter.string(from: date) {
            print("\nHappy Birthday!")
        }
    }
    
    func didSwipeWhenAccessDenied(_ pass: Pass) {
        print("Please wait for 5 seconds.")
    }
    
}
