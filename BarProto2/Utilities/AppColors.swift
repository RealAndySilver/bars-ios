//
//  AppColors.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/24/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class AppColors: NSObject {
    
    class func sharedInstance() -> AppColors {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AppColors? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = AppColors()
        })
        return Static.instance!
    }
    
    func getObjBarColors() -> Array<UIColor> {
        var objBarColors: Array<UIColor> = []
        
        let plistFilePath = NSBundle.mainBundle().pathForResource("Colors", ofType: "plist")
        if let colorsInfoArray = NSArray(contentsOfFile: plistFilePath!) {
            for index in 0...colorsInfoArray.count - 1 {
                let colorDic = colorsInfoArray[index] as! Dictionary<String, AnyObject>
                let objColorDic = colorDic["objBarColor"] as! Dictionary<String, Int>
                let red = objColorDic["r"]
                let green = objColorDic["g"]
                let blue = objColorDic["b"]
                let objBarColor = UIColor(red: CGFloat(red!)/255.0, green: CGFloat(green!)/255.0, blue: CGFloat(blue!)/255.0, alpha: 1.0)
                objBarColors.append(objBarColor)
            }
        }
        
        return objBarColors
    }
    
    func getPatternColors() -> Array<Array<UIColor>> {
        var patternColors: Array<Array<UIColor>> = []
        
        if let plistFilePath = NSBundle.mainBundle().pathForResource("Colors", ofType: "plist") {
            if let colorsInfoArray = NSArray(contentsOfFile: plistFilePath) {
                for index in 0...colorsInfoArray.count - 1 {
                    let colorDic = colorsInfoArray[index] as! Dictionary<String, AnyObject>
                    let patternArray = colorDic["patternColors"] as! Array<Dictionary<String, Int>>
                    
                    var colorsInPatternArray: Array<UIColor> = []
                    
                    for index2 in 0...patternArray.count - 1 {
                        let patternColorDic = patternArray[index2]
                        let red = patternColorDic["r"]
                        let green = patternColorDic["g"]
                        let blue = patternColorDic["b"]
                        let patternColor = UIColor(red: CGFloat(red!)/255.0, green: CGFloat(green!)/255.0, blue: CGFloat(blue!)/255.0, alpha: 1.0)
                        colorsInPatternArray.append(patternColor)
                    }
                    patternColors.append(colorsInPatternArray)
                }
            }
        }
        return patternColors
    }
}
