//
//  AppConstants.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import Foundation

struct AppConstants {
    
    
    static let     hostURL                      = "https://poi-api.mytaxi.com/PoiService/poi/v1"
    
    
    struct Error {
        static let kNoNetwork                   = "Network not available"
        static let kNoDataFound                 = "No data found"
        static let kInvalidUrl                  = "Invalid URL"
        static let kJsonHeader                  = "Json error in header"
        static let kIncompleteDBOperation       = "Operation could not be completed"
    }
    struct Query {
        static let kGet                         = "GET"
        static let kPost                        = "POST"
        static let kDelete                      = "DELETE"
        static let kPut                         = "PUT"
        static let kContentType                 = "Content-Type"
        static let kContentTypeJson             = "application/json"
        static let kApplicationApiKey           = "application_api_key"
        static let kAscending                   = "&asc=%@"
        static let kDescending                  = "&desc=%@"
    }
}
