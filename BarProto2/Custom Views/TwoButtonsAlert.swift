//
//  TwoButtonsAlert.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/25/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol TwoButtonsAlertDelegate {
    func leftButtonPressedInGameOverAlert()
    func rightButtonPressedInAlert()
    func twoButtonsAlertDidDissapear()
}

class TwoButtonsAlert: UIView {
    
    let leftButton: UIButton!
    let rightButton: UIButton!
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        let titleLabel = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: frame.size.width - 20.0, height: 140.0))
        titleLabel.text = "Bienvenido a Bars! Tendrás que parar cada barra dentro de los pequeños rectángulos. Toca en la pantalla para parar la barra. Entre mas color tenga una barra, mas rápido irá"
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
                    theDelegate.twoButtonsAlertDidDissapear()
                }
                self.opacityView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    func leftButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.leftButtonPressedInGameOverAlert()
            closeAlert()
        }
    }
    
    func rightButtonPressed() {
        println("Right butttonooon")
        if let theDelegate =  delegate {
            theDelegate.rightButtonPressedInAlert()
            closeAlert()
        }
    }
}