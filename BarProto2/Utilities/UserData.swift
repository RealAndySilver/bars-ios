//
//  UserData.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/25/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class UserData: NSObject {
    
    class func sharedInstance() -> UserData {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: UserData? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = UserData()
        })
        return Static.instance!
    }
    
    //Setters
    
    func setScore(score: Int) {
        NSUserDefaults.standardUserDefaults().setObject(score, forKey: "score")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setTotalTouches(totalTouches: Int) {
        NSUserDefaults.standardUserDefaults().setObject(totalTouches, forKey: "totalTouches")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setBarsCompleted(barsCompleted: Int) {
        NSUserDefaults.standardUserDefaults().setObject(barsCompleted, forKey: "barsCompleted")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setGamesLost(gamesLost: Int) {
        NSUserDefaults.standardUserDefaults().setObject(gamesLost, forKey: "gamesLost")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setExpertScore(expertScore: Int) {
        NSUserDefaults.standardUserDefaults().setObject(expertScore, forKey: "expertScore")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //Getters 
    
    func getScore() -> Int {
        let score = NSUserDefaults.standardUserDefaults().objectForKey("score") as Int?
        if let theScore = score {
            //The score int exists
            return theScore
        } else {
            return 0
        }
    }
    
    func getExpertScore() -> Int {
        let score = NSUserDefaults.standardUserDefaults().objectForKey("expertScore") as Int?
        if let theScore = score {
            //The expert score int exist
            return theScore
        } else {
            return 0
        }
    }
    
    func getTotalTouches() -> Int {
        let totalTouches = NSUserDefaults.standardUserDefaults().objectForKey("totalTouches") as Int?
        if let theTouches = totalTouches {
            //The touches int exists
            return theTouches
        } else {
            return 0
        }
    }
    
    func getBarsCompleted() -> Int {
        let barsCompleted = NSUserDefaults.standardUserDefaults().objectForKey("barsCompleted") as Int?
        if let theBarsCompleted = barsCompleted {
            //The bars completed int exist
            return theBarsCompleted
        } else {
            return 0
        }
    }
    
    func getGamesLost() -> Int {
        let gamesLost = NSUserDefaults.standardUserDefaults().objectForKey("gamesLost") as Int?
        if let theGamesLost = gamesLost {
            //The games lost int exist 
            return theGamesLost
        } else {
            return 0
        }
    }
}
