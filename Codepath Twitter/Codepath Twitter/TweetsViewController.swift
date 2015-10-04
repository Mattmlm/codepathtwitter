//
//  TweetsViewController.swift
//  Codepath Twitter
//
//  Created by admin on 10/3/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        let tweetCellNib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        self.tableView.registerNib(tweetCellNib, forCellReuseIdentifier: "TweetCell")
        
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData();
            } else {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    // MARK: - TableViewController
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.profileImageView.setImageWithURL(NSURL(string: (tweets?[indexPath.row].user?.profileImageUrl!)!)!)
        cell.userNameLabel.text = tweets?[indexPath.row].user?.name!
        cell.screenNameLabel.text = "@\(tweets?[indexPath.row].user?.screenname!)"
        cell.tweetTextLabel.text = tweets?[indexPath.row].text!
        //cell.textLabel!.text = tweets?[indexPath.row].user?.name;
        return cell
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
