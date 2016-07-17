//
//  CustomNaviationController.swift
//  Booklets
//
//  Created by Steven Enamakel on 04/06/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit

class CustomNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        navigationBar.tintColor = UIColor.whiteColor()
    }
}
