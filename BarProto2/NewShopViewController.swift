//
//  NewShopViewController.swift
//  BarProto2
//
//  Created by Developer on 9/12/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class NewShopViewController: UIViewController {

    @IBOutlet weak var bar100View: UIView!
    @IBOutlet weak var bar250View: UIView!
    @IBOutlet weak var bar600View: UIView!
    @IBOutlet weak var bar1200View: UIView!
    @IBOutlet weak var coin100ImageView: UIImageView!
    @IBOutlet weak var coin250ImageView: UIImageView!
    @IBOutlet weak var coin600ImageView: UIImageView!
    @IBOutlet weak var coin1200ImageView: UIImageView!
    @IBOutlet weak var bars100PriceLabel: UILabel!
    @IBOutlet weak var bars250PriceLabel: UILabel!
    @IBOutlet weak var bars600PriceLabel: UILabel!
    @IBOutlet weak var bars1200PriceLabel: UILabel!
    
    var productsArray: Array<IAPProduct> = []
    var orderedProductsArray: Array<IAPProduct> = []
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transactionFailedReceived", name: "TransactionFailedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidBuyLives:", name: "UserDidSuscribe", object: nil)
        setupUI()
        getProducts()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        //Remove animations 
        coin100ImageView.layer.removeAllAnimations()
        coin250ImageView.layer.removeAllAnimations()
        coin600ImageView.layer.removeAllAnimations()
        coin1200ImageView.layer.removeAllAnimations()
    }
    
    //MARK: Custom Inialization Stuff
    
    func setupUI() {
        bar100View.transform = CGAffineTransformMakeTranslation(0.0, bar100View.frame.size.height)
        bar250View.transform = CGAffineTransformMakeTranslation(0.0, bar250View.frame.size.height)
        bar600View.transform = CGAffineTransformMakeTranslation(0.0, bar600View.frame.size.height)
        bar1200View.transform = CGAffineTransformMakeTranslation(0.0, bar1200View.frame.size.height)
        coin100ImageView.transform = CGAffineTransformMakeTranslation(0.0, view.bounds.size.height - (coin100ImageView.frame.origin.y))
        coin250ImageView.transform = CGAffineTransformMakeTranslation(0.0, view.bounds.size.height - (coin250ImageView.frame.origin.y))
        coin600ImageView.transform = CGAffineTransformMakeTranslation(0.0, view.bounds.size.height - (coin600ImageView.frame.origin.y))
        coin1200ImageView.transform = CGAffineTransformMakeTranslation(0.0, view.bounds.size.height - (coin1200ImageView.frame.origin.y))
    }
    
    //MARK: Actions 
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Animation
    
    func showBars() {
        UIView.animateWithDuration(0.6,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                self.bar100View.transform = CGAffineTransformIdentity
                self.bar250View.transform = CGAffineTransformIdentity
                self.bar600View.transform = CGAffineTransformIdentity
                self.bar1200View.transform = CGAffineTransformIdentity
                self.coin100ImageView.transform = CGAffineTransformIdentity
                self.coin250ImageView.transform = CGAffineTransformIdentity
                self.coin600ImageView.transform = CGAffineTransformIdentity
                self.coin1200ImageView.transform = CGAffineTransformIdentity
        }) { (success) -> Void in
            
        }
    }
    
    func animateCoins() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.repeatCount = Float.infinity
        animation.duration = 5.0
        coin100ImageView.layer.addAnimation(animation, forKey: "rotation")
        coin250ImageView.layer.addAnimation(animation, forKey: "rotation")
        coin600ImageView.layer.addAnimation(animation, forKey: "rotation")
        coin1200ImageView.layer.addAnimation(animation, forKey: "rotation")
        
        var transform3D = CATransform3DIdentity
        transform3D.m34 = 1.0 / 500.0
        coin100ImageView.layer.transform = transform3D
        coin250ImageView.layer.transform = transform3D
        coin600ImageView.layer.transform = transform3D
        coin1200ImageView.layer.transform = transform3D
    }
    
    //MARK: UI Stuff
    
    func updateUI() {
        var product = orderedProductsArray[0]
        bars100PriceLabel.text = product.skProduct.priceAsString(product.skProduct.price)
        
        product = orderedProductsArray[1]
        bars250PriceLabel.text = product.skProduct.priceAsString(product.skProduct.price)
        
        product = orderedProductsArray[2]
        bars600PriceLabel.text = product.skProduct.priceAsString(product.skProduct.price)
        
        product = orderedProductsArray[3]
        bars1200PriceLabel.text = product.skProduct.priceAsString(product.skProduct.price)
    }
    
    //MARK: Actions
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        println("Me tapearooon en la vista \(sender.view?.tag)")
        if let tappedView = sender.view {
            let productToBuy = orderedProductsArray[tappedView.tag - 1]
            buyProduct(productToBuy)
        }
    }
    
    //MARK: In App Purchases
    
    func buyProduct(product: IAPProduct) {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        CPIAPHelper.sharedInstance().buyProduct(product)
    }
    
    func getProducts() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        CPIAPHelper.sharedInstance().requestProductsWithCompletionHandler { (success, products) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if success {
                self.productsArray = products as Array<IAPProduct>
                self.sortProducts()
                self.showBars()
                self.animateCoins()
            }
        }
    }
    
    func sortProducts() {
        orderedProductsArray = productsArray
        
        for index in 0...self.productsArray.count-1 {
            let product = self.productsArray[index]
            if product.skProduct.productIdentifier == "com.iamstudio.bars.coins100" {
                orderedProductsArray[0] = product
                
            } else if product.skProduct.productIdentifier == "com.iamstudio.bars.coins250" {
                orderedProductsArray[1] = product
            }
                
            else if product.skProduct.productIdentifier == "com.iamstudio.bars.coins600" {
                orderedProductsArray[2] = product
            }
                
            else if product.skProduct.productIdentifier == "com.iamstudio.bars.coins1200" {
                orderedProductsArray[3] = product
            }
        }
        updateUI()
    }
    
    //MARK: Notification Handlers
    
    func transactionFailedReceived() {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    func userDidBuyLives(notification: NSNotification) {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
        if let userDic = notification.userInfo {
            if let productBought = userDic["Product"] as? IAPProduct {
                
                if productBought.skProduct.productIdentifier == "com.iamstudio.bars.coins100" {
                    giveCoinsToUser(100)
                    
                } else if productBought.skProduct.productIdentifier == "com.iamstudio.bars.coins250" {
                    giveCoinsToUser(250)
                }
                    
                else if productBought.skProduct.productIdentifier == "com.iamstudio.bars.coins600" {
                    giveCoinsToUser(600)
                }
                    
                else if productBought.skProduct.productIdentifier == "com.iamstudio.bars.coins1200" {
                    giveCoinsToUser(1200)
                }
            }
        }
    }
    
    //MARK: Coins
    
    func giveCoinsToUser(coins: Int) {
        var currentCoins = UserData.sharedInstance().getCoins()
        currentCoins += coins
        UserData.sharedInstance().setCoins(currentCoins)
    }
}


