//
//  ShopViewController.swift
//  BarProto2
//
//  Created by Developer on 5/12/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ShopItemCellDelegate {

    @IBOutlet weak var backButton: UIButton!
    var productsArray: Array<IAPProduct> = []
    var orderedProductsArray: Array<IAPProduct> = []
    let imagesNamesArray = ["Coin100", "Coin250", "Coin600", "Coin1200"]
    var collectionView: UICollectionView!
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transactionFailedReceived", name: "TransactionFailedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidBuyLives:", name: "UserDidSuscribe", object: nil)
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        getProducts()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Custom Initialization Stuff
    
    func setupUI() {
        //Create a CollectionVIew 
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        flowLayout.itemSize = CGSizeMake(view.frame.size.width/2.0 - 5.0, view.frame.size.width/2.0 + 50.0)
        
        collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 80.0, width: view.frame.size.width, height: view.frame.size.height - 70 - (backButton.frame.size.height + 20.0)), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ShopItemCell.self, forCellWithReuseIdentifier: "CellID")
        view.addSubview(collectionView)
    }
    
    func getProducts() {
        CPIAPHelper.sharedInstance().requestProductsWithCompletionHandler { (success, products) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if success {
                self.productsArray = products as Array<IAPProduct>
                self.sortProducts()
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
        collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedProductsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as ShopItemCell
        
        let product = orderedProductsArray[indexPath.item]
        cell.delegate = self
        cell.itemNameLabel.text = product.skProduct.localizedTitle
        cell.itemPrice = product.skProduct.priceAsString(product.skProduct.price)
        cell.itemImage.image = UIImage(named: imagesNamesArray[indexPath.item])
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: Actions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: ShopItemCellDelegate
    
    func buyButtonPressedInCell(cell: ShopItemCell) {
        println("Tocaron el boton de comprar")
        let index = collectionView.indexPathForCell(cell)?.item
        if let productIndex = index {
            let productToBuy = orderedProductsArray[productIndex]
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            CPIAPHelper.sharedInstance().buyProduct(productToBuy)
        }
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
