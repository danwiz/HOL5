//
//  ViewController.swift
//  HOL5
//
//  Created by Mark Hawkins on 2/4/20.
//  Copyright © 2020 Revature. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var printFruits: UIButton!
    @IBOutlet var insertFruits: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//=========================================================================================
    //Button Functions
//=========================================================================================
    
    //Function call for button to show list
    @IBAction func printFruitList () {
        let fruits: [String]? = getPlist(withName: "Fruits")
        
        showListMessage(controller: self, fruitList: fruits!, seconds: 5)
    }
    
    //Function call for button to insert Fruit into list
    @IBAction func insertFruitList () {
        addListAlert(controller: self)
    }
    

//=========================================================================================
    //Alert Functions
//=========================================================================================
    //Create an alert message that takes in a list of strings and display it for X seconds
    func showListMessage (controller: UIViewController, fruitList: [String], seconds: Double) {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        for s in fruitList {
            alert.message! += s + "\n"
        }
        
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 25
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) { alert.dismiss(animated: true)
        }
    }
    
//------------------------------------------------------------------------------------------
    //Create an alert to take in a name for a fruit and add it to the list
    func addListAlert (controller: UIViewController) {
        let alert = UIAlertController(title: "Fruit Adder", message: "Add a fruit to the list.", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            action in
            if let fruitName = alert.textFields?.first?.text {
                if !fruitName.isEmpty {
                    //Add the text taken from user and add it to list
                    self.addToList(listItemName: fruitName)
                }
            }
        }))
        
        controller.present(alert, animated: true)
    }
    
//=======================================================================================
    //List gathering and storing
//=======================================================================================
    //Reading a pList with Swift
    func getPlist(withName name: String)-> [String]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {
                return(try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }
        
        return nil
    }

//------------------------------------------------------------------------------------------
    //Add a single item to plist
    //Uses a relative path to find the applicaiton and then finds the file
    //This writes to the buffer, so it does not save. Not sure why
    //Requires Research
    func addToList (listItemName listItem: String) {
        var list: [String]? = getPlist(withName: "Fruits")
        let encoder = PropertyListEncoder()
        
        list?.append(listItem)
        
        encoder.outputFormat = .xml
        
        //Relative path for application and then appends the file location
        let path = Bundle.main.bundleURL.appendingPathComponent("Fruits.plist")
        
        do {
            let data = try encoder.encode(list)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
    
//=======================================================================================
    //Code not used. Only for example
    //Reading a list with the codable keyword (Auto Serialization/Deserialization)
/*    struct Fruit: Codable {
        var item0:String
        var item1:String
        var item2:String
        
    }
    
    func getPrintPListCodable (){
        if let path = Bundle.main.path(forResource: "Fruits", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let fruits = try? PropertyListDecoder().decode(Fruit.self, from: xml) {
                print(fruits.item0)
        }
    }

//=======================================================================================
    //Writing data into pList
    //Uses a direct path to find the file is wants to write to
    func writeIntoPList () {
        let fruit = Fruit(item0: "apple", item1: "banana", item2: "orange")
        let encoder = PropertyListEncoder()
        
        encoder.outputFormat = .xml
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Fruits.plist")
        
        do {
            let data = try encoder.encode(fruit)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
*/
}
