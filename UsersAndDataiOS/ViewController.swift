//
//  ViewController.swift
//  UsersAndDataiOS
//
//  Created by Michael Voshell on 8/8/16.
//  Copyright © 2016 Michael Voshell. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class ViewController: UIViewController {
var groceryListArray : [GroceryItem] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (FIRAuth.auth()?.currentUser) == nil{
            
            dispatch_async(dispatch_get_main_queue(), {
               self.performSegueWithIdentifier("listSegue", sender: nil)
            })
            
          
        } else {
            let ref = FIRDatabase.database().reference()
            let currentUser = FIRAuth.auth()?.currentUser
            
            
            if (currentUser?.uid != nil){
                let uuid = currentUser!.uid
                 print(uuid)
                
                ref.child(uuid).observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                     let postDict = snapshot.value as! [AnyObject]
                    
                    let groceryitemDict = postDict[0]
                    if let itemName = groceryitemDict["mGroceryItem"]{
                        let newname = itemName!
                         print(newname)
                    }
                    
                    let itemQty = groceryitemDict["mQty"]
                   
                    print(itemQty)
                     let returnedGroceryList : GroceryItem = GroceryItem();
                    
                    for index in 0...postDict.count - 1{
                        
                        let groceryitemDict = postDict[index]
                        
                        if let itemName = groceryitemDict["mGroceryItem"]{
                        
                        
                            returnedGroceryList.groceryItem = itemName! as! String
                           
                        }
                        
                        if let itemQty = groceryitemDict["mQty"]{
                           
                            returnedGroceryList.qty = itemQty! as! Int
                          
                        }
                        
                      self.groceryListArray.append(returnedGroceryList)
                       
                    }
                    
                

                    
                    
                 
                    
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })
                
//                ref.child(uuid).observeEventType(.Value, withBlock: { (snap :FIRDataSnapshot) in
//                  self.groceryList = (snap.value)! as! [GroceryItem]
//                   })
            }
            
           
            
             //let uid = currentUser["uid"] as? String
            
         
            
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
     
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "listSegue" {
            
        }
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        try! FIRAuth.auth()?.signOut()
        if (FIRAuth.auth()?.currentUser) == nil{
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("listSegue", sender: nil)
            })
            
            
        } else {
            
        }
        
    }
    
    @IBAction func backButton ( segue : UIStoryboardSegue)
    {
        
    }
   
}

