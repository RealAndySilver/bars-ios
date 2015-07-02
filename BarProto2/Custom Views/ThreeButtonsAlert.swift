//
//  ThreeButtonsAlert.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 12/1/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol ThreeButtonsAlertDelegate {
    func firstButtonPressedInAlert(alert: ThreeButtonsAlert)
    func secondButtonPressedInAlert(alert: ThreeButtonsAlert)
    func thirdButtonPressedInAlert(alert: ThreeButtonsAlert)
    func fourthButtonPressedInAlert(alert: ThreeButtonsAlert)
    func threeButtonsAlertDidDissapear()
}

class ThreeButtonsAlert: UIView {

    let firstButton: UIButton!
    let secondButton: UIButton!
    let thirdButton: UIButton!
    let titleLabel: UILabel!
    let currentScoreLabel: UILabel!
    var opacityView: UIView!
    var userDidHighScore: Bool = false
    var delegate: ThreeButtonsAlertDelegate?
    var firstButtonTitle: String = "" {
        didSet {
            firstButton.setTitle(firstButtonTitle, forState: .Normal)
        }
    }
    var secondButtonTitle: String = "" {
        didSet {
            secondButton.setTitle(secondButtonTitle, forState: .Normal)
        }
    }
    var thirdButtonTitle: String = "" {
        didSet {
            thirdButton.setTitle(thirdButtonTitle, forState: .Normal)
        }
    }
    
    var message: String = "" {
        didSet {
            titleLabel.text = message
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        //alpha = 0.0
        //transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        let scoreLabel = UILabel(frame: CGRect(x: 25.0, y: 20.0, width: frame.size.width - 50.0, height: 30.0))
        scoreLabel.text = "Score"
        scoreLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last?
        scoreLabel.textAlignment = .Center
        scoreLabel.font = UIFont.systemFontOfSize(17.0)
        addSubview(scoreLabel)
        
        currentScoreLabel = UILabel(frame: CGRect(x: 25.0, y: scoreLabel.frame.origin.y + scoreLabel.frame.size.height, width: frame.size.width - 50.0, height: 35.0))
        //currentScoreLabel.text = "120.000"
        currentScoreLabel.adjustsFontSizeToFitWidth = true
        currentScoreLabel.font = UIFont.boldSystemFontOfSize(30.0)
        currentScoreLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last
        currentScoreLabel.textAlignment = .Center
        addSubview(currentScoreLabel)
        
        titleLabel = UILabel(frame: CGRect(x: 25.0, y: currentScoreLabel.frame.origin.y + currentScoreLabel.frame.size.height, width: frame.size.width - 50.0, height: 110.0))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        firstButton = UIButton(frame: CGRect(x: 30.0, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 10.0, width: frame.size.width - 60.0, height: 40.0))
        firstButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        firstButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        firstButton.titleLabel?.font = UIFont.boldSystemFontOfSize(13.0)
        firstButton.addTarget(self, action: "firstButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(firstButton)
        
        secondButton = UIButton(frame: CGRectOffset(firstButton.frame, 0.0, firstButton.frame.size.height + 10.0))
        secondButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        secondButton.backgroundColor = UIColor(red: 1.0, green: 123.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        secondButton.addTarget(self, action: "secondButtonPressed", forControlEvents: .TouchUpInside)
        secondButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(secondButton)
        
        thirdButton = UIButton(frame: CGRectOffset(secondButton.frame, 0.0, secondButton.frame.size.height + 10.0))
        thirdButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        thirdButton.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        thirdButton.addTarget(self, action: "thirdButtonPressed", forControlEvents: .TouchUpInside)
        thirdButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(thirdButton)
        
        let fourthButton = UIButton(frame: CGRectOffset(thirdButton.frame, 0.0, thirdButton.frame.size.height + 10.0))
        fourthButton.setTitle("Exit Game", forState: .Normal)
        fourthButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fourthButton.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        fourthButton.addTarget(self, action: "fourthButtonPressed", forControlEvents: .TouchUpInside)
        fourthButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(fourthButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    //MARK: Actions
    
    func showInView(theView: UIView) {
        opacityView = UIView(frame: theView.bounds)
        opacityView.backgroundColor = UIColor.blackColor()
        opacityView.alpha = 0.0
        theView.addSubview(opacityView)
        
        theView.addSubview(self)
        
        var newFrame = frame
        newFrame.origin.x = theView.frame.size.width
        frame = newFrame
        
        var middlePosFrame = frame
        middlePosFrame.origin.x = theView.frame.size.width/2.0 - frame.size.width/2.0
        
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                //self.alpha = 1.0
                //self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.frame = middlePosFrame
                self.opacityView.alpha = 0.7
            }) { (success) -> Void in
                if self.userDidHighScore {
                    self.createHighScoreParticles()
                }
        }
    }
    
    func closeAlert() {
        var finalPosFrame = frame
        finalPosFrame.origin.x = -frame.size.width
        
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                //self.alpha = 0.0
                //self.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.frame = finalPosFrame
                self.opacityView.alpha = 0.0
            }) { (success) -> Void in
                if let theDelegate = self.delegate {
                    theDelegate.threeButtonsAlertDidDissapear()
                }
                self.opacityView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    func firstButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.firstButtonPressedInAlert(self)
        }
    }
    
    func secondButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.secondButtonPressedInAlert(self)
        }
    }
    
    func thirdButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.thirdButtonPressedInAlert(self)
        }
    }
    
    func fourthButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.fourthButtonPressedInAlert(self)
        }
    }
    
    func createHighScoreParticles() {
        self.createParticlesAtPosition(CGPoint(x: 0.0, y: 0.0))
        self.createParticlesAtPosition(CGPoint(x: bounds.size.width, y: 0.0))
        self.createParticlesAtPosition(CGPoint(x: 0.0, y: bounds.size.height))
        self.createParticlesAtPosition(CGPoint(x: bounds.size.width, y: bounds.size.height))
        self.createParticlesAtPosition(CGPoint(x: bounds.size.width/2.0, y: 0.0))
        self.createParticlesAtPosition(CGPoint(x: 0.0, y: bounds.size.height/2.0))
        self.createParticlesAtPosition(CGPoint(x: bounds.size.width/2.0, y: bounds.size.height))
        self.createParticlesAtPosition(CGPoint(x: bounds.size.width, y: bounds.size.width/2.0))
    }
    
    func createParticlesAtPosition(position: CGPoint) {
        var particlesView = DWFParticleView(frame: CGRect(x: position.x, y: position.y, width: 40.0, height: 40.0))
        particlesView.center = position
        particlesView.backgroundColor = UIColor.clearColor()
        addSubview(particlesView)
        
        let emittingDelay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(emittingDelay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            particlesView.setIsEmitting(false)
        })
        
        let removeDelay = 3.0 * Double(NSEC_PER_SEC)
        let removeTime = dispatch_time(DISPATCH_TIME_NOW, Int64(removeDelay))
        dispatch_after(removeTime, dispatch_get_main_queue()) { () -> Void in
            particlesView.removeFromSuperview()
            println("Removiendooooooooo")
        }
    }
}
