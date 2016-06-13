//
//  Item.swift
//  Hello World
//
//  Created by Philibert Dugas on 2016-06-12.
//  Copyright © 2016 Philibert Dugas. All rights reserved.
//

import Foundation
import CoreLocation

class Item {
    
    let name: String
    let uuid: NSUUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    
    init(name: String, uuid: NSUUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue){
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
}
