//
//  Status.swift
//  SumoBooking
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 Yonathan. All rights reserved.
//

import Foundation
import ObjectMapper

class Status: Mappable {
    
    var errorCode: Int?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        errorCode <- map["error_code"]
        message <- map["message"]
    }
    
}

