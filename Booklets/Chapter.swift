//
//  Chapter.swift
//  Booklets
//
//  Created by Steven Enamakel on 09/04/16.
//  Copyright © 2016 Booklets. All rights reserved.
//

import Foundation

public class Chapter {
    public var audioFile : NSURL? = nil
    public var affliateLink : NSURL! = nil
    public var id : Int = -1
    public var isAffliate : Bool = false
    public var isAudioAvailable : Bool = false
    public var noOfMinimumLines : Int = 0
    public var resourceUri : NSURL! = nil
    public var saveAsDraft : Bool? = false
    public var summary : NSString? = nil
    public var title : NSString! = nil
    
    init?() {
        
    }
    
    convenience init(json : AnyObject) {
        self.init()!
        let dict = json as! NSDictionary
        dict.objectForKey("audio_file")
        
//        print(json)
        self.audioFile = NSURL(string: dict.objectForKey("audio_file") as! String)!
//        self.affliateLink = NSURL(string: json["affliate_link"] as! String)!
        self.id = json["id"] as! Int
//        self.isAffliate = json["is_affliate"] as! Bool
        self.summary = json["summary"] as! String
        self.title = json["title"] as! String
    }
    
}