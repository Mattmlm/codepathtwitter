//
//  User.swift
//  Codepath Twitter
//
//  Created by admin on 10/2/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
  var name: String?
  var screenname: String?
  var profileImageUrl: String?
  var tagline: String?
  var dictionary: NSDictionary
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    name = dictionary["name"] as? String
    screenname = dictionary["screen_name"] as? String
    profileImageUrl = dictionary["profile_image_url"] as? String
    tagline = dictionary["description"] as? String
  }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object:nil)
    }

  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
          do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            _currentUser = User(dictionary: dictionary as! NSDictionary);
          } catch {
            print("Error: \(error)")
          }
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      
      if _currentUser != nil {
        do {
          let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
          NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
        } catch {
          print("Error: \(error)")
        }
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}
