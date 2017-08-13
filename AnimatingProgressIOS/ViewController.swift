//
//  ViewController.swift
//  AnimatingProgressIOS
//
//  Created by Tanveer Singh on 13/08/17.
//  Copyright © 2017 Tanveer Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var flag = false

    @IBOutlet var fillView: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animateBtn(_ sender: Any) {
       
        if flag == false {
            fillView .addOldAnimation{ (finished) in
                print("Hello")
            }
            flag = true
        }else{
            fillView .removeAllAnimations()
            flag = false
        }
        
        
    }

}

