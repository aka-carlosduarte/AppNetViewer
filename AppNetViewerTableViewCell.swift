//
//  AppNetViewerTableViewCell.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/31/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import UIKit

class AppNetViewerTableViewCell: UITableViewCell {
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var postTextLabel: UILabel!
  @IBOutlet weak var userAvatar: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
