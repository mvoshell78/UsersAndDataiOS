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



class ViewController: UIViewController, UITableViewDataSource {
    
var groceryListArray : [GroceryItem] = [];
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        if (FIRAuth.auth()?.currentUser) == nil{
            
            dispatch_async(dispatch_get_main_queue(), {
               self.performSegueWithIdentifier("listSegue", sender: nil)
            })
            
          
        } else {
         getThatData()
            
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return groceryListArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        

                cell.textLabel!.text = groceryListArray[indexPath.row].mGroceryItem
                cell.detailTextLabel!.text = String(groceryListArray[indexPath.row].mQty)
      
        
        
        
        return cell
        
        
        
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
    
    @IBAction func addButton(sender: AnyObject) {
      
        if let newItem = itemTextField.text{
            if let newQty = qtyTextField.text{
                if let newInt = Int(newQty) {
                    
                    let newGroceryItem : GroceryItem = GroceryItem();
                    newGroceryItem.mGroceryItem = newItem
                    newGroceryItem.mQty = newInt
                    groceryListArray.append(newGroceryItem)
                    
                    writeToTable()
                    itemTextField.text = ""
                    qtyTextField.text = ""
                }
                
            }
            
        }
        
    }
   
    
    @IBAction func backButton ( segue : UIStoryboardSegue){
      
        getThatData()
    }
    
    
    func getThatData(){
        let ref = FIRDatabase.database().reference()
        let currentUser = FIRAuth.auth()?.currentUser
        
     
      
        
        if (currentUser?.uid != nil){
            let uuid = currentUser!.uid
            //print(uuid)
            
            ref.child(uuid).observeEventType(.Value, withBlock: { snapshot in
                //print(snapshot.value)
                   self.groceryListArray.removeAll()
                
                if let postDict = snapshot.value as? [AnyObject]!{
                    
                    
                    for index in 0...postDict.count - 1{
                        let returnedGroceryList : GroceryItem = GroceryItem();
                        
                        let groceryitemDict = postDict[index]
                        
                        if let itemName = groceryitemDict["mGroceryItem"]{
                            
                            
                            returnedGroceryList.mGroceryItem = itemName! as! String
                            // print(returnedGroceryList.groceryItem)
                            
                        }
                        
                        if let itemQty = groceryitemDict["mQty"]{
                            
                            returnedGroceryList.mQty = itemQty! as! Int
                           
                            
                        }
                        
                        self.groceryListArray.append(returnedGroceryList)
                        
                    }
                    

                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.myTableView.reloadData()
                })
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
            
        }
    }
    
   
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            groceryListArray.removeAtIndex(indexPath.row)
            writeToTable()

            
        }
    }
    
    func writeToTable(){
        let ref = FIRDatabase.database().reference()
        let currentUser = FIRAuth.auth()?.currentUser
        let uuid = currentUser!.uid
        
        
        if (currentUser?.uid != nil){
            
            var newArray : [AnyObject] = []
            
            if groceryListArray.count != 0{
            for index in 0...groceryListArray.count - 1{
                print("count " + String(groceryListArray.count))
                
                let itemName = groceryListArray[index].mGroceryItem
                let itemQty = groceryListArray[index].mQty
                
                let dict = ["mQty" : itemQty, "mGroceryItem" : itemName]
                
                newArray.append(dict)
                
            }
            
            }
            ref.child(uuid).setValue(newArray)
            
            
            
        }
    }
}

