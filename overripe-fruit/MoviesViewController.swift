//
//  MoviesViewController.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/26/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit
import AFNetworking

@objc(MoviesViewController)
@IBDesignable
class MoviesViewController: UIViewController, UITableViewDataSource {
  @IBInspectable var sourceUrl: String!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scrollView: UIScrollView!
  var refreshControl: UIRefreshControl!
  
  let requestManager = AFHTTPSessionManager()
  var data: NSArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    scrollView.insertSubview(refreshControl, atIndex: 0)

    tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "com.shazam.MovieCell")
    tableView.dataSource = self
    tableView.rowHeight = 180.0
    tableView.backgroundView?.layer.zPosition = -1
    
    requestManager.responseSerializer.acceptableContentTypes = Set(["text/plain"])
  }
  
  override func viewWillAppear(animated: Bool) {
    load()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("com.shazam.MovieCell", forIndexPath: indexPath) as! MovieCell

    if let movie = data[indexPath.row] as? NSDictionary {
      cell.setData(NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!,
        title: movie.valueForKeyPath("title") as? String,
        synopsis: movie.valueForKeyPath("synopsis") as? String)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
    
  func onRefresh() {
    println("Refresh")
    
    refreshControl.endRefreshing()
  }
  
  func load() {
    requestManager.GET(sourceUrl, parameters: nil, success: { (operation, response) -> Void in
      self.data = response.objectForKey("movies") as! NSArray
      self.tableView.reloadData()
    }, failure: { (operation, error) -> Void in
      NSLog("Load failed: \(error.localizedDescription)")
    })
  }
}
