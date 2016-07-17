//
//  BooksTableViewController.swift
//  Booklets
//
//  Created by Steven Enamakel on 07/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class BooksTableViewController: UITableViewController {
	var books = [Book]()

	let FIRST_TIME_KEY = "booksfirsttime1"

	override func viewDidLoad() {
		super.viewDidLoad()

		loadBooks()
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "BookTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
			forIndexPath: indexPath) as! BookTableViewCell

		let book = books[indexPath.row]
		cell.setMainBook(book)
		return cell
	}

	func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
		NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
			completion(data: data, response: response, error: error)
		}.resume()
	}

	func loadBooks() {
		Alamofire.request(
				.GET, "http://52.27.197.48/api/v1/book/",
			parameters: nil,
			encoding: .JSON,
			headers: [
				"Authorization": "Basic Og=="
		])
			.responseJSON {
				response in switch response.result {
					case .Success(let JSON):
					let booksJson = JSON["objects"] as! NSArray

					// Get the default Realm
					let realm = try! Realm()

					for bookJson in booksJson {
						print(bookJson)
						let book = Book()

						book.author = bookJson["author"] as! String
						book.bookImg = bookJson["book_img"] as! String
						book.bookName = bookJson["book_name"] as! String
						book.desc = bookJson["description"] as! String
						book.language = bookJson["language"] as! String
						book.noOfChapters = bookJson["no_of_chapters"] as! Int
						book.id = bookJson["id"] as! Int

						if (!NSUserDefaults.standardUserDefaults().boolForKey(self.FIRST_TIME_KEY)) {
							book.isHidden = ![1, 2, 10].contains(book.id)
						}

						let predicate = NSPredicate(format: "id = \(book.id)")
						let realmBook = realm.objects(Book.self).filter(predicate)
						
                        if (realmBook.first == nil) {
							// Persist our data easily
							try! realm.write {
								realm.add(book)
							}
						}
					}

					let predicate = NSPredicate(format: "isHidden = false")
					let realmBooks = realm.objects(Book.self).filter(predicate)
					print(Realm.Configuration.defaultConfiguration.fileURL)

					self.books = Array(realmBooks)

					if (!NSUserDefaults.standardUserDefaults().boolForKey(self.FIRST_TIME_KEY)) {
						NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.FIRST_TIME_KEY)
						NSUserDefaults.standardUserDefaults().synchronize()
					}

					self.tableView.reloadData()

					case .Failure(let error):
					print("Request failed with error: \(error)")
				}
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "bookSegue") {
			let controller = segue.destinationViewController as! ChapterTableViewContoller
			let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
			controller.book = books[selectedIndex!.row]
		}
	}
}
