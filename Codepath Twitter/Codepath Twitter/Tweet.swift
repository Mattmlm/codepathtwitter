//
//  Tweet.swift
//  Codepath Twitter
//
//  Created by admin on 10/2/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favorited: Bool?
    var id: Int?
    var idString: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        id = dictionary["id"] as? Int
        idString = dictionary["id_str"] as? String
        
        TweetDateFormatter.setDateFormatterForInterpretingJSON()
        let formatter = TweetDateFormatter.sharedInstance
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
