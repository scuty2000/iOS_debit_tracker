//
//  SecondViewController.swift
//  Debit Tracker
//
//  Created by Luca Scutigliani on 02/05/17.
//  Copyright © 2017 Ruffini Fablab. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var debitInput: UITextField!
    @IBOutlet weak var namePicker: UIPickerView!
    @IBOutlet weak var hiddenLabel: UILabel!
    
    var isSelected : String = ""
    var debitArray: [String : Double] = [:]
    var pickerData = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = readData()
        
        self.namePicker.dataSource = self
        self.namePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Hai selezionato: \(pickerData[row])")
        hiddenLabel.text = pickerData[row]
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
            
            print("[DEBUGGING] Write Successfull")
            
            _ = readData()
            
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
                    // print(swiftArray)
                }
            }
            
            pickerData = []
            
            for (name, _) in debitArray {
                
                pickerData += ["\(name)"]
                
            }
            
            self.namePicker.dataSource = self
            self.namePicker.delegate = self
            
        } catch {
            
            print(error.localizedDescription)
            
        }
        
    }

    @IBAction func addButton(_ sender: Any) {
        
        if ((nameInput.text != "Nome") && (debitInput.text != "Debito")){
            
            let name = nameInput.text!
            let debit = Double(debitInput.text!)!
            debitArray["\(String(describing: name))"] = debit
            
            _ = writeData()
            self.view.endEditing(true)
            
        } else {
            
            nameInput.text = "Hai inserito un valore errato!"
            debitInput.text = "Hai inserito un valore errato!"
            self.view.endEditing(true)
            
        }
        
    }
    
    @IBAction func deleteDebit(_ sender: Any) {
        
        let isSelected = hiddenLabel.text!
        
        debitArray[isSelected] = nil
        
        print("--..\(isSelected)..--")
        
        _ = writeData()
        
        _ = readData()
        
    }
}

