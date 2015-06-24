//
//  ForgotPasswordViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/24/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet var emailAddress: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
        
        if(PFUser.requestPasswordResetForEmailInBackground(emailAddress.text) == true) {
            println("ooo")
            self.performSegueWithIdentifier("backToLogin", sender: self)
        } else {
           self.displayAlert("Please re-enter", error: "Could not find that email address")
        }
    }
    @IBAction func backToLoginPageButton(sender: AnyObject) {
        self.performSegueWithIdentifier("backToLogin", sender: self)
    }
    
    func isValidAddress(email: String) -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, error: String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
         //   self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
