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
}

class GameOverAlert: UIView {
    
    var opacityView: UIView!
    var barsLabel: UILabel!
    var delegate: GameOverAlertDelegate?
    
    var score: Int = 0 {
        didSet {
            println("Me setearoonnnnnnn")
            updateLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        let titleLabel = UILabel(frame: CGRect(x: 20.0, y: 10.0, width: frame.size.width - 40.0, height: 30.0))
        titleLabel.text = "Score"
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(25.0)
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        barsLabel = UILabel(frame: CGRect(x: 10.0, y: frame.size.height/2.0 - 25.0, width: frame.size.width - 20.0, height: 50.0))
        barsLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last
        barsLabel.font = UIFont.boldSystemFontOfSize(40.0)
        barsLabel.textAlignment = .Center
        addSubview(barsLabel)
        
        let restartButton = UIButton(frame: CGRect(x: frame.size.width/2.0 - 35.0, y: frame.size.height - 50.0, width: 70.0, height: 40.0))
        restartButton.setTitle("Restart", forState: .Normal)
        restartButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        restartButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        restartButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        restartButton.addTarget(self, action: "restartButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(restartButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("me tocaron")
    }
    
    func updateLabel() {
        barsLabel.text = "\(score)"
    }
    
    func restartButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.restartButtonPressedInGameOverAlert()
            closeAlert()
        }
    }
    
    func closeAlert() {
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.alpha = 0.0
                self.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.opacityView.alpha = 0.0
        }) { (success) -> Void in
            self.opacityView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func showInView(theView: UIView) {
        opacityView = UIView(frame: theView.bounds)
        opacityView.backgroundColor = UIColor.blackColor()
        opacityView.alpha = 0.0
        theView.addSubview(opacityView)
        
        theView.addSubview(self)
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.alpha = 1.0
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.opacityView.alpha = 0.7
        }) { (success) -> Void in
            
        }
    }
}
