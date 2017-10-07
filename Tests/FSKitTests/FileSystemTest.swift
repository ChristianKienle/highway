import XCTest
import FileSystem

func _assert<T, ErrorType>(_ expression: @autoclosure () throws -> T, throwsErrorOfType: ErrorType.Type, file: StaticString = #file, line: UInt = #line, _ errorHandler: (ErrorType) -> Void) {
    XCTAssertThrowsError(expression, "", file: file, line: line) { anyError in
        guard let error = anyError as? ErrorType else {
            XCTFail("Caught error has incorrect type. Got '\(type(of: anyError))', expected: \(ErrorType.self)", file: file, line: line)
            return
        }
        errorHandler(error)
    }
}

func _assertThrowsFileSystemError<T>(_ expression: @autoclosure () throws -> T, file: StaticString = #file, line: UInt = #line, _ errorHandler: (FSError) -> Void) {
    _assert(expression, throwsErrorOfType: FSError.self, errorHandler)
}
