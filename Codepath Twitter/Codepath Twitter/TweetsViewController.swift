//
//  TweetsViewController.swift
//  Codepath Twitter
//
//  Created by admin on 10/3/15.
//  Copyright © 2015 mattmo. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    var refreshControl = UIRefreshControl()
    var formatter = NSDateComponentsFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#55ACEE");
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        let tweetCellNib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        self.tableView.registerNib(tweetCellNib, forCellReuseIdentifier: "TweetCell")
        
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Set up refresh control
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.loadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTweets() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData();
            } else {
                print("Error getting home timeline tweets:\(error)")
            }
        }
    }
    
    func onRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.refreshControl.endRefreshing()
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData();
            } else {
                print("Error getting home timeline tweets:\(error)")
            }
        }
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
        let tweet = tweets?[indexPath.row]
        cell.profileImageView.setImageWithURL(NSURL(string: (tweet?.user?.profileImageUrl!)!)!)
        cell.userNameLabel.text = tweet?.user?.name!
        cell.screenNameLabel.text = "@\((tweet?.user?.screenname)!)"
        cell.tweetTextLabel.text = tweet?.text!
        cell.tweetCreatedAtLabel.text = formatTimeElapsed(tweet?.createdAt)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTweetDetails", sender: self);
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func formatTimeElapsed(sinceDate: NSDate?) -> String {
        if let date = sinceDate {
            self.formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
            self.formatter.collapsesLargestUnit = true
            self.formatter.maximumUnitCount = 1
            let interval = NSDate().timeIntervalSinceDate(date)
            return self.formatter.stringFromTimeInterval(interval)!
        }
        return ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTweetDetails") {
            let vc = segue.destinationViewController as! TweetDetailsViewController
            let tweet = tweets?[(tableView.indexPathForSelectedRow?.row)!]
            vc.tweet = tweet;
        }
    }

}
