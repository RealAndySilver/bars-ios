//
//  OneButtonAlert.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/28/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol OneButtonAlertDelegate {
    func acceptButtonPressedInAlert(alert: OneButtonAlert)
    func oneButtonAlertDidDissapear(alert: OneButtonAlert)
}

class OneButtonAlert: UIView {

    let acceptButton: UIButton!
    let titleLabel: UILabel!
    var opacityView: UIView!
    var delegate: OneButtonAlertDelegate?
    var acceptButtonTitle: String = "" {
        didSet {
            acceptButton.setTitle(acceptButtonTitle, forState: .Normal)
        }
    }
    
    var message: String = "" {
        didSet {
            titleLabel.text = message
        }
    }
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 20.0, width: frame.size.width - 20.0, height: 60.0))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        
        acceptButton = UIButton(frame: CGRect(x: frame.size.width/2.0 - 45.0, y: frame.size.height - 50.0, width: 90.0, height: 40.0))
        acceptButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        acceptButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        acceptButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        
        super.init(frame: frame)
        acceptButton.addTarget(self, action: "acceptButtonPressed", forControlEvents: .TouchUpInside)
        addSubview(acceptButton)
        addSubview(titleLabel)
        backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Esta clase no soporta NSCoding")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
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
                    theDelegate.oneButtonAlertDidDissapear(self)
                }
                self.opacityView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    func acceptButtonPressed() {
        if let theDelegate =  delegate {
            theDelegate.acceptButtonPressedInAlert(self)
            closeAlert()
        }
    }
}
