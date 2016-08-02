//
//  InputNameViewController.swift
//  hdsr
//
//  Created by 原田　礼朗 on 2016/07/23.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class InputNameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var name: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        nameTextField.text = name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSendButton(sender: AnyObject) {
        name = nameTextField.text
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(name, forKey: "name")
        defaults.synchronize()
        self.performSegueWithIdentifier("moveViewController", sender: nil)
        nameTextField.resignFirstResponder()
    }
}
