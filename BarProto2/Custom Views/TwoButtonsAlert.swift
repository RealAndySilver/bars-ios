//
//  TwoButtonsAlert.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/25/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol TwoButtonsAlertDelegate {
    func leftButtonPressedInAlert(alert: TwoButtonsAlert)
    func rightButtonPressedInAlert(alert: TwoButtonsAlert)
    func twoButtonsAlertDidDissapear(alert: TwoButtonsAlert)
}

class TwoButtonsAlert: UIView {
    
    let leftButton: UIButton!
    let rightButton: UIButton!
    let titleLabel: UILabel!
    var opacityView: UIView!
    var delegate: TwoButtonsAlertDelegate?
    var leftButtonTitle: String = "" {
        didSet {
            leftButton.setTitle(leftButtonTitle, forState: .Normal)
        }
    }
    var rightButtonTitle: String = "" {
        didSet {
            rightButton.setTitle(rightButtonTitle, forState: .Normal)
        }
    }
    
    var message: String = "" {
        didSet {
            titleLabel.text = message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        //alpha = 0.0
        //transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: frame.size.width - 20.0, height: 140.0))
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        leftButton = UIButton(frame: CGRect(x: 10.0, y: frame.size.height - 50.0, width: frame.size.width/2.0 - 20.0, height: 40.0))
        leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        leftButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        leftButton.addTarget(self, action: "leftButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(leftButton)
        
        rightButton = UIButton(frame: CGRect(x: frame.size.width/2.0 + 10.0, y: frame.size.height - 50.0, width: frame.size.width/2.0 - 20.0, height: 40.0))
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        rightButton.addTarget(self, action: "rightButtonPressed", forControlEvents: .TouchUpInside)
        rightButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(rightButton)
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
        
        var newFrame = frame
        newFrame.origin.y = theView.frame.size.height
        frame = newFrame
        
        var middlePosFrame = frame
        middlePosFrame.origin.y = theView.frame.size.height/2.0 - frame.size.height/2.0
        
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
                
        }
    }
    
    func closeAlert() {
        var finalPosFrame = frame
        finalPosFrame.origin.y = superview!.frame.size.height
        
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                //self.alpha = 0.0
                //self.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.frame = finalPosFrame
                self.opacityView.alpha = 0.0
            }) { (success) -> Void in
                if let theDelegate = self.delegate {
                    theDelegate.twoButtonsAlertDidDissapear(self)
                }
                self.opacityView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    func leftButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.leftButtonPressedInAlert(self)
            //closeAlert()
        }
    }
    
    func rightButtonPressed() {
        println("Right butttonooon")
        if let theDelegate =  delegate {
            theDelegate.rightButtonPressedInAlert(self)
            //closeAlert()
        }
    }
}
