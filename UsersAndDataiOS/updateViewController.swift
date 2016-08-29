//
//  updateViewController.swift
//  UsersAndDataiOS
//
//  Created by Michael Voshell on 8/22/16.
//  Copyright © 2016 Michael Voshell. All rights reserved.
//

import UIKit

class updateViewController: UIViewController {

    @IBOutlet weak var groceryItem: UITextField!
    @IBOutlet weak var qty: UITextField!
    
    var groceryListArray : [GroceryItem] = [];
    var newIte : String = ""
    var newerQty : Int = 0
   
    var indexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if groceryListArray.count > 0{
            groceryItem.text = groceryListArray[indexPath!.row].mGroceryItem
            qty.text = String(groceryListArray[indexPath!.row].mQty)
        }
        
      
    }
    
    
    @IBAction func update(sender: AnyObject) {
        if let newItem = groceryItem.text{
            if let newQty = qty.text{
                if let newInt = Int(newQty) {
                    
                    
                    
                    let newGroceryItem : GroceryItem = GroceryItem();
                    newGroceryItem.mGroceryItem = newItem
                    newGroceryItem.mQty = newInt
                    
                    //groceryListArray.removeAtIndex(indexPath!.row)
                   
                    groceryListArray[indexPath!.row] = newGroceryItem
                  
                    print("update " + String(groceryListArray.count))
                    
                    performSegueWithIdentifier("updateSegue", sender: self)
                  
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ViewController{
            let groceryList : ViewController = segue.destinationViewController as! ViewController
            groceryList.groceryListArray = groceryListArray
            print("prepared for seque " + String(groceryListArray.count))
           
        }
    }
    
}
