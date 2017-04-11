//
//  NetworkService.swift
//  GitClient
//
//  Created by Varun Rathi on 11/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol ServiceHitDelegate {
    mutating func didRecievedResponse(response:[CommitModel])
    
}

class NetworkService: NSObject {

    var delegate:ServiceHitDelegate?
    
    static let sharedInstance:NetworkService = {
        let instance = NetworkService()
        return instance
    }()
    
    let BaseUrl = "https://api.github.com/"
    let BranchUrl = "https://api.github.com/repos/rails/rails/branches"
    let repoUrl = "repos/rails/rails/commits/master"
    let commitCount = 30
    let commitUrl =  "https://api.github.com/repos/rails/rails/commits?per_page=%d&sha="
    
    let config = URLSessionConfiguration.default
    
    func sendRequestForBranches()
    {
        
        let urlRequest = URLRequest(url: URL(string:BranchUrl)!)
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data
            {
            let json = JSON(data:data)
             
                for branches in json
                {
                    if  branches.1.dictionary?["name"] == "master"
                    {
                      if   let url = branches.1.dictionary?["commit"]?.dictionary?["sha"]?.string
                      {
                        self.hitServiceWithSHA(with : url)
                        
                        }
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func hitServiceWithSHA(with sha:String)
    {
        let substitutedUrl = String(format: commitUrl, commitCount) + sha
        let url = URL(string: substitutedUrl)
        let session = URLSession(configuration: config)
        var commitsArr:[CommitModel] = []
        
        let task = session.dataTask(with: url!) { (data, response, error) in
        //  if respons
            
            let json = JSON(data:data!)
            

             if let responseArray = json.array
             {
                
                for commits in responseArray
                {
                    let name = commits["commit"]["author"]["name"].string
                    
                //    let commit = commits["committer"]["name"].string
                    let message = commits["commit"]["message"].string
                    let avatarURL = commits["author"]["avatar_url"].string
                    
                    
                    let commitObj = CommitModel(userName: name!, commitName: "master", commitMessage: message!, avatarUrl :avatarURL!)
                    commitsArr.append(commitObj)
                    
                }
                if commitsArr.count > 0
                {
                    self.delegate?.didRecievedResponse(response: commitsArr)
                    
                }
            
            }
            
        }
        task.resume()
        
       
        
        
    }
    
    
}
