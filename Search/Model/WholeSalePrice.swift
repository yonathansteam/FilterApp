//
//  WholeSalePrice.swift
//  MyApp
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 yonathan. All rights reserved.
//

import Foundation
import ObjectMapper

class WholeSalePrice: Mappable{
    
    var countMin : Int?
    var countMax : Int?
    var price : String?
    
    required init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        countMin <- map["count_min"]
        countMax <- map["count_max"]
        price    <- map["price"]
    }
    
}


