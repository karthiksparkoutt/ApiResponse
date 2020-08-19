//
//  ImageViewController.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 18/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    var url = ""
    
    fileprivate func configuration() {
        print(url)
        // Do any additional setup after loading the view.
        // Create URL
        let fileUrl = URL(string: url)
        viewImage.load(url: fileUrl!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - ImageView
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
