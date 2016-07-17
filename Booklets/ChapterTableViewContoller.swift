//
//  ChapterTableViewContoller.swift
//  Booklets
//
//  Created by Steven Enamakel on 09/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit
import Alamofire


class ChapterTableViewContoller: UITableViewController {
    var book : Book! = Book()
    var chapters = [Chapter]()
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.title = book.bookName as String
        loadChapters()
        
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        // Automatically resize the table's height
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let image = UIImage(named: "Image")
        view.backgroundColor = UIColor(patternImage: image!)
    }
    
    @IBAction func OnTouch(sender: AnyObject) {
//        let cell = sender.superview!!.superview as! ChapterTableViewCell
        
        
//        prepareForSegue("chapterSegue", sender: cell)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ChapterTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! ChapterTableViewCell
        
        let chapter = chapters[indexPath.row]
        cell.attachChapter(chapter)
        
//        cell.frame = tableView.bounds
        
        return cell
    }
    
    
    func loadChapters() {
        print("http://52.27.197.48/api/v1/chapter/?book=\(self.book.id)")
        Alamofire.request(
            .GET, "http://52.27.197.48/api/v1/chapter/?book=\(self.book.id)",
            parameters: nil,
            encoding: .JSON,
            headers: [
                "Authorization" : "Basic Og=="
            ])
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    let chaptersJson = JSON["objects"] as! NSArray
                    
                    self.chapters = []
                    
                    for chapterJson in chaptersJson {
                        let chapter = Chapter(json: chapterJson)
                        self.chapters.append(chapter)
//                        self.chapters += [chapter]
                    }
                    
                    self.chapters = self.chapters.reverse()
                    
                    self.tableView.reloadData()
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "chapterSegue") {
            let controller = segue.destinationViewController as! ChapterDescriptionViewController

            let selectedIndex = self.tableView.indexPathForCell(sender!.superview!!.superview!.superview!.superview!.superview as! UITableViewCell)
            controller.chapter = chapters[selectedIndex!.row]
        }
    }
}