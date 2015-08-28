//
//  MovieCell.swift
//  overripe-fruit
//
//  Created by Patrick Stein on 8/27/15.
//  Copyright (c) 2015 patrick. All rights reserved.
//

import UIKit

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
  
  func setData(imageUrl: NSURL?, title: String?, synopsis: String?) {
    if let url = imageUrl {
      posterImageView?.setImageWithURL(url)
    }
    titleView?.text = title
    descriptionView?.text = synopsis
  }
}
