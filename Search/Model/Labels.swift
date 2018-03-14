//
//  Labels.swift
//  MyApp
//
//  Created by SolaMacMini4 on 13/3/18.
//  Copyright © 2018 yonathan. All rights reserved.
//

import Foundation
import ObjectMapper

class Labels : Mappable {
    
    var title : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
    }
}
