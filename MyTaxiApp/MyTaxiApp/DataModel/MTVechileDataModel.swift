//
//  MTVechileDataModel.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import Foundation

struct Root : Codable {
    let poiList : [MTVechileDataModel]
    
    
    
}

struct MTVechileDataModel : Codable {
    
    let id : Int
    let state : String
    let vh_type : String
    let heading : Float64
    let coordinate : VHCoordinate
    
    
    enum CodingKeys: String, CodingKey
    {
        case vh_type = "type"
        case id
        case state
        case heading
        case coordinate = "coordinate"
    }
    
    struct VHCoordinate : Codable {
        let latitude : Float64
        let longitude : Float64
       
        enum CodingKeys: String, CodingKey
        {
            case latitude
            case longitude
            
        }
    }
    
    
}
