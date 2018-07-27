import XCTest
@testable import HighwayCore
import Arguments

final class HighwaysTests: XCTestCase {
    private var highway = _Highway(MockHighway.self)
    
    override func setUp() {
        super.setUp()
        highway = _Highway(MockHighway.self)
    }
    
    private func _useDefaultHighways() {
        highway[.build] ==> { "build" }
        highway[.test] ==> { "test" }
    }
    func testListHighwaysAsJSON() {
        _useDefaultHighways()
        highway.go("listPublicHighwaysAsJSON")
    }
    
    func testThatArgumentsAreReceivedCorrectly() {
        let inputArgs: Arguments = ["1", "2", "3"]
        _useDefaultHighways()
        let unrecognizedCalled = expectation(description: "onUnrecognizedCommand called")
        highway.onUnrecognizedCommand = { args in
            XCTAssertEqual(["does not exist"] + inputArgs, args)
            unrecognizedCalled.fulfill()
        }
        
        highway.go(Invocation(highway: "does not exist", arguments: ["does not exist"] + inputArgs))
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testDependenciesGetCorrectInvocation() {
        let releaseExecuted = expectation(description: "release executed")
        let testExecuted = expectation(description: "test executed")
        let buildExecuted = expectation(description: "build executed")

        func _release(invocation: Invocation) throws {
            releaseExecuted.fulfill()
            XCTAssertEqual(invocation.highway, "release")
        }
        func _test(invocation: Invocation) throws {
            testExecuted.fulfill()
            XCTAssertEqual(invocation.highway, "test")
        }
        func _build() throws {
            buildExecuted.fulfill()
        }
        highway[.release].depends(on: .test) ==> _release
        highway[.test].depends(on: .build) ==> _test
        highway[.build] ==> _build
        
        let invocation = Invocation(highway: "release", arguments: ["hello", "world"], verbose: false)
        highway.go(invocation)
        
        waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
        }
    }
    
    func testAbortIfDependencyFails() {
        let cleanExecuted = expectation(description: "clean executed")
        let testExecuted = expectation(description: "test executed")
        
        highway[.build].depends(on: .build) ==> {  return "" }
        highway[.build] ==> { XCTFail("should never be executed"); return }
        highway[.test] ==> { testExecuted.fulfill(); throw "test error" }
        highway[.clean] ==>  { cleanExecuted.fulfill() }
        highway[.release].depends(on: .clean, .test, .build) ==> { XCTFail("should never be executed") }
        highway.go("release")
        
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
    }
    
    func testSimplePositiveCase() {
        _useDefaultHighways()
        
        do {
            // Tests
            highway.go("build")
            let buildResult: String = try highway.result(for: .build)
            XCTAssertEqual(buildResult, "build")
            highway.go("test")
            let testResult: String = try highway.result(for: .test)
            XCTAssertEqual(testResult, "test")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEmptyThrows() {
        highway.go("anything_should_throw")
        XCTAssertThrowsError(try highway.result(for: .build) as String)
    }
    func testDirectDependenciesAreCalled() {
        let buildCalled = expectation(description: "build called")
        let testCalled = expectation(description: "test called")
        var testPerformed = false
        
        func _build() throws -> String {
            XCTAssertTrue(testPerformed)
            let result: String = try self.highway.result(for: .test)
            XCTAssertEqual(result, "test")
            buildCalled.fulfill()
            buildCalled.assertForOverFulfill = true
            return "build"
        }
        func _test() throws -> String {
            XCTAssertFalse(testPerformed)
            testPerformed = true
            testCalled.fulfill()
            testCalled.assertForOverFulfill = true
            return "test"
        }
        
        highway[.build].depends(on: .test) ==> _build
        highway[.test] ==> _test
        
        
        highway.go("build")
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    func testErrorHandlerIsCalledWhenHighwayThrows() {
        let ctx = Invocation(highway: MockHighway.build.name)
        let onErrorExpectation = expectation(description: "Error handler is called.")
        let expectedError = "ich bin der ich bin ich"
        highway[.build] ==> { throw expectedError }
        highway.onError = { error in
            XCTAssertTrue(error is String)
            guard let coreError = error as? String else {
                XCTFail()
                return
            }
            XCTAssertTrue(coreError == expectedError)
            onErrorExpectation.fulfill()
        }
        highway.go(ctx)
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testErrorHandlerIsCalledWhenHighwayNotFound() {
        _useDefaultHighways()
        
        let onErrorExpectation = expectation(description: "Error handler is called.")
        
        highway.onError = { _ in
            onErrorExpectation.fulfill()
        }
        highway.go("highway_which_does_not_exist")
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    func testEmptyHandler() {
        _useDefaultHighways()
        
        let expectation = self.expectation(description: "onEmptyCommand handler is called.")
        highway.onEmptyCommand = {
            expectation.fulfill()
        }
        
        highway.go(Invocation())
        waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
        }
    }
    func testThrowingEmptyHandler() {
        _useDefaultHighways()
        
        let errorExpectation = self.expectation(description: "onEmptyCommand handler is called.")
        highway.onError = { error in
            errorExpectation.fulfill()
        }
        
        let emptyExpectation = self.expectation(description: "onEmptyCommand handler is called.")
        highway.onEmptyCommand = {
            emptyExpectation.fulfill()
            throw "Hello Dude"
        }
        
        highway.go(Invocation())
        waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
        }
    }
    
    // Test that first onUnrecognizedCommand is consulted and then the error handler
    func testErrorHandlerIsNotCalledWhenHighwayNotFoundButUnrecgonizedHighwaysAreHandled() {
        _useDefaultHighways()
        
        let expectation = self.expectation(description: "onUnrecognizedCommand handler is called.")
        
        highway.onError = { _ in XCTFail("should not be called") }
        highway.onUnrecognizedCommand = { _ in expectation.fulfill() }
        highway.go("highway_which_does_not_exist")
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testCommandLineInvocationProvider() {
        let verboseBuild = CommandLineInvocationProvider(args: ["xyz", "--verbose", "build"]).invocation()
        XCTAssertEqual(verboseBuild.highway, "build")
        XCTAssertEqual(verboseBuild.verbose, true)
        XCTAssertEqual(verboseBuild.arguments, [])
        
        let buildWithArgs = CommandLineInvocationProvider(args: ["xyz", "build", "hello", "world"]).invocation()
        XCTAssertEqual(buildWithArgs.highway, "build")
        XCTAssertEqual(buildWithArgs.verbose, false)
        XCTAssertEqual(buildWithArgs.arguments, ["hello", "world"])
    }
}



// MARK: Helper & Mocks
extension String: InvocationProvider {
    public func invocation() -> Invocation {
        return Invocation(highway: self)
    }
}

extension Invocation: InvocationProvider {
    public func invocation() -> Invocation {
        return self
    }
}

enum MockHighway: String, HighwayTypeProtocol {
    case build, test, clean, release
}
