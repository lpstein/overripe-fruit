//
//  MoviesViewController.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/26/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit

@objc(MoviesViewController)
class MoviesViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    scrollView.insertSubview(refreshControl, atIndex: 0)

    scrollView.contentSize.height = 900.0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func onRefresh() {
    println("Refresh")
    
    refreshControl.endRefreshing()
  }
  
  func load() {
    
  }
}
