//
//  ViewController.swift
//  GitClient
//
//  Created by Varun Rathi on 11/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftSpinner

class ViewController: UIViewController,UISearchResultsUpdating,UISearchControllerDelegate  {

    @IBOutlet weak var tableView:UITableView!
    var dataSource:[CommitModel] = []
    
    var filterResults = [CommitModel]()
    var shouldShowSearchResults:Bool = false
    
    var searchController:UISearchController!
    
    @IBOutlet weak var seachbar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  loadDummyData()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        loadSeachCotnroller()
        
        tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            
           
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
      //  SwiftSpinner.show("Fetching Commits...")
        let networkService = NetworkService.sharedInstance
        networkService.delegate = self
        networkService.sendRequestForBranches()
    }

 
    

    //MARK : - Seach Controller Methods
    
    func loadSeachCotnroller()
    {
    
    searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = " Search..."
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        
        if let input = searchString
        {
            
            filterResults = dataSource.filter({ (model) -> Bool in
                let result =  model.userName.contains(input)
                print("result: \(result)")
                return result
                   // .range(of: input, options: .caseInsensitive) != nil
            })
        }
        
        if filterResults.count > 0
        {
            
            tableView.reloadData()
        }
        
    }

    
}


extension ViewController : UISearchBarDelegate
{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        filterResults = []
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
    }

}

extension ViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults
        {
           return filterResults.count
        }
        else
        {
         return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.UserCellIdentifier, for: indexPath) as! CustomCommitCell
        
        let commit : CommitModel
        
        if shouldShowSearchResults
        {
            commit = filterResults[indexPath.row]
        }
        else
        {
            commit = dataSource[indexPath.row]
        }
        
        
        cell.updateCell(with: commit, forBookmark:false)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let commit = dataSource[indexPath.row]
        
        commit.isBookmarked = !commit.isBookmarked
        tableView.reloadData()
    }
    
}

extension ViewController : ServiceHitDelegate
{
    func didRecievedResponse(response: [CommitModel]) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.commitList = response
        dataSource = response
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        //    SwiftSpinner.hide()
        }
    }
    
}

