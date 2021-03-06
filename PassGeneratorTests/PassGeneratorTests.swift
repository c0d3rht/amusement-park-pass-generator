import XCTest
@testable import PassGenerator

class PassGeneratorTests: XCTestCase {
    
    var fullName: Name!
    var address: Address!
    var socialSecurityNumber: String!
    
    var defaultDOB: Date!
    var childDOB: Date!
    var seniorDOB: Date!
    var dateOfVisit: Date!
    
    var pass: Pass!
    var dateFormatter: TestDateFormatter!
    
    override func setUp() {
        super.setUp()
        
        fullName = Name("John", "Doe")
        address = Address(street: "1 Infinite Loop", city: "Cupertino", state: "California", zipCode: "95014")
        socialSecurityNumber = " 123    45     -   6789   "
        
        defaultDOB = Date(timeIntervalSince1970: 956620800)
        childDOB = Date(timeIntervalSinceNow: 157784630)
        seniorDOB = Date(timeIntervalSince1970: -8985600)
        dateOfVisit = Date()
        
        dateFormatter = TestDateFormatter()
    }
    
    override func tearDown() {
        super.tearDown()
        
        fullName = nil
        address = nil
        socialSecurityNumber = nil
        
        defaultDOB = nil
        childDOB = nil
        seniorDOB = nil
        dateOfVisit = nil
        
        pass = nil
        dateFormatter = nil
    }
    
    // MARK: - Tests on Guest Types
    
    func testClassicGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .classic))
        }

        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))

        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))

        XCTAssertFalse(pass.discount.isAvailable())
    }

    func testVIPGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .vip))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertTrue(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    func testChildGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, dateOfBirth: childDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .child))
        }

        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))

        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))

        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testSeasonGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .season))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertTrue(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    func testSeniorGuest() {
        handleErrors {
            pass = Pass(contentsOf: try Guest(name: fullName, dateOfBirth: seniorDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .senior))
        }
        
        let dateComponents = Calendar.current.dateComponents([.year], from: seniorDOB, to: Date())
        XCTAssertGreaterThanOrEqual(dateComponents.year!, 40)
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))

        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertTrue(pass.hasAccess(to: RideAccess.skipQueues))

        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    // MARK: - Tests on Employee Types
    
    func testFoodEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: nil, type: .food))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    func testRideEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: nil, type: .ride))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    func testMaintenanceEmployee() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: nil, type: .maintenance))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertTrue(pass.discount.isAvailable())
    }

    func testContractEmployee1001() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: 1001, type: .contract))
        }

        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))

        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))

        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testContractEmployee1002() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: 1002, type: .contract))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testContractEmployee1003() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: 1003, type: .contract))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testContractEmployee2001() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: 2001, type: .contract))
        }
        
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testContractEmployee2002() {
        handleErrors {
            pass = Pass(contentsOf: try Employee(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, projectNumber: 2002, type: .contract))
        }
        
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }

    // MARK: - Tests on Manager Type(s)

    func testManager() {
        handleErrors {
            pass = Pass(contentsOf: try Manager(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .general))
        }

        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.office))

        XCTAssertTrue(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))

        XCTAssertTrue(pass.discount.isAvailable())
    }
    
    // MARK: - Tests on Vendor Types
    
    func testVendorACME() {
        handleErrors {
            pass = Pass(contentsOf: try Vendor(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, dateOfVisit: dateOfVisit, company: .acme))
        }
        
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testVendorOrkin() {
        handleErrors {
            pass = Pass(contentsOf: try Vendor(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, dateOfVisit: dateOfVisit, company: .orkin))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testVendorFedex() {
        handleErrors {
            pass = Pass(contentsOf: try Vendor(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, dateOfVisit: dateOfVisit, company: .fedex))
        }
        
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertFalse(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }
    
    func testVendorNWElectrical() {
        handleErrors {
            pass = Pass(contentsOf: try Vendor(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, dateOfVisit: dateOfVisit, company: .nwElectrical))
        }
        
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.amusement))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.kitchen))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.rideControl))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.maintenance))
        XCTAssertTrue(pass.hasAccess(to: AccessibleArea.office))
        
        XCTAssertFalse(pass.hasAccess(to: RideAccess.allRides))
        XCTAssertFalse(pass.hasAccess(to: RideAccess.skipQueues))
        
        XCTAssertFalse(pass.discount.isAvailable())
    }

    // MARK: - Tests for Accessibility

    func testSwipeAccess() {
        handleErrors {
            pass = Pass(contentsOf: try Manager(name: fullName, dateOfBirth: defaultDOB, socialSecurityNumber: socialSecurityNumber, address: address, type: .general))
        }
        
        let greeter = Greeter()
        pass.delegate = greeter
        greeter.pass = pass

        pass.swipe(for: AccessibleArea.amusement) // Access Granted

        if let date = pass.lastTimeSwiped {
            pass.lastTimeSwiped = date.addingTimeInterval(3)
            pass.swipe(for: AccessibleArea.amusement) // Processing Time Has Not Elapsed Yet
            
            XCTAssertFalse(pass.lastTimeSwiped! == date.addingTimeInterval(3))
        }
        
    }
    
    // MARK: - Helper Methods
    
    func handleErrors(_ closure: () throws -> Void) {
        do {
            try closure()
        } catch let error as FormError {
            fatalError(error.description)
        } catch {
            fatalError("\(error)")
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

class Greeter: PassDelegate {
    
    var pass: Pass?
    let formatter = TestDateFormatter()
    
    func didSwipeWhenAccessGranted(for type: AccessType) {
        print("\nAccess Granted!")
        
        if let date = pass?.entrant.dateOfBirth, formatter.string(from: Date()) == formatter.string(from: date) {
            print("Happy Birthday!\n")
        }
    }
    
    func didSwipeWhenAccessDenied(for type: AccessType) {
        print("\nAccess Denied!\n")
    }
    
    func didSwipeDuringProcessingTime(seconds: Double) {
        let string = String(format: "\nPlease wait for 1.f seconds.\n", seconds)
        print(string)
    }
    
    func processingTimeDidElapse() {
        print("\nPress an option.\n")
    }
    
}
