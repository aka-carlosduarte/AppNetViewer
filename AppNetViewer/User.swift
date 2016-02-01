//
//  User.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 2/1/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import Foundation
import UIKit

class User : NSObject{
  
  var userId: Int = 0
  var userName: String = ""
  var name: String = ""
  var avatarUrl: String = ""
  var avatarImage: UIImage?
  
  init(userDictionary:NSDictionary){
    if let id = userDictionary["id"] as? Int{
      self.userId = id
    }

    if let theUserName = userDictionary["username"] as? String{
      self.userName  = theUserName
    }
    if let theName = userDictionary["name"] as? String {
      self.name = theName
    }
    if let avatarDictionary = userDictionary["avatar_image"]as? NSDictionary{
      if let url = avatarDictionary["url"] as? String{
        self.avatarUrl = url
      }
    }
    

  }
  
  override init(){
    super.init()
    
  }
}