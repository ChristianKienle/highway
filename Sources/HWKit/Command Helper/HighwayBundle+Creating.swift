import Foundation
import HighwayCore
import ZFile
import Url

public extension HighwayBundle {
    public convenience init(creatingInParent parentUrl: FolderProtocol,
                            fileSystem: FileSystemProtocol,
                            configuration config: Configuration = .standard,
                            homeConfig: HomeBundle.Configuration
    ) throws {
        let url = try parentUrl.subfolder(named: config.directoryName)
        
        try self.init(url: url, fileSystem: fileSystem, configuration: config)
        
        let dependencyUrl = homeConfig.remoteRepositoryUrl
        let branch = config.branch
        let packageName = config.packageName
        let targetName = config.targetName
        let contents = packageDescriptionTemplate(packageName: packageName,
                                                  targetName: targetName,
                                                  branch: branch,
                                                  dependencyUrl: dependencyUrl
        )
        
        try package().write(data: contents.utf8Data())
        
        try xcconfigFile().write(data: xcconfigTemplate.utf8Data())
        
        try gitignore().write(data: gitignoreTemplate.utf8Data())
        
        try mainSwiftFile().write(data: mainSwiftSubtypeXcodeTemplate.utf8Data())
    }
}

extension String {
    
    func utf8Data() throws -> Data {
       
        guard let data = self.data(using: .utf8) else { throw "Could not create data from \(self)" }
        
        return data
    }
    
}
