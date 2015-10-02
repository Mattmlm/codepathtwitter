//
//  TwitterClient.swift
//  Codepath Twitter
//
//  Created by admin on 10/2/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

struct Credentials {
    static let defaultCredentialsFile = "Credentials"
    static let defaultCredentials     = Credentials.loadFromPropertyListNamed(defaultCredentialsFile)
    
    let consumerKey: String
    let consumerSecret: String
    
    private static func loadFromPropertyListNamed(name: String) -> Credentials {
        
        // You must add a Credentials.plist file
        let path           = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
        let dictionary     = NSDictionary(contentsOfFile: path)!
        let consumerKey    = dictionary["ConsumerKey"] as! String
        let consumerSecret = dictionary["ConsumerSecret"] as! String
        
        return Credentials(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
}

class TwitterClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!;
    var accessSecret: String!;
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : TwitterClient? = nil
        }
        
        dispatch_once(&Static.token) {
            let consumerKey = Credentials.defaultCredentials.consumerKey
            let consumerSecret = Credentials.defaultCredentials.consumerSecret
            let baseUrl = NSURL(string: "https://api.twitter.com")
            Static.instance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret:consumerSecret)
        }
        return Static.instance!
    }
}