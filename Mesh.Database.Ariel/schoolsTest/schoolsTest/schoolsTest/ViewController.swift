//
//  ViewController.swift
//  schoolsTest
//
//  Created by Ariel Bong on 8/16/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {

    var allSchools: [String] = []
    var filteredSchools = [String]()
    
    @IBOutlet weak var loadSchoolsButton: UIButton!
  
    @IBOutlet var schoolsTable: UITableView!
    let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        schoolsTable.tableHeaderView = searchController.searchBar
        loadSchools()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadSchools() {
        if let path = NSBundle.mainBundle().pathForResource("us_universities", ofType: "txt") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                        loadJsonData(jsonData)  {jsonResults in
                            let schools: [[String:AnyObject]] = jsonResults
                            for school: [String:AnyObject] in schools {
                                self.allSchools.append(school["name"] as! String)
                            }
                        }
                    schoolsTable.reloadData()
                 }
                
             catch {
            
              print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
     
    }
    
    func loadJsonData(data: NSData, callback: ([[String:AnyObject]]) -> Void ) {
       
        do {
            if let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String:AnyObject]] {
                callback(result)
            }
        } catch let error {
            print(error)
        }
        
    }
    
    
    @IBAction func loadSchoolsPressed(sender: AnyObject) {
        
        loadSchools()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredSchools.count
        }
        return allSchools.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell0")! as UITableViewCell
        let school: String
        if searchController.active && searchController.searchBar.text != "" {
            school = filteredSchools[indexPath.row]
        } else {
            school = allSchools[indexPath.row]
        }
        cell.textLabel?.text = school
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSchools = allSchools.filter { school in
            return school.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

