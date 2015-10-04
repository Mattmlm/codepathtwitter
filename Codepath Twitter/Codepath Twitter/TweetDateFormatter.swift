//
//  TweetDateFormatter.swift
//  Codepath Twitter
//
//  Created by admin on 10/2/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit

class TweetDateFormatter : NSObject {
    class var sharedInstance : NSDateFormatter {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : NSDateFormatter? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NSDateFormatter()
            Static.instance!.dateFormat = "EEE MMM d HH:mm:ss Z y"
        }
        
        return Static.instance!
    }
    
    class func setDateFormatterForInterpretingJSON() {
        sharedInstance.dateFormat = "EEE MMM d HH:mm:ss Z y"
    }
    
    class func setDateFormatterForTweetDetails() {
        sharedInstance.dateFormat = "M/d/yy, h:mm a"
    }
}