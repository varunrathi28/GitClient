//
//  Model.swift
//  GitClient
//
//  Created by Varun Rathi on 11/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import Foundation

public struct CommitModel {
    
    var userName:String!
    var commitName:String!
    var commitMessage:String?
    var avatarUrl:String?
    
    
    init(userName:String , commitName:String , commitMessage :String , avatarUrl:String) {
        self.userName = userName
        self.commitName = commitName
        self.commitMessage = commitMessage
        self.avatarUrl = avatarUrl
    }
    
}
