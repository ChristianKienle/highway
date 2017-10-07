import Foundation
import Arguments
import Errors

// highway init
// highway init --type swift
// highway init --type swift --create-project
// highway init --type xcode

public struct InitOptions {
    public enum ProjectType: String, RawRepresentable {
        case swift, xcode
    }
    
    public init(_ arguments: Arguments) throws {
        let all = arguments.all
        guard all.isEmpty == false else {
            self.init(projectType: .swift, shouldCreateProject: false)
            return
        }
        // We need at least two more options
        guard all.count >= 2 else {
            throw "Unknown configuration."
        }
        // First argument must be --type
        guard all.first == "--type" else {
            throw "Unknown configuration."
        }
        guard let projectType = ProjectType(rawValue: all[1]) else {
            throw "Unknown project type."
        }
        
        let shouldCreateProject = all.contains("--create-project")
        // creating xcode projects is not supported
        if projectType == .xcode && shouldCreateProject {
            throw "Creation of Xcode projects is not supported yet."
        }
        
        self.init(projectType: projectType, shouldCreateProject: shouldCreateProject)
    }
    
    public init(projectType: ProjectType, shouldCreateProject: Bool) {
        self.projectType = projectType
        self.shouldCreateProject = shouldCreateProject
    }
    
    // MARK: - Properties
    public var projectType: ProjectType = .xcode
    public var shouldCreateProject: Bool = false
}

extension InitOptions: Equatable {
    public static func ==(lhs: InitOptions, rhs: InitOptions) -> Bool {
        return
            lhs.projectType == rhs.projectType &&
            lhs.shouldCreateProject == rhs.shouldCreateProject
    }
}
