import Foundation

/// Credits for documentation: man xcodebuild

public struct ExportOptions: Codable {
    public init() {}
    // Key: compileBitcode
    // For non-App Store exports, should Xcode re-compile the app from bitcode?
    // True if not set.
    public var compileBitcode: Bool?
    
    // Key: embedOnDemandResourcesAssetPacksInBundle
    // For non-App Store exports, if the app uses On Demand Resources and this is YES, asset packs are embedded in the app bundle so that the app can be tested without a server to host asset packs. Defaults to YES unless onDemandResourcesAssetPacksBaseURL is specified.
    public var embedOnDemandResourcesAssetPacksInBundle: Bool?
    
    // If the app is using CloudKit, this configures the "com.apple.developer.icloud-container-environment" entitlement. Available options vary depending on the type of provisioning profile used, but may include: Development and Production.
    public var iCloudContainerEnvironment: String?
    
    // For manual signing only. Provide a certificate name, SHA-1 hash, or automatic selector to use for signing. Automatic selectors allow Xcode to pick the newest installed certificate of a particular type. The available automatic selectors are "Mac Installer Distribution" and "Developer ID Installer". Defaults to an automatic certificate selector matching the current distribution method.
    public var installerSigningCertificate: String?
    
    // For non-App Store exports, users can download your app over the web by opening your distribution manifest file in a web browser. To generate a distribution manifest, the value of this key should be a dictionary with three sub-keys: appURL, displayImageURL, fullSizeImageURL. The additional sub-key assetPackManifestURL is required when using on-demand resources.
    public var manifest: [String: String]?
    
    public enum Method: String, Codable {
        case appStore = "app-store"
        case package = "package"
        case adhoc = "ad-hoc"
        case enterprise = "enterprise"
        case development = "development"
        case developerId = "developer-id"
        case macApplication = "mac-application"
    }
    // Describes how Xcode should export the archive. Available options: app-store, package, ad-hoc, enterprise, development, developer-id, and mac-application. The list of options varies based on the type of archive. Defaults to development.
    public var method: Method = .development
    
    // For non-App Store exports, if the app uses On Demand Resources and embedOnDemandResourcesAssetPacksInBundle isn't YES, this should be a base URL specifying where asset packs are going to be hosted. This configures the app to download asset packs from the specified URL.
    public var onDemandResourcesAssetPacksBaseURL: String?
    
    // For manual signing only. Specify the provisioning profile to use for each executable in your app. Keys in this dictionary are the bundle identifiers of executables; values are the provisioning profile name or UUID to use.
    public struct ProvisioningProfiles: Codable {
        public init() {
            
        }
        public enum Profile {
            public typealias UUIDString = String
            case named(String)
            case identifiedBy(UUIDString)
            var value: String {
                switch self {
                case .named(let name):
                    return name
                case .identifiedBy(let uuid):
                    return uuid
                }
            }
        }
        public mutating func addProfile(_ profile: Profile, forBundleIdentifier bundleIdentifier: String) {
            _profiles[bundleIdentifier] = profile.value
        }
        
        private var _profiles = [String:String]()
        public init(from decoder: Decoder) throws {
            _profiles = try Dictionary<String, String>(from: decoder)
        }
        public func encode(to encoder: Encoder) throws {
            try _profiles.encode(to: encoder)
        }
    }
    public var provisioningProfiles: ProvisioningProfiles?
    
    // For manual signing only. Provide a certificate name, SHA-1 hash, or automatic selector to use for signing. Automatic selectors allow Xcode to pick the newest installed certificate of a particular type. The available automatic selectors are "Mac App Distribution", "iOS Distribution", "iOS Developer", "Developer ID Application", and "Mac Developer". Defaults to an automatic certificate selector matching the current distribution method.
    public var signingCertificate: String?
    
    // The signing style to use when re-signing the app for distribution. Options are manual or automatic. Apps that were automatically signed when archived can be signed manually or automatically during distribution, and default to automatic. Apps that were manually signed when archived must be manually signed during distribtion, so the value of signingStyle is ignored.
    public enum SigningStyle: String, Codable {
        case manual, automatic
    }
    public var signingStyle: SigningStyle?
    
    // Should symbols be stripped from Swift libraries in your IPA? Defaults to YES.
    public var stripSwiftSymbols: Bool?
    
    // The Developer Portal team to use for this export. Defaults to the team used to build the archive.
    public var teamID : String?
    
    //For non-App Store exports, should Xcode thin the package for one or more device variants? Available options: <none> (Xcode produces a non-thinned universal app), <thin-for-all-variants> (Xcode produces a universal app and all available thinned variants), or a model identifier for a specific device (e.g. "iPhone7,1"). Defaults to <none>.
    public enum Thinning: RawRepresentable, Codable {
        case none
        case all
        case device(modelIdentifier: String)
        public init?(rawValue: String) {
            switch rawValue {
            case "<none>": self = .none
            case "<thin-for-all-variants>": self = .all
            default: self = .device(modelIdentifier: rawValue)
            }
        }
        public var rawValue: String {
            switch self {
            case .none:
                return "<none>"
            case .all:
                return "<thin-for-all-variants>"
            case .device(let modelIdentifier):
                return modelIdentifier
            }
        }
    }
    public var thinning: Thinning?
    
    // For App Store exports, should the package include bitcode? Defaults to YES.
    public var uploadBitcode: Bool?
    
    // For App Store exports, should the package include symbols? Defaults to YES.
    public var uploadSymbols: Bool?
}
