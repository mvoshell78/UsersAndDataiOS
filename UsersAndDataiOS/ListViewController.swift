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
    
    var alertController  = UIAlertController()
    var defaultAction = UIAlertAction()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
    @IBAction func loginButton(sender: AnyObject) {
        
        
        if self.UsernameField.text == "" || self.passwordField.text == ""{
          self.alertController  = UIAlertController(title: "Oops", message: "Enter a vaild Username and Password", preferredStyle: .Alert)
            self.defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            self.alertController.addAction(defaultAction)
            
            
        } else {
            FIRAuth.auth()?.signInWithEmail(UsernameField.text!, password: passwordField.text!, completion: { (user, error) in
                
                
                if error == nil{
                    self.passwordField.text = "Signed In"
                    self.UsernameField.text = ""
                    dispatch_async(dispatch_get_main_queue(), {
                       self.performSegueWithIdentifier("unwindToLogin", sender: self)
                    })
                    
                } else {
                    self.alertController  = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    self.alertController.addAction(defaultAction)
                   
                }
                
                
            })
            
        }
        
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
        
        if self.UsernameField.text == "" || self.passwordField.text == ""{
            let alertController  = UIAlertController(title: "Oops", message: "Enter a vaild Username and Password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
           
            
        } else {
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
                    
                }
            })
        }
    }
    


}
