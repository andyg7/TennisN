//
//  MainMenuViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/23/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

var opponentSections = ["General", "Groundstrokes", "Serve", "Volleys", "Mental", "Physical", "Tactics"]
var userType = "player"

class MainMenuViewController: UIViewController {
    
    @IBOutlet var generalNotesButton: UIButton!
    @IBOutlet var userSwitch: UISwitch!
    @IBOutlet var listOpponentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.userSetUp()
        generalNotesButton.layer.cornerRadius = 5
        listOpponentsButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func switchPressed(sender: AnyObject) {
        if userType == "coach"{
            userType = "player"
            generalNotesButton.hidden = false
            listOpponentsButton.setTitle("Opponents", forState: UIControlState.Normal)
        } else {
            userType = "coach"
            generalNotesButton.hidden = true
            listOpponentsButton.setTitle("Students", forState: UIControlState.Normal)
        }
    }
    
    func userSetUp() {
        
        if newUser == true {
            
            self.displayAlert("Link sent to " + PFUser.currentUser()!.email!, error: "Please confirm email")
          //  self.displayAlert("For best performance keep iPhone in portrait mode", error: "")
            
            var tempArray = [String]()
            tempArray.append("General")
            tempArray.append("Groundstrokes")
            tempArray.append("Serve")
            tempArray.append("Volleys")
            tempArray.append("Mental")
            tempArray.append("Physical")
            tempArray.append("Tactics")
            
            var userSettings = PFObject(className: "UserSettings")
            userSettings["UserId"] = PFUser.currentUser()?.objectId
            userSettings["OpponentSections"] = tempArray
            userSettings["General"] = ""
            userSettings["Groundstrokes"] = ""
            userSettings["Serve"] = ""
            userSettings["Volleys"] = ""
            userSettings["Mental"] = ""
            userSettings["Physical"] = ""
            userSettings["Tactics"] = ""
            
            userSettings.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
        } else {
            /*
            var currentU = PFUser.currentUser()
            println(currentU)
            
            if var t = currentU!.objectForKey("emailVerified") as? Bool {
                
                if(t == true) {
                    println("email verified")
                } else {
                    println("email not verified")
                    var tempEmail = currentU!.email
                    //   currentU?.email = tempEmail
                    self.displayAlert("Please check email to confirm account", error:"Just in case you ever forget your password")
                    
                }
            } else {
                println("email not verified")
                self.displayAlert("Please check email to confirm account", error:"Just in case you ever forget your password")
            }
            */
        }
    }
    
    func displayAlert(title: String, error: String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            //    self.dismissViewControllerAnimated(true, completion: nil)
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
