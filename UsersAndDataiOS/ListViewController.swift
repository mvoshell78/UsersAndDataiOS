//
//  ListViewController.swift
//  UsersAndDataiOS
//
//  Created by Michael Voshell on 8/8/16.
//  Copyright © 2016 Michael Voshell. All rights reserved.
//

import UIKit
import FirebaseAuth

class ListViewController: UIViewController {
    
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
//    var alertController  = UIAlertController()
//    var defaultAction = UIAlertAction()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            if validateForm() {
                FIRAuth.auth()?.signInWithEmail(UsernameField.text!, password: passwordField.text!, completion: { (user, error) in
                    
                    
                    if error == nil{
                        self.passwordField.text = "Signed In"
                        self.UsernameField.text = ""
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("unwindToLogin", sender: self)
                        })
                        
                    } else {
                        let alertController  = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                    
                })
            }

            
            
            
        } else {
            print("Internet connection FAILED")
            alertTheUser("An active connection is required to login, check your internet connection and try again.")
        }
        

        
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
         if Reachability.isConnectedToNetwork() == true {
            
            if validateForm(){
                FIRAuth.auth()?.createUserWithEmail(self.UsernameField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil{
                    self.passwordField.text = "Account Created"
                    self.UsernameField.text = ""
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("unwindToLogin", sender: self)
                    })
                    
                    
                } else {
                    let alertController  = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    }
                })
            }
         } else {
            alertTheUser("An active connection is required to create a new account, check your internet connection and try again.")
        }
    }
    
    func validateForm() -> Bool {
        
        var isValid = true
        
         if self.UsernameField.text == "" || self.passwordField.text == ""{
            
            isValid = false
            alertTheUser("Username and password must not be blank")
        }
        
        if self.UsernameField.text!.rangeOfString(".com") == nil {
            print("no .com")
            if self.UsernameField.text!.rangeOfString(".org") == nil {
                print("no .org")
                if self.UsernameField.text!.rangeOfString(".edu") == nil {
                
                    isValid = false
                    
                     alertTheUser("Username must contain a proper domain name\n .com .org .edu")
                }
            }
        }
        
        if self.UsernameField.text!.rangeOfString("@") == nil {
            
            isValid = false
            
            alertTheUser("Username must contain an @ symbol")
            
            }
        
        if self.passwordField.text == self.passwordField.text?.lowercaseString{
            
            isValid = false
             alertTheUser("Password must contain a capitol letter")
        }
        
        if self.passwordField.text!.rangeOfString("!") == nil {
            print("no !")
            if self.passwordField.text!.rangeOfString("@") == nil {
                print("no @")
                if self.passwordField.text!.rangeOfString("#") == nil {
                    print("no #")
                    if self.passwordField.text!.rangeOfString("$") == nil {
                        print("no $")
                        if self.passwordField.text!.rangeOfString("%") == nil {
                            print("no %")
                            if self.passwordField.text!.rangeOfString("^") == nil {
                                print("no ^")
                                if self.passwordField.text!.rangeOfString("*") == nil {
                                    print("no *")
                    
                                    isValid = false
                    
                                    alertTheUser("Password must contain a special character\n ! @ # $ % ^ & *")
                                }
                           
                            }
                        }
                    }
                }
            }
        }
        print(isValid)
        
        return isValid
    }
    
    func alertTheUser(message: String){
        let alertController  = UIAlertController(title: "Oops", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
