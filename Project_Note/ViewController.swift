//
//  ViewController.swift
//  Project_Note
//
//  Created by admin on 04/12/2017.
//  Copyright © 2017 Quattro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "1202xiphone")!)
        
        btn1.layer.cornerRadius = 3
        btn1.layer.borderWidth = 2
        btn1.layer.borderColor = UIColor(red: 0.70, green: 0.47, blue: 0.17, alpha: 1.0).cgColor
        btn1.titleEdgeInsets = UIEdgeInsetsMake(40, 40, 40, 40)
        btn1.tintColor = UIColor(red: 0.70, green: 0.47, blue: 0.17, alpha: 1.0)

        btn2.layer.cornerRadius = 3
        btn2.layer.borderWidth = 2
        btn2.layer.borderColor = UIColor(red: 0.70, green: 0.47, blue: 0.17, alpha: 1.0).cgColor
        btn2.titleEdgeInsets = UIEdgeInsetsMake(40, 40, 40, 40)
        btn2.tintColor = UIColor(red: 0.70, green: 0.47, blue: 0.17, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

