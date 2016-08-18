//
//  MasterRequestTable.swift
//  Mesh
//
//  Created by Ariel Bong on 8/14/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase

class MasterRequestTable: UITableViewController {
    var masterAccountRequests: [String: String]!
    var masterAccountRequestKeys: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*getMasterAccountRequests() { (masterAccounts) in
            self.masterAccountRequests = masterAccounts
            self.masterAccountRequestKeys = Array(self.masterAccountRequests.keys)
            print(self.masterAccountRequests)
             super.viewDidLoad()
        }*/
       
     
        
     
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return masterAccountRequestKeys.count
    }
    
    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell0")! as UITableViewCell
        cell.textLabel?.text = masterAccountRequestKeys[indexPath.row]
       
        return cell
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedAccount = masterAccountRequests[masterAccountRequestKeys[indexPath.row]]! as String
        print(indexPath.row)
        print(masterAccountRequestKeys[indexPath.row])
        print(masterAccountRequests[masterAccountRequestKeys[indexPath.row]])
        verifyMasterAccount(selectedAccount)
    }
}
