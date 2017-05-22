//
//  ViewController.swift
//  CheckAnimation
//
//  Created by Trevis Thomas on 3/10/17.
//  Copyright © 2017 Trevis Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkMark: CheckMarkView!
    
    @IBOutlet weak var magnifierView: SearchButton!
    @IBAction func tappedAction(_ sender: Any) {
        checkMark.checked(!checkMark.isChecked, animated: true)
    }
    
    @IBAction func tappedMagnifierAction(_ sender: Any) {
        print("Magnify")
        magnifierView.toggle()
    }
    
    @IBOutlet weak var mySwitch: UISwitch!
    @IBAction func performSwitch(_ sender: UISwitch) {
        checkMark.checked(sender.isOn, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMark.checked(mySwitch.isOn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

