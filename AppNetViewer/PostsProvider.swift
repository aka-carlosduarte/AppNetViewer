//
//  PostsProvider.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/29/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import Foundation

class PostsProvider: NSObject {
  private var posts:[Post] = []
  private var postJson:JSON = [:]
  
  //Parse the posts on the JSON file check if this is a refresh 
  //if we find an existing post we can break the loop since the remaining posts on the JSON file are already on the Posts array
  func parsePosts(isRefreshing:Bool,jsonFromServer:JSON){
    for data in jsonFromServer["data"].arrayValue
      {
        let newPost = Post(post_json: data)
        if (isRefreshing){
          //Check if the post is already downloaded
          if (!self.postWitIdExists(newPost.postId)){
            posts.insert(newPost, atIndex: 0)
          }else{
            break
          }
        }else{
          posts.append(newPost)
          print(newPost)
        }
      }
  }
  
  func getPosts()->[Post]{
    //Sort the post in Descending Order before returning the array of posts 
    //this is important to make sure the most current post is at the top of the array
    self.posts.sortInPlace { (post1:Post, post2:Post) -> Bool in
      return post1.postId > post2.postId
    }
    return posts
  }
  func getPostsCount()->Int{

    return posts.count
  }
  
  
  //Check for existing posts if the user is pulling to refresh
  func postWitIdExists(id:Int)->Bool{
    let firstId = posts.first?.postId
    NSLog("first id is:\(firstId)")
    
    let postExists = posts.filter{$0.postId == id}
    if (postExists.isEmpty){
      NSLog("Post DOES NOT Exist")
      return false
    }else{
      NSLog("Post Exist")
      return true
    }
  }
  
  override init() {
    super.init()
  }
  
  
  
  
}