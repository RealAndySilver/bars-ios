//
//  GameOverAlert.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/24/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol GameOverAlertDelegate {
    func restartButtonPressedInGameOverAlert()
    func exitButtonPressedInAlert()
    func rankingsButtonPressedInAlert()
    func gameOverAlertDidDisappearFromResetting()
}

class GameOverAlert: UIView {
    
    var resetButtonSelected = false
    var opacityView: UIView!
    var barsLabel: UILabel!
    var titleLabel: UILabel!
    var highScoreLabel: UILabel!
    var bestScore: String = "" {
        didSet {
            highScoreLabel.text = bestScore
        }
    }
    var userDidHighScore: Bool = false
    var titleText: String = ""  {
        didSet {
            titleLabel.text = "\(titleText)"
        }
    }
    var delegate: GameOverAlertDelegate?
    
    var score: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        //alpha = 1.0
        //transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        titleLabel = UILabel(frame: CGRect(x: 20.0, y: 30.0, width: frame.size.width/2.0 - 20.0, height: 30.0))
        titleLabel.textColor = UIColor.lightGrayColor()
        //titleLabel.backgroundColor = UIColor.cyanColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        barsLabel = UILabel(frame: CGRectOffset(titleLabel.frame, titleLabel.frame.size.width, 0.0))
        barsLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last
        barsLabel.font = UIFont.boldSystemFontOfSize(25.0)
        barsLabel.adjustsFontSizeToFitWidth = true
        //barsLabel.backgroundColor = UIColor.redColor()
        barsLabel.textAlignment = .Center
        addSubview(barsLabel)
        
        let bestLabel = UILabel(frame: CGRectOffset(titleLabel.frame, 0.0, titleLabel.frame.size.height + 10.0))
        bestLabel.text = "Best"
        bestLabel.textColor = UIColor.lightGrayColor()
        //bestLabel.backgroundColor = UIColor.orangeColor()
        bestLabel.font = UIFont.boldSystemFontOfSize(17.0)
        bestLabel.textAlignment = .Center
        addSubview(bestLabel)
        
        highScoreLabel = UILabel(frame: CGRectOffset(bestLabel.frame, bestLabel.frame.size.width, 0.0))
        highScoreLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last
        highScoreLabel.font = UIFont.boldSystemFontOfSize(25.0)
        highScoreLabel.adjustsFontSizeToFitWidth = true
        highScoreLabel.textAlignment = .Center
        //highScoreLabel.backgroundColor = UIColor.purpleColor()
        addSubview(highScoreLabel)
        
        let restartButton = UIButton(frame: CGRect(x: 20.0, y: bestLabel.frame.origin.y + bestLabel.frame.size.height + 20.0, width: frame.size.width/2.0 - 25.0, height: 40.0))
        restartButton.setTitle("Restart", forState: .Normal)
        restartButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        restartButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        restartButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        restartButton.addTarget(self, action: "restartButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(restartButton)
        
        let rankingsButton = UIButton(frame: CGRectOffset(restartButton.frame, restartButton.frame.size.width + 10.0, 0.0))
        rankingsButton.setTitle("Rankings", forState: .Normal)
        rankingsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rankingsButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        rankingsButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        rankingsButton.addTarget(self, action: "rankingsButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(rankingsButton)
        
        let exitButton = UIButton(frame: CGRectOffset(restartButton.frame, 0.0, restartButton.frame.size.height + 10.0))
        exitButton.center = CGPoint(x: frame.size.width/2.0, y: exitButton.center.y)
        exitButton.setTitle("Exit", forState: .Normal)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        exitButton.addTarget(self, action: "exitButtonPressed", forControlEvents: .TouchUpInside)
        exitButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(exitButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Touches
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("me tocaron")
    }
    
    func updateLabel() {
        barsLabel.text = "\(score)"
    }
    
    //MARK: Actions
    
    func restartButtonPressed() {
        resetButtonSelected = true
        if let theDelegate = delegate {
            theDelegate.restartButtonPressedInGameOverAlert()
            closeAlert()
        }
    }
    
    func rankingsButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.rankingsButtonPressedInAlert()
        }
    }
    
    func closeAlert() {
        var lastPosFrame = frame
        lastPosFrame.origin.x = superview!.frame.size.width
        
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                //self.alpha = 0.0
                //self.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.frame = lastPosFrame
                self.opacityView.alpha = 0.0
        }) { (success) -> Void in
            if let theDelegate = self.delegate {
                if self.resetButtonSelected {
                    theDelegate.gameOverAlertDidDisappearFromResetting()
                }
            }
            self.opacityView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func showInView(theView: UIView) {
        var newFrame = frame
        newFrame.origin.x = -frame.size.width
        frame = newFrame
        
        var middlePosFrame = frame
        middlePosFrame.origin.x = theView.frame.size.width/2.0 - frame.size.width/2.0
        
        
        opacityView = UIView(frame: theView.bounds)
        opacityView.backgroundColor = UIColor.blackColor()
        opacityView.alpha = 0.0
        theView.addSubview(opacityView)
        
        theView.addSubview(self)
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
    
    func exitButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.exitButtonPressedInAlert()
            closeAlert()
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
