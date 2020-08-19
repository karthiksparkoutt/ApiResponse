//
//  DataModel.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 13/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModel {
    
    var dataList: Category

    
    var jsonObj: JSON!
    
    init(jObj: JSON) {
        
        dataList = Category.init(jObj: jObj["data"])
        
        jsonObj = jObj
        
    }
}
