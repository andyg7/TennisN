//
//  OppSelectedShotViewController.swift
//  TennisNotes
//
//  Created by Andrew Grant on 6/24/15.
//  Copyright (c) 2015 Andrew Grant. All rights reserved.
//

import UIKit
import Parse

class OppSelectedShotViewController: UIViewController {

    @IBOutlet var shot: UILabel!
    @IBOutlet var notes: UITextView!
    @IBOutlet var doneEditButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        doneEditButton.hidden = true
        doneEditButton.layer.cornerRadius = 5
        notes.editable = false
        
        shot.text = opponentSections[shotSelected]
        
        var tempId = opponentsID[rowSelected]
        
        var query = PFQuery(className:"Opponents")
        query.getObjectInBackgroundWithId(tempId) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                println(object)
                var tem = object!.valueForKey(self.shot.text!)
                self.notes.text = tem as! String
            } else {
                println(error)
            }
        }
        notes.layer.borderColor = UIColor.blackColor().CGColor
        notes.layer.borderWidth = 1
        notes.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editPressed(sender: AnyObject) {
        doneEditButton.hidden = false
        notes.editable = true
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
        notes.editable = false
        
        var tempId = opponentsID[rowSelected]
        
        var query = PFQuery(className:"Opponents")

        query.getObjectInBackgroundWithId(tempId) {
            (object: PFObject?, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if error != nil {
                println(error)
            } else if let object = object {
                object[self.shot.text!] = self.notes.text
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
