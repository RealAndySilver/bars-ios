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
    func threeButtonsAlertDidDissapear()
}

class ThreeButtonsAlert: UIView {

    let firstButton: UIButton!
    let secondButton: UIButton!
    let thirdButton: UIButton!
    let titleLabel: UILabel!
    var opacityView: UIView!
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
        backgroundColor = UIColor.whiteColor()
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: frame.size.width - 20.0, height: 140.0))
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        firstButton = UIButton(frame: CGRect(x: 30.0, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 10.0, width: frame.size.width - 60.0, height: 40.0))
        firstButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        firstButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        firstButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        firstButton.addTarget(self, action: "firstButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(firstButton)
        
        secondButton = UIButton(frame: CGRectOffset(firstButton.frame, 0.0, firstButton.frame.size.height + 10.0))
        secondButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        secondButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        secondButton.addTarget(self, action: "secondButtonPressed", forControlEvents: .TouchUpInside)
        secondButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(secondButton)
        
        thirdButton = UIButton(frame: CGRectOffset(secondButton.frame, 0.0, secondButton.frame.size.height + 10.0))
        thirdButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        thirdButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        thirdButton.addTarget(self, action: "thirdButtonPressed", forControlEvents: .TouchUpInside)
        thirdButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(thirdButton)
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
    
    func closeAlert() {
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.alpha = 0.0
                self.transform = CGAffineTransformMakeScale(0.5, 0.5)
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
}
