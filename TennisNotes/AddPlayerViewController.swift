//
//  AddPlayerViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/24/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

class AddPlayerViewController: UIViewController {

    @IBOutlet var opponentName: UITextField!
    @IBOutlet var generalNotes: UITextView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        generalNotes.layer.borderColor = UIColor.blackColor().CGColor
        generalNotes.layer.borderWidth = 1
        generalNotes.layer.cornerRadius = 5
        
        generalNotes.editable = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPlayerButtonPressed(sender: AnyObject) {
        var tempName = opponentName.text
        if isValidInput(tempName) {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var opponents = PFObject(className:"Opponents")
            self.initializeSections(opponents, name: tempName)
            
            opponents.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if (success) {
                    // The object has been saved.
                    self.clearAllFields()
                } else {
                    // There was a problem, check error.description
                    self.clearAllFields()
                }
            }
        }

    }
    @IBAction func addPlayerPressed(sender: AnyObject) {
        
    }
    
    func initializeSections(object: PFObject, name: String){
        object["Follower"] = PFUser.currentUser()!.username
        object["OpponentFollowed"] = name
        object["General"] = generalNotes.text
        object["Groundstrokes"] = ""
        object["Serve"] = ""
        object["Volleys"] = ""
        object["Mental"] = ""
        object["Physical"] = ""
        object["Tactics"] = ""
        
        object["TypeFollower"] = userType
        
    }
    
    func isValidInput(oppInput: String) -> Bool{
        
        if oppInput != "" {
            return true
        } else {
            return false
        }
    }
    
    func clearAllFields(){
        self.opponentName.text = ""
        generalNotes.text = ""
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
