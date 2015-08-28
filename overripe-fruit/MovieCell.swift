//
//  MovieCell.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/27/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit
import AFNetworking

class MovieCell: UITableViewCell {
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var descriptionView: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  func setData(imageUrl: NSURL?, title: String?, synopsis: String?, rating: String?) {
    // Reset the image view so that it won't show the previous image
    if let imageView = posterImageView {
      imageView.image = nil
      imageView.alpha = 0.0
      
      if let url = imageUrl {
        let req = NSURLRequest(URL: url)
        let op = AFHTTPRequestOperation(request: req)
        let start = NSDate.timeIntervalSinceReferenceDate()
        imageView.setImageWithURLRequest(req, placeholderImage: nil, success: { (req, res, image) -> Void in
          // Set the image
          imageView.image = image
          
          // Fade in the image if it didn't come from the cache
          if NSDate.timeIntervalSinceReferenceDate() - start < 0.05 {
            imageView.alpha = 1.0
            return
          }
          imageView.alpha = 0.0
          UIView.animateWithDuration(0.5, animations: { () -> Void in
            imageView.alpha = 1.0
          })
        }, failure: {(req, res, error) -> Void in
          NSLog("Image load failed: \(error.localizedDescription)")
        })
      }
    }
    titleView?.text = title
    
    if let synopsis = synopsis, rating = rating {
      let bold = [NSFontAttributeName : UIFont.boldSystemFontOfSize(12.0)]
      var attributedText = NSMutableAttributedString(string: rating + " ", attributes: bold)
      attributedText.appendAttributedString(NSAttributedString(string: synopsis))
      descriptionView?.attributedText = attributedText
    }
  }
}
