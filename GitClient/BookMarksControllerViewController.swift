//
//  BookMarksControllerViewController.swift
//  GitClient
//
//  Created by Varun Rathi on 29/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit


class BookMarksControllerViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var dataSource:[CommitModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  fetchBookmarkedList()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookmarkedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchBookmarkedList()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.commitList.count > 0
        {
          //  let predicate = NSPredicate(format: "%K = %d", "age", 33)
            let commitList = appDelegate.commitList
            let filteredResults = commitList.filter({ (commit) -> Bool in
                return commit.isBookmarked == true
            })
            
            if filteredResults.count > 0
            {
                dataSource = filteredResults
                tableView.reloadData()
            }
            
        }
    }
    


}

extension BookMarksControllerViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
        
          }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.UserCellIdentifier, for: indexPath) as! CustomCommitCell

         let   commit = dataSource[indexPath.row]
        cell.updateCell(with: commit , forBookmark:true)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension BookMarksControllerViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
