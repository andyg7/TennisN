//
//  GenericSelfViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/24/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

class GenericSelfViewController: UIViewController {

    var section = ""
    
    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var sectionText: UITextView!
    @IBOutlet var doneEditButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        doneEditButton.hidden = true
        doneEditButton.layer.cornerRadius = 5
        sectionText.editable = false
        
        var query = PFQuery(className:"UserSettings")
        var userIdText = PFUser.currentUser()?.objectId
        query.whereKey("UserId", equalTo:userIdText!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.section = opponentSections[selectionG]
                        self.sectionLabel.text = self.section
                        self.sectionText.text =  object[self.section] as! String
                        
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        sectionText.layer.borderColor = UIColor.blackColor().CGColor
        sectionText.layer.borderWidth = 1
        sectionText.layer.cornerRadius = 5
        
    }

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editPressed(sender: AnyObject) {
        doneEditButton.hidden = false
        sectionText.editable = true
    }

    @IBAction func doneEditPressed(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        doneEditButton.hidden = true
        sectionText.editable = false
        
        var query = PFQuery(className:"UserSettings")
        query.whereKey("UserId", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        object[self.section] = self.sectionText.text
                        object.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
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
