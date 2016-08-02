//
//  ResultViewController.swift
//  hdsr
//
//  Created by 原田　礼朗 on 2016/07/25.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var pointData: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pointData = PointManager.selectAllPoint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return pointData.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "名前"
        }
        else if section == 1 {
            return "合計ポイント"
        }
        else {
            return "詳細"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            let name = defaults.objectForKey("name") as! String
            cell.textLabel?.text = name
        }
        else if indexPath.section == 1 {
            let sumPoint = PointManager.sumPoint()
            cell.textLabel?.text = "\(sumPoint)"
        }
        else {
            cell.textLabel?.text = "項目\(indexPath.row+1)のポイント：\(pointData[indexPath.row])"
        }
        return cell
    }
    
    @IBAction func oneMoreButton(sender: AnyObject) {
        let vc = navigationController?.childViewControllers[0] as? InputNameViewController
        vc!.name = ""
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func tapSendButton(sender: AnyObject) {
    }
    
}







