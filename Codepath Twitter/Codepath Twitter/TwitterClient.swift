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
    static let baseUrl = NSURL(string: "https://api.twitter.com")!;
    var accessToken: String!;
    var accessSecret: String!;
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : TwitterClient? = nil
        }
        
        dispatch_once(&Static.token) {
            let consumerKey = Credentials.defaultCredentials.consumerKey
            let consumerSecret = Credentials.defaultCredentials.consumerSecret
            Static.instance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret:consumerSecret)
        }
        return Static.instance!
    }
    
    func retweetWithCompletion(id: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("Successfully retweeted")
            print(response)
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("error: \(error)");
            completion(tweet: nil, error: error)
        }
    }
    
    func favoriteWithCompletion(state: Bool, params: NSDictionary?, completion: (error: NSError?) -> ()) {
        let endpoint = (state) ? "1.1/favorites/create.json" : "1.1/favorites/destroy.json"
        POST(endpoint, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print(response)
            completion(error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        }
    }
    
    func composeTweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //
            print(response)
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            //
            print("error composing tweet")
            completion(tweet: nil, error: error)
        }
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print(response)
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                print("text: \(tweet.text), created: \(tweet.createdAtString)")
            }
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("error getting hometimeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken();
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got Request Token")
            let authURL = NSURL(string: "\(TwitterClient.baseUrl)/oauth/authorize?oauth_token=\(requestToken.token)");
            UIApplication.sharedApplication().openURL(authURL!);
            }) { (error: NSError!) -> Void in
                print("Error: \(error)");
                self.loginCompletion?(user: nil, error: error);
        };
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Successfully retrieved access token");
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken);
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success:
                { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    //print("Successfully verified credentials: \(response)");
                    var user = User(dictionary: response as! NSDictionary)
                    print("user: \(user.name)")
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("Error verifying credentials: \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token: \(error)");
            self.loginCompletion?(user: nil, error: error)
        }
    }
}