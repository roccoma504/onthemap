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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a tap gesture recongizer to dismiss the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Set up the delegates.
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;
        
        // Disable the login button until the user has put in data.
        loginButton.enabled = false;
    }
    
    @IBAction func loginButtonPress(sender: AnyObject) {
        
        // Define a local username and password based on the user input.
        // This is to make the API request a little cleaner.
        let userName = usernameTextField.text
        let passWord = passwordTextField.text
        
        let loginOperations = NetworkingOperations(errorPresent: false)
        loginOperations.login(userName!, passWord: passWord!) { (result) -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.userID = userName!
            self.performSegueWithIdentifier("loginToMapSegue", sender: nil)
        }
    }
    
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
            loginButton.enabled = true;
        }
    }
}

