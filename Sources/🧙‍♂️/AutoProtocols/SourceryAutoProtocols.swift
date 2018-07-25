//
//  AutoMockable.swift
//  VRTNieuws
//
//  Created by Stijn on 15/03/2018.
//  Copyright © 2018 VRT. All rights reserved.
//

import Foundation

//: # Implementing these protocols will generate code in files named `<Protocol>.generated.swift`

/*: Generate code with 🧙‍♂️
 
 // ## Mocks
 
 /Applications/Sourcery.app/Contents/MacOS/Sourcery\
    --templates ./🤖sources/builder/Sources/🧙‍♂️/Mocks\
    --output ./🤖sources/builder/Sources/🧙‍♂️/Mocks\
    --sources ./🤖sources/builder\
 
 // to edit template
 
 atom .🤖sources/builder/🧙‍♂️/Mocks/AutoMockable.stencil
 
 
 // ## Protocols
 
 /Applications/Sourcery.app/Contents/MacOS/Sourcery\
     --templates ./🤖sources/builder/Sources/🧙‍♂️/AutoProtocols\
     --output ./🤖sources/builder/Sources/🧙‍♂️/AutoProtocols\
     --sources ./🤖sources/builder\

 // to edit template
 
 atom .🤖sources/builder/🧙‍♂️/AutoProtocols/AutoGenerateProtocol.stencil
 
 :*/

//: To be able to create a mock via sourcery
//: usage: Extend any protocol with this and a mock will be created
public protocol AutoMockable {
}

public protocol AutoGenerateProtocol {
}

public protocol AutoGenerateSelectiveProtocol {
}

public protocol AutoEquatable {
}

// MARK: Enums

public protocol AutoCases {
}

