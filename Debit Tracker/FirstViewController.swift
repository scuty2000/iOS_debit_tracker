//
//  FirstViewController.swift
//  Debit Tracker
//
//  Created by Luca Scutigliani on 02/05/17.
//  Copyright © 2017 Scuty. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    var debitArray: [String : Double] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calls write function just for debugging
        
        _ = readData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fileCreate() {
    
        // This function creates the file which will store values and check if it already exists
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("data.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath?.absoluteString)!, contents: nil, attributes: nil)
            if created {
                print("\n[DEBUGGING] File created\n")
                _ = readData()
            } else {
                print("\n[ERROR] Couldn't create file for some reason\n")
            }
        } else {
            print("\n[DEBUGGING] File already exists\n")
            _ = readData()
        }
    
    }
    
    func getData() {
        
        
        
    }
    
    func writeData(){
        
        // This function writes data of the dictionary to the json file
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: debitArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
            
            let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
            let jsonFilePath = documentsDirectoryPath.appendingPathComponent("data.json")
            let path : String = (jsonFilePath?.absoluteString)!
            
            _ = try JSONString?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            
            print("[DEBUGGING] Write successfull")
            
            _ = fileCreate()
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func readData(){
        
        //This function reads the data already stored
        
        do {
        
            let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
            let jsonFilePath = documentsDirectoryPath.appendingPathComponent("data.json")
            let path : String = (jsonFilePath?.absoluteString)!
            print("[DEBUGGING] File Path is "+path+"\n")
        
            _ = Bundle.main
            var _:NSError?
            let data:NSData = try NSData(contentsOfFile: path)
            let json:Any = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let nsDictionaryObject = json as? NSDictionary {
                if let debitTempArray = nsDictionaryObject as Dictionary? {
                    debitArray = debitTempArray as! [String : Double]
                    print("[DEBUGGING] JSON file value is:\n",debitArray,"\n")
                }
            }
            else if let nsArrayObject = json as? NSArray {
                if (nsArrayObject as Array?) != nil {
                    //prInt(swiftArray)
                }
            }
            
            var oString : String = ""
            
            if debitArray.isEmpty {
                
                mainLabel.text = "Nessuno ha debiti con te!"
                
            } else {
            
                for (name, money) in debitArray {
                
                    //prInt("\(name) -- \(money)")
                
                    oString += "\(name) ti deve \(money) euro \n"
                
                }
            
                mainLabel.text = oString as String
                print("[DEBUGGING] Saved data:\n\(oString)")
                
            }
            
        } catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        _ = readData()
        
    }
    
}

