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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }

    @IBAction func onTweetButtonPressed(sender: AnyObject) {
        let dict = NSDictionary(object: tweetField.text!, forKey: "status");
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
