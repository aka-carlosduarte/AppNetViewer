//
//  TableViewController.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/29/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
let postsStreamManager = AppNetManager.sharedInstance
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    postsStreamManager.getPublicStream(false) { (success) -> Void in
      if (!success){
        NSLog("there was an errror nothing to update")
      }else{
        NSLog("WE SHOULD UPDATE THE UI NOW")
        self.postsStreamManager.getPosts()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.tableView.reloadData()
        })
        self.updateImages()
      }
      self.tableView.estimatedRowHeight = 70
      self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    self.refreshControl?.addTarget(self, action: "refreshPosts:", forControlEvents: UIControlEvents.ValueChanged)
    NSLog("this happened!!!")
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
  }
  
  
  //MARK: UITableView DataSource
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postsStreamManager.getPostsCount()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // set up the contents of the cell
    let cell = self.tableView.dequeueReusableCellWithIdentifier("AppViewerCellIdentifier", forIndexPath: indexPath) as! AppNetViewerTableViewCell
    cell.postTextLabel.text = postsStreamManager.posts[indexPath.row].postText
    cell.userNameLabel.text = postsStreamManager.posts[indexPath.row].postUser.name
    cell.userAvatar.image  = postsStreamManager.posts[indexPath.row].postUser.avatarImage
    return cell
  }
  
  //MARK: UIRefreshControl Handler
  func refreshPosts(refreshcontrol:UIRefreshControl){
    //Get the post count before quering the server
    let postsCountBeforeRefresh = self.postsStreamManager.getPostsCount()
    postsStreamManager.getPublicStream(true) { (success) -> Void in
      if (!success){
        NSLog("there was an error while refreshing the tableview")
      }else{
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          //get updated posts and post count so that we can calculate the indexpaths
          //where the new cells will be added to
          self.postsStreamManager.getPosts()
          let numberOfNewPosts = (self.postsStreamManager.getPostsCount())-postsCountBeforeRefresh
          if (numberOfNewPosts>0){
            var indexPathsArray:[NSIndexPath] = []
            for i in 0...numberOfNewPosts-1{
              indexPathsArray.append(NSIndexPath(forRow: i, inSection: 0))
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indexPathsArray, withRowAnimation: UITableViewRowAnimation.Top)
            self.updateImages()
            self.tableView.endUpdates()
          }else{
            NSLog("There is no new posts to add right now")
          }
        })
        refreshcontrol.endRefreshing()
      }
    }
  }
  
  //to get the images for the user avatars on success reload data to update the UI
  func updateImages(){
    self.postsStreamManager.getPostImages({ (success) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.tableView.reloadData()
      })
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
