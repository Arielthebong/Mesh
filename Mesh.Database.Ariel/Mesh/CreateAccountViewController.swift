//
//  CreateAccountViewController.swift
//  Mesh
//
//  Created by Paa Adu on 7/10/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var requestMaster: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createAccount(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            displayAlert("Please enter your email address")
        } else if passwordTextField1.text!.isEmpty {
            displayAlert("Please enter your password")
        } else if passwordTextField2.text!.isEmpty {
            displayAlert("Please re-enter your password")
        } else if passwordTextField1.text! != passwordTextField2.text! {
            displayAlert("Your passwords do not match")
        } else if (requestMaster.on && (companyTextField.text?.isEmpty)!) {
            displayAlert("Please enter your company for Master Account")
            return
        }
        
        if let email = emailTextField.text, password = passwordTextField1.text {
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    self.displayAlert(error.localizedDescription)
                }
                if(self.requestMaster.on) {
                    requestMasterAccount(self.companyTextField.text!)
                }
                self.performSegueWithIdentifier("createdAccount", sender: self)
            }
        }
        
    }
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
