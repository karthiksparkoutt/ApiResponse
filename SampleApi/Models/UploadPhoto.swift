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
    var url: String = ""
    var jsonObj: JSON!
    
    init(jObj: JSON) {
        
        url = jObj["url"].stringValue
        
        jsonObj = jObj
    }
    
    
}
