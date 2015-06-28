//
//  ViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/23/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

var newUser = false

class ViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var registeredLabel: UILabel!
    @IBOutlet var signUpLabel: UILabel!
    
    var signUpPage = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func signUp(sender: AnyObject) {
        
        var myError = ""
        
        if isValidUsernamePassword(username.text, passW: password.text)=="false"{
            myError = "Please enter a username and password"
        }
        
        if myError != ""{
            displayAlert("Error In Form", error: myError)
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signUpPage == true  {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                user.email = username.text
                user["GeneralNotes"] = ""
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        self.displayAlert("Could not sign up", error: errorString as! String)
                        // Show the errorString somewhere and let the user try again.
                    } else {
                        // Hooray! Let them use the app now.
                        newUser = true
                        self.performSegueWithIdentifier("jumpToMainMenu", sender: self)
                    }
                }
                
            } else {
                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                    (user: PFUser?, error: NSError?) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if user != nil {
                        // Do stuff after successful login.
                        self.performSegueWithIdentifier("jumpToMainMenu", sender: self)
                    } else {
                        // The login failed. Check error to see why.

                        self.displayAlert("Could not log in", error: "Login Failed")
                    }
                }
            }
        }
        
    }
    
    @IBAction func toggleAction(sender: AnyObject) {
        if signUpPage == true {
            signUpPage = false
            signUpLabel.text = "Log in below"
            signUpButton.setTitle("Log in", forState: UIControlState.Normal)
            registeredLabel.text = "Need to register?"
            toggleButton.setTitle("Sign up", forState: UIControlState.Normal)
            
        } else {
            signUpPage = true
            signUpLabel.text = "Sign up below"
            signUpButton.setTitle("Sign up", forState: UIControlState.Normal)
            registeredLabel.text = "Have an account?"
            toggleButton.setTitle("Log in", forState: UIControlState.Normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     //   PFUser.logOut()
     //   println(PFUser.currentUser())
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            println("User auto logging in")
            self.performSegueWithIdentifier("jumpToMainMenu", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidUsernamePassword(userN: String, passW: String) -> String {
        
        if userN == "" || passW == "" {
            return "false"
        }
        
        return "true"
    }
    
    func displayAlert(title: String, error: String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        //    self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

