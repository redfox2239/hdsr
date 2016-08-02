//
//  PointManager.swift
//  hdsr
//
//  Created by 原田　礼朗 on 2016/07/24.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class PointManager: NSObject {
    
    class func selectAllPoint() -> [Int] {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let pointArray = defaults.objectForKey("pointArray") as? [Int] {
            return pointArray
        }
        return []
    }
    
    class func addPoint(point: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if var pointArray = defaults.objectForKey("pointArray") as? [Int] {
            pointArray.append(point)
            defaults.setObject(pointArray, forKey: "pointArray")
        }
        else {
            defaults.setObject([point], forKey: "pointArray")
        }
        defaults.synchronize()
    }
    
    class func sumPoint() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        var sum = 0
        if let pointArray = defaults.objectForKey("pointArray") as? [Int] {
            pointArray.forEach({ (value) in
                sum += value
            })
        }
        return sum
    }
    
    class func resetPoint() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("pointArray")
        defaults.synchronize()
    }
    
    class func removeIndex(index: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if var pointArray = defaults.objectForKey("pointArray") as? [Int] {
            if index < pointArray.count {
                pointArray.removeAtIndex(index)
                defaults.setObject(pointArray, forKey: "pointArray")
                defaults.synchronize()
            }
        }
    }
    
}
