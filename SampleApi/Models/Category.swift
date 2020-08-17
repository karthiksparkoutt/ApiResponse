//
//  VehicleCategory.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 13/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import UIKit
import SwiftyJSON

class Category {
    
    var id: String = ""
    var employee_name: String = ""
    var employee_salary: String = ""
    var employee_age: String = ""
    var profile_image: String = ""

    var jsonObj: JSON!
    
    init(jObj: JSON) {
        id = jObj["id"].stringValue
        employee_name = jObj["employee_name"].stringValue
        employee_salary = jObj["employee_salary"].stringValue
        employee_age = jObj["employee_age"].stringValue
        profile_image = jObj["profile_image"].stringValue
    
        jsonObj = jObj
        
    }
    
}
