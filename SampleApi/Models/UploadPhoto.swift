//
//  UploadPhoto.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 17/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadPhoto {
    var image: String = ""
    var jsonObj: JSON!
    
    init(jObj: JSON) {
        image = jObj["image"].stringValue
        
        jsonObj = jObj
    }
    
    
}
