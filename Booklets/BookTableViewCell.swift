//
//  BookTableViewCell.swift
//  Booklets
//
//  Created by Steven Enamakel on 07/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    var book : Book?
    
    func setMainBook(book : Book) {
        self.book = book
        
        self.labelView.text = book.bookName as String!
        
        self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.width / 2;
        self.thumbnailView.clipsToBounds = true;
        
        // Asyncronously load the image
        getDataFromUrl(book.bookImgUrl, completion: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.thumbnailView.image = UIImage(data: data)
            }
        })
    }
    
    
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}
