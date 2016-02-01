//
//  Post.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/29/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import Foundation


class Post: NSObject {
  
  var postId: Int = 0
  var postText: String = ""
  var postUser: User = User()
  
  init(post_json:JSON){
    self.postId   = post_json["id"].intValue
    self.postText = post_json["text"].stringValue
    if let theUser = post_json["user"].dictionaryObject
    {
      self.postUser = User(userDictionary: theUser)
    }
  }
  
  override init(){
    super.init()
    
  }
}
