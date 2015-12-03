//
//  LoginViewController.swift
//  onthemap
//
//  Created by Matthew Rocco on 11/22/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a tap gesture recongizer to dismiss the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Set up the delegates.
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;
        
        // Disable the login button until the user has put in data.
        loginButton.hidden = true;
        loginButton.backgroundColor = UIColor.whiteColor()
        loginButton.layer.borderWidth = 1
        loginButton.alpha = 0.5
        loginButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func loginButtonPress(sender: AnyObject) {
        
        activityView.startAnimating()
        
        if emailValid() {
            
            // Define a local username and password based on the user input.
            // This is to make the API request a little cleaner.
            let userName = usernameTextField.text
            let passWord = passwordTextField.text
            
            // Perform the login procedure. If the login fails, display the
            // alert to the user.
            let loginOperations = NetworkingOperations(alertPresent : false)
            loginOperations.login(userName!, passWord: passWord!) { (result) -> Void in
                
                self.stopActivityView()
                
                if !loginOperations.alertPreset() {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.userID = userName!
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("loginToMapSegue", sender: nil)}
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),{
                        let alertController = UIAlertController(title: "Error!", message:
                            loginOperations.getAlert(), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss",
                            style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController,animated: true,completion: nil)
                    })
                }
            }
        }
        else {
            self.stopActivityView()
            dispatch_async(dispatch_get_main_queue(),{
                let alertController = UIAlertController(title: "Error!", message:
                    "Your entry appears invalid. Try again!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss",
                    style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController,animated: true,completion: nil)
            })
        }
    }
    
    // Shows the Udacity signup page.
    @IBAction func signUpPress(sender: AnyObject) {
        let signUpObject = SafariObject()
        signUpObject.openPage("https://www.udacity.com/account/auth#!/signup")
    }
    
    override func viewDidAppear(animated: Bool) {
        // Add an observer.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Remove all observers.
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: view.window)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if passwordTextField.editing {
            loginButton.hidden = false;
        }
    }
    
    // This function checks to see if the entry is valid before posting
    // the request. This cuts down on server requests for invalid entries.
    func emailValid() -> Bool {
        return (usernameTextField.text?.containsString("@"))! &&
            self.usernameTextField.text != "" &&
            self.passwordTextField.text != ""
        
    }
    
    // This function stops the activity view.
    func stopActivityView() {
        dispatch_async(dispatch_get_main_queue(),{
            self.activityView.stopAnimating()})
    }
}

