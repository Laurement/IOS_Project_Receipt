//
//  GetNotesViewController.swift
//  Project_Note
//
//  Created by admin on 04/12/2017.
//  Copyright © 2017 Quattro. All rights reserved.
//

import UIKit

class GetNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let defaults = UserDefaults.standard
    
    var arrayNotes = [Any]()
    
    @IBOutlet weak var tableV: UITableView!
    
    override func viewWillLayoutSubviews() {
        self.tableV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrayNotes.removeAll()
        if self.defaults.object(forKey: "tt") != nil {
            for data in (self.defaults.object(forKey: "tt") as? NSArray)! {
                let data = data as! NSArray
                //  print(data)
                arrayNotes.append("\(data[1] as! String) \(data[2] as! String)")
            }
        }
        self.tableV.delegate = self
        self.tableV.dataSource = self
        self.tableV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    /*    if self.defaults.object(forKey: "tt") != nil {
            for data in (self.defaults.object(forKey: "tt") as? NSArray)! {
                let data = data as? NSArray
              //  print(data)
                arrayNotes.append("\(data?[1]) \(data?[2])")
            } 
        }
        self.tableV.delegate = self
        self.tableV.dataSource = self
        self.tableV.reloadData()
    */
        
    }

    @IBAction func returnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            var array = [Any]()
            array = self.defaults.object(forKey: "tt") as? NSArray as! [Any]
            array.remove(at: indexPath.row)
            self.defaults.set(array, forKey: "tt")
            arrayNotes.remove(at: indexPath.row)
            self.tableV.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells")! as UITableViewCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5
        cell.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 11)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = arrayNotes[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.defaults.removeObject(forKey: "idSingleNoteDetails")
        let idNote = indexPath.row
        print(idNote)
        self.defaults.set(idNote, forKey: "idSingleNoteDetails")
        self.performSegue(withIdentifier: "showSingleNote", sender: self)
    }
    
}
