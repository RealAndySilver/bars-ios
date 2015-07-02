//
//  ViewController.swift
//  BarProto2
//
//  Created by Developer on 18/11/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activeBarIndex = 0;
    var gameTimer: NSTimer!
    var activeBar: UIView!
    let kBarInitialSpeed: CGFloat = 6.0
    var barSpeed: CGFloat = 4.0;
    var containerView: UIView!
    let kNumberOfBars = 10
    var currentBarScreen = 1
    let velocitiesArray = [6, 2, 8, 4, 5, 2, 4, 1, 5, 7]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activeBarIndex++
        startGame()
    }
    
    func setupUI() {
        let barWidth = view.bounds.size.width/5.0
        
        //containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: barWidth * CGFloat(kNumberOfBars), height: view.bounds.size.height))
        //view.addSubview(containerView)
        
        //Create the 10 bars views and the 10 objective rects
        for i in 0...kNumberOfBars - 1 {
            let initialPosX: CGFloat = CGFloat(i) * barWidth
            var barView = UIView(frame: CGRect(x: initialPosX, y: 500.0, width: barWidth, height: view.bounds.size.height))
            barView.backgroundColor = UIColor.cyanColor()
            barView.layer.borderColor = UIColor.whiteColor().CGColor
            barView.layer.borderWidth = 1.0
            barView.tag = i + 1
            view.addSubview(barView)
            
            //Objective Rect 
            let randomHeight = Int(arc4random()%400) + 60
        
            let objectiveView = UIView(frame: CGRect(x: initialPosX, y: CGFloat(randomHeight), width: barWidth, height: 20.0))
            objectiveView.backgroundColor = UIColor.clearColor()
            objectiveView.layer.borderColor = UIColor.whiteColor().CGColor
            objectiveView.layer.borderWidth = 1.0
            objectiveView.tag = 1001 + i
            view.addSubview(objectiveView)
            view.bringSubviewToFront(barView)
            
            //Bar velocity label 
            let barVelocityLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: barView.frame.size.width, height: 30.0))
            barVelocityLabel.backgroundColor = UIColor.clearColor()
            barVelocityLabel.textColor = UIColor.whiteColor()
            barVelocityLabel.font = UIFont.systemFontOfSize(16.0)
            barVelocityLabel.textAlignment = NSTextAlignment.Center
            barVelocityLabel.text = "\(velocitiesArray[i])X"
            barView.addSubview(barVelocityLabel)
            
            //Create the image views to display the won or loss image 
            /*let resultsImageView = UIImageView(frame: CGRect(x: initialPosX + 15.0, y: view.bounds.size.height - 50.0, width: 30.0, height: 30.0))
            resultsImageView.hidden = true
            resultsImageView.tag = 5001 + i
            containerView.addSubview(resultsImageView)*/
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*activeBarIndex++;
        
        if (touches.count == 1) {
            startGame()
        }*/
        activeBarIndex++;
        stopTimer()
        startGame()
        
        if (activeBarIndex % 5 == 1) {
            //If the user ended moving a set of 5 bars, animate and show the new bars
            animateBarsHorizontally()
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //stopTimer()
        //checkIfUserWon()
    }
    
    func stopTimer() {
        gameTimer.invalidate()
    }
    
    func startGame() {
        barSpeed = CGFloat(velocitiesArray[activeBarIndex - 1])
        
        //Get the bar that is going to be transform 
        activeBar = containerView.viewWithTag(activeBarIndex)
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: "moveBar", userInfo: nil, repeats: true)
    }
    
    func moveBar() {
        activeBar.transform = CGAffineTransformMakeTranslation(0.0, -barSpeed)
        barSpeed += CGFloat(velocitiesArray[activeBarIndex - 1])
    }
    
    func checkIfUserWon() {
        /*if let objectiveRect = containerView.viewWithTag(1000 + activeBarIndex) {
            //Get a reference to the results image view 
            let resultsImageView = containerView.viewWithTag(5000 + activeBarIndex)
            resultsImageView?.hidden = false
            
            if objectiveRect.frame.contains(activeBar.frame.origin) {
                resultsImageView?.backgroundColor = UIColor.greenColor()
                println("Ganaste")
            } else {
                resultsImageView?.backgroundColor = UIColor.redColor()
                println("Perdiste")
            }
            
            if (activeBarIndex % 5 == 0) {
                //If the user ended moving a set of 5 bars, animate and show the new bars
                animateContainerHorizontally()
            }
        }*/
    }
    
    func animateBarsHorizontally() {
        UIView.animateWithDuration(0.7,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.containerView.transform = CGAffineTransformMakeTranslation(-(self.view.bounds.size.width * CGFloat(self.currentBarScreen)), 0.0)
        }) { (success) -> Void in
            self.currentBarScreen += 1
        }
    }
}

