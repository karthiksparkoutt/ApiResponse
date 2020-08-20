//
//  UploadPhoto.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 17/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import UIKit
import SwiftyJSON

class RsponseType {
    
    var media_type: String = ""
      var image_name: String = ""
      var url: String = ""
      var jsonObj: JSON!
      
      init(jObj: JSON) {
          media_type = jObj["media_type"].stringValue
          image_name = jObj["image_name"].stringValue
          url = jObj["url"].stringValue
          jsonObj = jObj
      }
    
   
}
class ImageResponse {

var body: RsponseType


var jsonObj: JSON!

init(jObj: JSON) {
    
    body = RsponseType.init(jObj: jObj["body"])
    
    jsonObj = jObj
    
}
}
