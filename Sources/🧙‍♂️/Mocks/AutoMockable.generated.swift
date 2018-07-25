// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import os

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import XCBuild















// MARK: - TestOptionsProtocolMock

public class TestOptionsProtocolMock: TestOptionsProtocol {

    public init() {}

    public var scheme: String {
        get { return underlyingScheme }
        set(value) { underlyingScheme = value }
    }
    var underlyingScheme: String = "AutoMockable filled value"
    public var project: String {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: String = "AutoMockable filled value"
    public var destination: Destination {
        get { return underlyingDestination }
        set(value) { underlyingDestination = value }
    }
    var underlyingDestination: Destination!

}

