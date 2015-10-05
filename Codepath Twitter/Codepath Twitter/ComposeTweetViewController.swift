//
//  ComposeTweetViewController.swift
//  Codepath Twitter
//
//  Created by admin on 10/4/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit



class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var tweetField: UITextField!
    
    var replyToTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#55ACEE");
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        if replyToTweet != nil {
            self.tweetField.text = "@\((replyToTweet!.user?.screenname)!) "
        }
        
        self.tweetField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }

    @IBAction func onTweetButtonPressed(sender: AnyObject) {
        let dict = NSMutableDictionary()
        dict["status"] = tweetField.text!
        if replyToTweet != nil {
            dict["in_reply_to_status_id"] = replyToTweet!.idString!
        }
        TwitterClient.sharedInstance.composeTweetWithCompletion(dict) { (tweet, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil);
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
