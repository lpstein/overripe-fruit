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

  var descriptionText: NSAttributedString?
  var imageUrl: NSURL?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  func setImagePreview(url: NSURL) {
    if let imageView = posterImageView {
      // Reset the image view so that it won't show the previous cell's image
      imageView.image = nil
      imageView.alpha = 0.0
      
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
        
        if url != self.imageUrl {
          NSLog("Falling back to full-sized image")
          if let imageUrl = self.imageUrl {
            self.setImagePreview(imageUrl)
          }
        }
      })
    }
  }
  
  func setData(imageUrl: String?, title: String?, synopsis: String?, rating: String?, stars: Int?, year: Int?) {
    self.imageUrl = NSURL(string: imageUrl!)
    
    if let imageUrl = imageUrl, url = turnIntoThumbnailURL(imageUrl) {
      setImagePreview(url)
    }
    
    titleView?.text = title
    
    if let synopsis = synopsis, rating = rating, stars = stars, year = year {
      let paragraph = NSMutableParagraphStyle()
      paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
      let bold = [
        NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0),
      ]
      let starString = String(count: stars, repeatedValue: Character("★")) +
        String(count: 4 - stars, repeatedValue: Character("☆"))
      let headline = "\(rating) • \(year) • \(starString)\n\n"
      var attributedText = NSMutableAttributedString(string: headline, attributes: bold)
      attributedText.appendAttributedString(NSAttributedString(string: synopsis))
      attributedText.setAttributes([
        NSParagraphStyleAttributeName : paragraph
      ], range: NSMakeRange(0, attributedText.length))
      
      descriptionText = attributedText
      descriptionView?.attributedText = attributedText
      descriptionView?.userInteractionEnabled = false
      
    }
  }
  
  func turnIntoThumbnailURL(url: String) -> NSURL? {
    if let range = url.rangeOfString("ori.jpg") {
      return NSURL(string: url.stringByReplacingCharactersInRange(range, withString: "det.jpg"))
    } else {
      return NSURL(string: url)
    }
  }
}
