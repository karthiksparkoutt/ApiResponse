//
//  ViewController.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 13/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var dataList: UITableView!
    
    var Categoryy: [DataModel] = []
    
    var Data: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList.delegate = self
        dataList.dataSource = self
        callMyPropertiesService()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
    }
    
    func callMyPropertiesService(){
        
        ViewController.getMyProperties { json, error in
            if error != nil {
                print(" error")
                print(error!.localizedDescription)
            }else{
                
                if let json = json {
                    
                    debugPrint("json response \(json)")
                    
                    let status = json["status"].stringValue
                    if(status == "1" || status == "true"){
                        print(json)
                        let data = json["data"].arrayValue
                        for dataObj: JSON in data {
                            self.Categoryy.append(DataModel.init(jObj: dataObj))
                        }
                        
                        self.dataList.reloadData()
                    }
                        
                    else{
                        print(json)
                        if let error_Code = json["error_code"].int {
                            if error_Code == 104 {
                            }
                            else {
                                if let msg : String = json["error_messages"].rawString() {
                                }
                            }
                        }
                    }
                    
                }else {
                    debugPrint("invalid")
                }
            }
        }
        
    }
    
    class func getMyProperties(completionHandler: @escaping (JSON?, Error?) -> ()){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded", "authid": "2", "authToken": "964T1IHOZAB0SDFAFUQPRN2CVK5Y9W"]
        let parameters:[String:String] = [:]
        print(headers)
        manager.request("http://dummy.restapiexample.com/api/v1/employee/1", method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completionHandler(nil,error as NSError)
                }
                completionHandler(nil, error)
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categoryy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! DataCell
        let dataa =  self.Categoryy[indexPath.row].dataList
        print(dataa.employee_name)
        cell.listLbl.text = dataa.employee_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

