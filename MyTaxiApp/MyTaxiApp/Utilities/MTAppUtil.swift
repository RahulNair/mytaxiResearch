//
//  MTAppUtil.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import Foundation

class MTAppUtil {
    
    
    class func getDirectionText(bearingValue:Float64) -> String {
        var direction = ""
        var maj = ""
        var bearing = 0
        let _degree = "º"
        

        
        if bearingValue > 0 && bearingValue < 90{
            maj = "N_E"
            bearing = Int(bearingValue)
        }else if bearingValue > 90 && bearingValue < 180{
            maj = "S_E"
            bearing = Int(180-bearingValue)

        }else if bearingValue > 180 && bearingValue < 270{
            maj = "S_W"
            bearing = Int(bearingValue - 180)

        }else if bearingValue > 270 && bearingValue < 360{
            maj = "N_W"
            bearing = Int(360-bearingValue)

        }else if bearingValue == 0{
            maj = "_N"
            bearing = 0

        }else if bearingValue == 90{
            maj = "_E"
            bearing = 0

        }else if bearingValue == 180{
            maj = "_S"
            bearing = 0

        }else if bearingValue == 270{
            maj = "_W"
            bearing = 0

        }else{
            maj  = "_N"
            bearing = 0

        }
        
        let bearingString =  String(bearing)+_degree
        
        direction  = maj.replacingOccurrences(of: "_", with: bearingString)
        
        return direction
    }
        
        

}
