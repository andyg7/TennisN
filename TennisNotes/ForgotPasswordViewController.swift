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
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var emailAddress: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
        
        PFUser.requestPasswordResetForEmailInBackground(emailAddress.text, block: { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                if succeeded { // SUCCESSFULLY SENT TO EMAIL
                    
                    self.performSegueWithIdentifier("backToLogin", sender: self)
                    println("Reset email sent to your inbox");
                }
                else { // SOME PROBLEM OCCURED
                    self.displayAlert("Reset link couldn't be sent", error: "Please try again")
                }
            }
            else { //ERROR OCCURED, DISPLAY ERROR MESSAGE
                self.displayAlert("Could not find email address", error: "Please re-enter")
           //     println(error!.description);
            }
        });
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
        
   //     submitButton.layer.borderWidth = 1.0
    //    submitButton.layer.cornerRadius = 5
    //    submitButton.layer.borderColor = UIColor.blackColor().CGColor
        
  
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
