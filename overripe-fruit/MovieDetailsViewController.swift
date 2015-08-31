//
//  MovieDetailsViewController.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/28/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!

  var descriptionText: NSAttributedString? = nil
  var titleText: String? = nil
  var image: UIImage? = nil
  var imageUrl: NSURL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blackColor()
    
    var firstRange: NSRange? = nil
    descriptionText?.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, descriptionText!.length), options: nil) { (attr, range, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
      firstRange = range
      stop.memory = true
    }
    if let range = firstRange, descriptionText = descriptionText {
      var style = NSMutableParagraphStyle()
      style.alignment = NSTextAlignment.Justified
      
      var mutable = NSMutableAttributedString(attributedString: descriptionText)
      mutable.beginEditing()
      mutable.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
      mutable.endEditing()
      
      self.descriptionText = mutable
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = ""
    
    if let imageUrl = imageUrl {
      posterView.setImageWithURL(imageUrl, placeholderImage: image)
    }
    posterView.frame.size = CGSizeMake(posterView.frame.width,
      posterView.frame.height - navigationController!.navigationBar.frame.height
                              - UIApplication.sharedApplication().statusBarFrame.size.height)
    
    
    let padding: CGFloat = 16.0
    let offset: CGFloat = 32.0
    let bgColor = UIColor(white: 0.0, alpha: 0.8)
    let descriptionLabel = UILabel()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    descriptionLabel.attributedText = descriptionText
    descriptionLabel.textAlignment = NSTextAlignment.Left
    descriptionLabel.textColor = UIColor.whiteColor()
    var textSize = descriptionLabel.sizeThatFits(CGSize(width: scrollView.frame.width - padding * 2.0, height: 10000000.0))
    descriptionLabel.frame = CGRect(origin: CGPoint(x: padding, y: padding / 2.0), size: textSize)
    
    let wrapper = UIView(frame: CGRectMake(0, posterView.frame.height - offset, scrollView.frame.width, textSize.height + padding))
    wrapper.backgroundColor = bgColor
    wrapper.addSubview(descriptionLabel)
    
    scrollView.addSubview(wrapper)
    scrollView.contentSize = CGSize(width: scrollView.frame.width,
      height: wrapper.frame.height + posterView.frame.height - offset)
  }
  
  override func viewWillDisappear(animated: Bool) {
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    
  }
}
