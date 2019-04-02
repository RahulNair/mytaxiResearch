//
//  MTError.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import Foundation


public enum MTErrorType {
    case databaseError
    case networkError
    case parsingError
    case unknownError
}

public struct MTError: Error {
    public var code: Int
    public var errorType: MTErrorType
    public var description: String
    
    init(code: Int, errorType: MTErrorType, description: String) {
        self.code = code
        self.errorType = errorType
        self.description = description
    }
}
