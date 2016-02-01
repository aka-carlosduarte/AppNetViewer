//
//  AppNetManager.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/29/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import Foundation
import UIKit

class AppNetManager:NSObject {
  
  typealias AppNetManagerCompletionHandler = (success:Bool) -> Void
  
  private let apiManager:AppNetAPI
  private var jsonFromServer:JSON = [:]
  private var postsProvider:PostsProvider
  var posts:[Post] = []
  
  class var sharedInstance:AppNetManager{
    struct Singleton {
      static let instance = AppNetManager()
    }
    return Singleton.instance
  }
  
  override init() {
    apiManager    = AppNetAPI()
    postsProvider = PostsProvider()
    super.init()
  }
  
  // get public stream posts, if this is a reresh check for existing posts
  //Parse JSON from the response
  func getPublicStream(isRefreshing:Bool,completion:AppNetManagerCompletionHandler){
    apiManager.getPublicStream { (response, error) -> Void in
      if ((error) != nil){
        NSLog("there was an error\(error)")
        completion(success: false)
      }else{
        if let response = response as? NSData{
          self.jsonFromServer = JSON(data: response)
          self.postsProvider.parsePosts(isRefreshing, jsonFromServer: self.jsonFromServer)
          completion(success: true)
        }
      }
    }
  }
  
  func getPosts(){
    self.posts = self.postsProvider.getPosts()
  }
  
  //call to get post images, on completion if there is an image add it to the corresponding postUser.
  func getPostImages(completion:AppNetManagerCompletionHandler){
    for post in posts{
      self.apiManager.downloadUserImage(post.postUser.avatarUrl, completion: { (image, error) -> Void in
        if ((error) != nil){
          completion(success:false)
        }else{
          post.postUser.avatarImage = image!
          completion(success: true)
        }
      })
    }
  }
  
  
  func getPostsCount()->Int{
    return self.postsProvider.getPostsCount()
  }
}
