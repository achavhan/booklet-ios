//
//  ViewController.swift
//  Booklets
//
//  Created by Steven Enamakel on 07/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Alamofire.request(
            .GET, "http://52.27.197.48/api/v1/book/",
            parameters: nil,
            encoding: .JSON,
            headers: [
                "Authorization" : "Basic Og=="
            ])
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
//                    var books = JSON["objects"]
                 
                    print("hello \(JSON["meta"])")
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

