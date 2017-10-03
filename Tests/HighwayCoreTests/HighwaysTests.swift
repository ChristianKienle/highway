import XCTest
@testable import HighwayCore

final class HighwaysTests: XCTestCase {
    private var highways = Highways(MockHighway.self)
    
    override func setUp() {
        super.setUp()
        highways = Highways(MockHighway.self)
    }
    
    private func _useDefaultHighways() {
        highways
            .highwayWithResult(.build) { "build" }
            .highwayWithResult(.test) { "test" }
            .done()
    }
    func testListHighwaysAsJSON() {
        _useDefaultHighways()
        highways.go("listPublicHighwaysAsJSON")
    }
    
    func testThatArgumentsAreReceivedCorrectly() {
        let inputArgs = ["1", "2", "3"]
        _useDefaultHighways()
        let unrecognizedCalled = expectation(description: "onUnrecognizedCommand called")
        highways.onUnrecognizedCommand { args in
            XCTAssertEqual(["does not exist"] + inputArgs, args)
            unrecognizedCalled.fulfill()
        }
        .go(Invocation(highwayName: "does not exist", arguments: Arguments(all: ["does not exist"] + inputArgs)))
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testAbortIfDependencyFails() {
        let cleanExecuted = expectation(description: "clean executed")
        let testExecuted = expectation(description: "test executed")
        
        highways
            .highway(.build) {
                XCTFail("should never be executed")
                
            }
            .highway(.test) {
                testExecuted.fulfill(); throw "test error"
            }
            .highway(.clean) {
                cleanExecuted.fulfill()
            }
            .highway(.release, dependsOn: [.clean, .test, .build]) {
                XCTFail("should never be executed")
            }
            .done()
        highways.go("release")
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
        
    }
    
    func testSimplePositiveCase() {
        _useDefaultHighways()

        do {
            // Tests
            highways.go("build")
            let buildResult: String = try highways.result(for: .build)
            XCTAssertEqual(buildResult, "build")
            highways.go("test")
            let testResult: String = try highways.result(for: .test)
            XCTAssertEqual(testResult, "test")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEmptyThrows() {
        highways.go("anything_should_throw")
        XCTAssertThrowsError(try highways.result(for: .build) as String)
    }
    func testDirectDependenciesAreCalled() {
        let buildCalled = expectation(description: "build called")
        let testCalled = expectation(description: "test called")
        var testPerformed = false
        
        highways
            .highwayWithResult(.build, dependsOn: [.test]) {
                XCTAssertTrue(testPerformed)
                let result: String = try self.highways.result(for: .test)
                XCTAssertEqual(result, "test")
                buildCalled.fulfill()
                buildCalled.assertForOverFulfill = true
                return "build"
            }
            .highwayWithResult(.test) {
                XCTAssertFalse(testPerformed)
                testPerformed = true
                testCalled.fulfill()
                testCalled.assertForOverFulfill = true
                return "test"
            }
            .go("build")
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    func testErrorHandlerIsCalledWhenHighwayThrows() {
        let ctx = Invocation(highwayName: MockHighway.build.highwayName)
        let onErrorExpectation = expectation(description: "Error handler is called.")
        let expectedError = "ich bin der ich bin ich"
        highways
            .highway(.build) {
                throw expectedError
            }.onError { error in
                XCTAssertTrue(error is String)
                guard let coreError = error as? String else {
                    XCTFail()
                    return
                }
                XCTAssertTrue(coreError == expectedError)
                onErrorExpectation.fulfill()
            }
            .go(ctx)
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testErrorHandlerIsCalledWhenHighwayNotFound() {
        _useDefaultHighways()
        
        let onErrorExpectation = expectation(description: "Error handler is called.")
        highways
            .onError { _ in
                onErrorExpectation.fulfill()
            }
            .go("highway_which_does_not_exist")
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    // Test that first onUnrecognizedCommand is consulted and then the error handler
    func testErrorHandlerIsNotCalledWhenHighwayNotFoundButUnrecgonizedHighwaysAreHandled() {
        _useDefaultHighways()

        let expectation = self.expectation(description: "onUnrecognizedCommand handler is called.")
        
        highways
            .onError { _ in XCTFail("should not be called") }
            .onUnrecognizedCommand { _ in expectation.fulfill() }
            .go("highway_which_does_not_exist")
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
}



// MARK: Helper & Mocks
extension String: HighwayInvocationProvider {
    public func highwayInvocation() -> Invocation {
        return Invocation(highwayName: self)
    }
}

extension Invocation: HighwayInvocationProvider {
    public func highwayInvocation() -> Invocation {
        return self
    }
}

enum MockHighway: String, Highway {
    case build, test, clean, release
}
