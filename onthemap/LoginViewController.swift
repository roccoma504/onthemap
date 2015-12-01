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
        
        // Define the HTTP POST request.
        let request =
        NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(passWord!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        // Define the session.
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, error in
            // If task fails then there was a connection error. Tell the user.
            if error != nil {
                let connectionError = GenerateAlerts(title: "Connection Error!",
                    contents: "There doesn't appear to be an internet connection. Please check your connection.")
                self.presentViewController(connectionError.generateAlert(), animated: true, completion: nil)
                print ("no internet")
                
                return
            }
                // If we could make connection then check the API message.
                // If there is a 403 error then the username or password were wrong.
                // If there is a non 403 error then alert the user that an unknown
                // error occured.
            else {
                let receivedData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                if (NSString(data: receivedData, encoding: NSUTF8StringEncoding)!.containsString("403")) {
                    let loginError = GenerateAlerts(title: "Connection Error!",
                        contents: "There was an issue with your username and/or password! Please try again!")
                    self.presentViewController(loginError.generateAlert(), animated: true, completion: nil)
                    print("connection issue")
                    
                }
                else if (NSString(data: receivedData, encoding: NSUTF8StringEncoding)!.containsString("error")) {
                    let unknownError = GenerateAlerts(title: "Connection Error!",
                        contents: "An unknown error occured.")
                    self.presentViewController(unknownError.generateAlert(), animated: true, completion: nil)
                    print("unknwon error")
                }
                else
                {
                    print(NSString(data: receivedData, encoding: NSUTF8StringEncoding)!)
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.userID = self.usernameTextField.text
                    self.performSegueWithIdentifier("loginToMapSegue", sender: nil)
                }
            }
        }
        task.resume()
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

