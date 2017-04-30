//
//  CustomCommitCell.swift
//  GitClient
//
//  Created by Varun Rathi on 11/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCommitCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblCommitMessage:UILabel!
    @IBOutlet weak var imgViewUser:UIImageView!
    @IBOutlet weak var lblCommitName:UILabel!

     @IBOutlet weak var btnBookmark:UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.textColor = UIColor.blue
        lblCommitName.textColor = UIColor.darkGray
        lblCommitMessage.textColor = UIColor.darkGray
        imgViewUser.layer.cornerRadius = imgViewUser.frame.size.height/2
        imgViewUser.clipsToBounds = true
        
        btnBookmark.setImage(UIImage(named: "bookmark"), for: .normal)
        btnBookmark.setImage(UIImage(named: "bookmark-filled"), for: .selected)
   
        
        // Initialization code
    }

    func updateCell(with commit:CommitModel, forBookmark:Bool)
    {
        if forBookmark == true
        {
            btnBookmark.isHidden = true
        }
        
        if let userName = commit.userName
        {
            lblName.text = userName
        }
        
        if let commitName = commit.commitName , let message = commit.commitMessage
        {
            lblCommitName.text = commitName
            lblCommitMessage.text = ""
            lblCommitMessage.text = message
        }
        
        if let imageUrl = commit.avatarUrl
        {
            let placeholderImage = UIImage(named: "user")
           imgViewUser.kf.setImage(with:URL(string: imageUrl), placeholder: placeholderImage)
        }
        
        if commit.isBookmarked == true
        {
            btnBookmark.isSelected = true
        }
        else
        {
            btnBookmark.isSelected = false
            //  btnBookmark.setImage(UIImage(named: "bookmark-filled"), for: .normal)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       // btnBookmark.isSelected = !btnBookmark.isSelected
        // Configure the view for the selected state
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    //    imageView?.frame.size = CGSize(width: 60, height: 60)
    }
}

