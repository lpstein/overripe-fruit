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
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBInspectable var sourceUrl: String!
  @IBOutlet weak var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  var selectedIndex: Int = -1
  
  let requestManager = AFHTTPSessionManager()
  var data: NSArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)

    tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "com.shazam.MovieCell")
    tableView.dataSource = self
    tableView.delegate = self
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let vc = segue.destinationViewController as? MovieDetailsViewController {
      vc.data = data[selectedIndex] as? NSDictionary
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("com.shazam.MovieCell", forIndexPath: indexPath) as! MovieCell

    if let movie = data[indexPath.row] as? NSDictionary {
      cell.setData(NSURL(string: hackImageUrl(movie.valueForKeyPath("posters.thumbnail") as! String))!,
        title: movie.valueForKeyPath("title") as? String,
        synopsis: movie.valueForKeyPath("synopsis") as? String,
        rating: movie.valueForKeyPath("mpaa_rating") as? String
      )
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedIndex = indexPath.row
    performSegueWithIdentifier("selection", sender: self)
  }
    
  func onRefresh() {
    println("Refresh")
    
    load()
  }
  
  func load() {
    requestManager.GET(sourceUrl, parameters: nil, success: { (operation, response) -> Void in
      self.data = response.objectForKey("movies") as! NSArray
      self.tableView.reloadData()
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
    }, failure: { (operation, error) -> Void in
      NSLog("Load failed: \(error.localizedDescription)")
      
      if self.refreshControl.refreshing {
        self.refreshControl.endRefreshing()
      }
    })
  }
  
  func hackImageUrl(url: String) -> String {
    if let range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch) {
      return url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
    } else {
      return url
    }
  }
}
