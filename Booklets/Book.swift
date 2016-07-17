//
//  Book.swift
//  Booklets
//
//  Created by Steven Enamakel on 07/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import RealmSwift

public class Book: Object {
	dynamic var author: String! = nil
	dynamic var id: Int = -1
	dynamic var language: String! = nil
	dynamic var desc: String! = nil
	dynamic var noOfChapters: Int = -1
	dynamic var bookName: String! = nil
	dynamic var bookStore: String! = nil
	dynamic var bookImg: String! = nil
	dynamic var isHidden: Bool = false

    override public class func primaryKey() -> String {
        return "id"
    }
    
	public var bookImgUrl: NSURL {
		get {
            return NSURL(string: self.bookImg)!
		}
	}
}