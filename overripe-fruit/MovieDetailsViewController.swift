//
//  MovieDetailsViewController.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/28/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  var data: NSDictionary?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.navigationBar.topItem?.title = data?.valueForKeyPath("title") as? String
  }
}
