//
//  BuyCoinsView.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 12/2/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol BuyCoinsViewDelegate {
    func UserBoughtCoinsSuccessfully(totalCoins: Int)
}

class BuyCoinsView: UIView {
    
    //var opacityView: UIView!
    var delegate: BuyCoinsViewDelegate?
    var productsArray: Array<IAPProduct>! {
        didSet {
            updateUI()
        }
    }
    var buyButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transactionFailedReceived", name: "TransactionFailedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidBuyLives", name: "UserDidSuscribe", object: nil)
        
        let titleLabel = UILabel(frame: CGRect(x: 20.0, y: 20.0, width: frame.size.width - 40.0, height: 70.0))
        titleLabel.text = "You don't have enough coins! Would you like to buy some?"
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFontOfSize(18.0)
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        let coinImageView = UIImageView(frame: CGRect(x: frame.size.width/2.0 - 50.0, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 20.0, width: 100.0, height: 100.0))
        coinImageView.layer.cornerRadius = coinImageView.bounds.size.width/2.0
        coinImageView.image = UIImage(named: "Coin")
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .ScaleAspectFit
        //coinImageView.backgroundColor = UIColor.cyanColor()
        addSubview(coinImageView)
        
        buyButton = UIButton(frame: CGRect(x: 20.0, y: coinImageView.frame.origin.y + coinImageView.frame.size.height + 20.0, width: frame.size.width - 40.0, height: 40.0))
        buyButton.backgroundColor = AppColors.sharedInstance().getPatternColors().first?.last
        buyButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        buyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buyButton.addTarget(self, action: "buyCoins", forControlEvents: .TouchUpInside)
        addSubview(buyButton)
        
        let dontBuyButton = UIButton(frame: CGRectOffset(buyButton.frame, 0.0, buyButton.frame.size.height + 10.0))
        dontBuyButton.setTitle("Don't Buy", forState: .Normal)
        dontBuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        dontBuyButton.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        dontBuyButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        dontBuyButton.addTarget(self, action: "closeAlert", forControlEvents: .TouchUpInside)
        addSubview(dontBuyButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showInView(theView: UIView) {
        theView.addSubview(self)
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.alpha = 1.0
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
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
            }) { (success) -> Void in
                NSNotificationCenter.defaultCenter().removeObserver(self)
                self.removeFromSuperview()
        }
    }
    
    func buyCoins() {
        if let productToBuy = productsArray.first {
            MBProgressHUD.showHUDAddedTo(self, animated: true)
            CPIAPHelper.sharedInstance().buyProduct(productToBuy)
        }
    }
    
    func updateUI() {
        if let product = productsArray.first {
            let buttonTitle = "\(product.skProduct.localizedTitle) / \(product.skProduct.priceAsString(product.skProduct.price))"
            buyButton.setTitle(buttonTitle, forState: .Normal)
        }
    }
    
    //MARK: Notification Handlers 
    
    func transactionFailedReceived() {
        MBProgressHUD.hideAllHUDsForView(self, animated: true)
        println("Fallo la transaccion")
    }
    
    func userDidBuyLives() {
        MBProgressHUD.hideAllHUDsForView(self, animated: true)
        println("las monedas se compraron correctamente")
        
        //Save the lives in the UserData object 
        var currentCoins = UserData.sharedInstance().getCoins()
        currentCoins += 5
        UserData.sharedInstance().setCoins(currentCoins)
        
        if let theDelegate = delegate {
            theDelegate.UserBoughtCoinsSuccessfully(currentCoins)
        }
        
        closeAlert()
    }
}
