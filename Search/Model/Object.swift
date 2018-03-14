//
//  Object.swift
//  SumoBooking
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 Yonathan. All rights reserved.
//

import Foundation
import ObjectMapper

class Object: Mappable {
    var data: [Data]?
    var status: Status?
    
    required init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
    }
}

