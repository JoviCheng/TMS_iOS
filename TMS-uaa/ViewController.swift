//
//  ViewController.swift
//  TMS-uaa
//
//  Created by JoviCheng on 2018/12/7.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import UIKit
import Alamofire
//import ViewAnimator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let parameters = ["stuNum":"1601050009","password":"cheng970905"]
        let urlString = URL.init(string: "http://localhost:6226/tms")
        
        AF.request("http://localhost:6226/tms",method: .post, parameters: parameters).responseJSON { response in
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
        }
    }


}

