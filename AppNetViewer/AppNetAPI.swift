//
//  AppNetStreamManager.swift
//  AppNetViewer
//
//  Created by Carlos Duarte on 1/28/16.
//  Copyright © 2016 Apprende Labs LLC. All rights reserved.
//

import Foundation
import UIKit


final class AppNetAPI: NSObject{
  
  typealias AppNetApiCompletionHandler = (response:AnyObject?,error: NSError?) -> Void
  typealias AppNetImageDownoadcopletion = (image:UIImage?, error:NSError?)-> Void
  
  
  override init() {
    super.init()
  }
  
  //query the server for new posts on completion put the data in a JSON object (swiftyJSON) to be used by the manager class
  func getPublicStream(completion:AppNetApiCompletionHandler){
    let urlString = "https://alpha-api.app.net/stream/0/posts/stream/global"
    var jsonFromServer:JSON = [:]
    if let url = NSURL(string: urlString){
      let request = NSURLRequest(URL: url)
      let config  = NSURLSessionConfiguration.defaultSessionConfiguration()
      let session = NSURLSession(configuration: config)
      let task    = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if (error != nil){
          completion(response: nil, error: error)
        }else{
          if let streamData = data{
            jsonFromServer = JSON(data:streamData)
            completion(response: data, error: nil)
            
          }
        }
      })
      task.resume()
    }
  }
  
  
  // download the User's avatar on completion resize it to fit the imageView on the cell.
  func downloadUserImage(url:String, completion: AppNetImageDownoadcopletion){
    if let url = NSURL(string: url){
      let request = NSURLRequest(URL: url)
      let config  = NSURLSessionConfiguration.defaultSessionConfiguration()
      let session = NSURLSession(configuration: config)
      let task    = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if (error != nil){
          completion(image:nil,error: error)
          NSLog("there was an error downloading the image")
        }else{
          if let imageData = data{
            if let theImage = UIImage(data: imageData){
              let rect = CGRectMake(0,0,70,70)
              UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
              theImage.drawInRect(rect)
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              completion(image: newImage, error: error)
            }
          }
        }
      })
      task.resume()
    }
  }
}
