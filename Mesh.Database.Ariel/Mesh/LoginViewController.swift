//
//  LoginViewController.swift
//  Mesh
//
//  Created by Paa Adu on 6/27/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var masteraccounts: [String:String]?
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            displayAlert("Please enter your email address")
        } else if passwordTextField.text!.isEmpty {
            displayAlert("Please enter your password")
        }
        
        if let email = emailTextField.text, password = passwordTextField.text {
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    self.displayAlert(error.localizedDescription)
                }
                isTechAccount() {(isTechAccount) in
                    getMasterAccountRequests() { masterAccounts in
                        self.masteraccounts = masterAccounts
                        self.segueToCorrectScreen(isTechAccount)
                    }
                    
                }
            }
        }
    }
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func segueToCorrectScreen(isTechAccount: Bool) {
      if(isTechAccount) {
            self.performSegueWithIdentifier("requestTable", sender: self)
        } else {
            self.performSegueWithIdentifier("login", sender: self)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "requestTable") {
                let masterRequestVC = segue.destinationViewController as? MasterRequestTable
                masterRequestVC?.masterAccountRequests = masteraccounts
                masterRequestVC?.masterAccountRequestKeys = Array(masteraccounts!.keys)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

