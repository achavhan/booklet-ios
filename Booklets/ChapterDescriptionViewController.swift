//
//  ChapterDescriptionViewController.swift
//  Booklets
//
//  Created by Steven Enamakel on 09/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit

class ChapterDescriptionViewController: UIViewController {
    var chapter : Chapter!
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        descriptionTextView.text = chapter.summary as! String
        navigation.title = chapter.title as String
    }
}
