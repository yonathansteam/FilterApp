//
//  Data.swift
//  SumoBooking
//
//  Created by SolaMacMini4 on 12/3/18.
//  Copyright © 2018 Yonathan. All rights reserved.
//

import Foundation
import ObjectMapper

class Data: Mappable {
    
    var name: String?
    var price: String?
    var imageUrl: String?
    var wholeSalePrice: [WholeSalePrice]?
    var badges: [Badges]?
    var labels: [Labels]?
    
    //var intPrice: Int?
    
    required init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        imageUrl <- map["image_uri"]
        wholeSalePrice <- map["wholesale_price"]
        badges <- map["badges"]
        labels <- map["labels"]
    }

}

