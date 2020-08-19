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
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var dataList: UITableView!
    
    var category: [DataModel] = []
    var url: [UploadPhoto] = []
    
    var chooseImage = UIImage()
    var picker = UIImagePickerController()
    
    fileprivate func configuration() {
        picker.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    // MARK: - Upload Button Action
    @IBAction func uploadButton(_ sender: Any) {
        if chooseImage != nil {
            imageUpload(picture: chooseImage) { (sucess, value, error) in
                if sucess == true {
                    print("upload sucess")
                    // MARK: - NavigationController
                    let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let viewcontroller: ImageViewController = sb.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                    viewcontroller.url = value
                    let navController = UINavigationController(rootViewController: viewcontroller)
                    self.present(navController, animated: true, completion: nil)
                }
                else {
                    print(value)
                }
            }
        }
    }
    // MARK: - camera Action
    @IBAction func cameraAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let optionMenu = UIAlertController(title: nil, message: "Add Photo!", preferredStyle: .actionSheet)
        
        let PhotoLibrary = UIAlertAction(title: "Gallery", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            self.photoLibraryAction()
        })
        let Camera = UIAlertAction(title: "Take Photo", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.cameraAction()
            
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(Cancel)
        optionMenu.addAction(PhotoLibrary)
        optionMenu.addAction(Camera)
        let popover = optionMenu.popoverPresentationController
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
        self.present(optionMenu, animated: true, completion: nil)
    }
    func photoLibraryAction() {
        let photos = PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                    DispatchQueue.main.async {
                        self.picker.allowsEditing = false
                        self.picker.sourceType = .photoLibrary
                        self.present(self.picker, animated: true, completion: nil)
                    }
                }
            } else if photos == .notDetermined  || photos == .denied {
                let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
                let alert = UIAlertController(title: "\(appName) Would Like to Access the Photo Library", message: "Access to photo library lets you choose profile pic from your existing library.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        })
    }
    func cameraAction() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
            if granted == true
            {
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    DispatchQueue.main.async {
                        self.picker.allowsEditing = false
                        self.picker.sourceType = .camera
                        self.present(self.picker, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
                let alert = UIAlertController(title: "\(appName) Would Like to Access the Camera", message: "We need to access your camera to lets you take a new profile picture", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
    }
    // MARK: - CallMyService
    func callMyPropertiesService(){
        self.getMyProperties { json, error in
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
                            self.category.append(DataModel.init(jObj: dataObj))
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
    
    func getMyProperties(completionHandler: @escaping (JSON?, Error?) -> ()){
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
    func imageUpload(picture: UIImage, completionHandler: @escaping ((Bool?,String,Error?)->())) {
        self.uploadWithImage(picture: picture){ (json, value, error)  in
            if(error == nil) {
                let val:Bool = (json!)
                if val {
                    completionHandler( true, "\(value!)", nil)
                } else {
                    let message = "Unknown Error"
                    if json != nil {
                        completionHandler(false,value!,nil)
                    }
                    let loginError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : message])
                    completionHandler(false,value!,loginError )
                }
            } else {
                completionHandler(false, "Error", error)
            }
        }
    }
    func uploadWithImage(picture:UIImage,completionHandler: @escaping (Bool?, String?, Error?) -> ()){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        let headers = ["Content-Type": "multipart/form-data"]
        var imgData:Data =  Data()
        if(picture.size != CGSize(width: 0, height: 0))
        {
            imgData = picture.jpegData(compressionQuality: 0.2)!
        }
        print(imgData)
        manager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "media",fileName: "file1.jpg", mimeType: "image/jpg")
        },
                       to:"http://167.71.251.189:8000/api/v1/upload",
                       headers:headers )
        { (result) in
            switch result {
            case .success(let upload, _,_ ):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    debugPrint(response.result.value!)
                    let respValue = ((response.result.value!) as! AnyObject)
                    if let success = respValue.value(forKey: "message")
                    {
                        if("\(success)" == "File uploaded successfully") {
                            if let body = respValue.value(forKey: "body") as? [String:Any] {
                                let url = body["url"] as! String
                                completionHandler(true,"\(url)",nil)
                            }
                        }
                        else
                        {
                            completionHandler(false,"\(respValue.value(forKey: "message")!)",nil)
                        }
                    }
                    else
                    {
                        completionHandler(false,"\(respValue.value(forKey: "message")!)",nil)
                    }
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completionHandler(false,"Error", error as NSError)
                }
                print(error)
                completionHandler(false,"Error", error as NSError)
                
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! DataCell
        let dataa =  self.category[indexPath.row].dataList
        print(dataa.employee_name)
        cell.listLbl.text = dataa.employee_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let chosenImage = info[.originalImage] as? UIImage else { return }
        uploadImage.image = chosenImage
        chooseImage = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


