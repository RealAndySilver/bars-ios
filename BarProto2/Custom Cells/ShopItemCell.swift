//
//  ShopItemCell.swift
//  BarProto2
//
//  Created by Developer on 5/12/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

protocol ShopItemCellDelegate {
    func buyButtonPressedInCell(cell: ShopItemCell)
}

class ShopItemCell: UICollectionViewCell {
    
    var itemNameLabel: UILabel!
    var itemImage: UIImageView!
    var itemButton: UIButton!
    var delegate: ShopItemCellDelegate?
    var itemPrice: String = "" {
        didSet {
            itemButton.setTitle("Buy - \(itemPrice)", forState: .Normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemNameLabel = UILabel()
        itemNameLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
        itemNameLabel.textAlignment = .Center
        itemNameLabel.font = UIFont.systemFontOfSize(18.0)
        itemNameLabel.hidden = true
        contentView.addSubview(itemNameLabel)
        
        itemImage = UIImageView()
        itemImage.contentMode = .ScaleAspectFit
        itemImage.clipsToBounds = true
        //itemImage.backgroundColor = UIColor.purpleColor()
        contentView.addSubview(itemImage)
        
        itemButton = UIButton()
        itemButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        itemButton.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        itemButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        itemButton.addTarget(self, action: "buyButtonPressed", forControlEvents: .TouchUpInside)
        contentView.addSubview(itemButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        itemNameLabel.frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 30.0)
        itemImage.frame = CGRect(x: 20.0, y: itemNameLabel.frame.origin.y + itemNameLabel.frame.size.height + 10.0, width: bounds.size.width - 40.0, height: bounds.size.width - 40.0)
        itemImage.layer.cornerRadius = itemImage.bounds.size.width/2.0
        itemButton.frame = CGRect(x: 20.0, y: itemImage.frame.origin.y + itemImage.frame.size.height + 10.0, width: bounds.size.width - 40.0, height: 30.0)
    }
    
    //MARK: Actions 
    
    func buyButtonPressed() {
        if let theDelegate = delegate {
            theDelegate.buyButtonPressedInCell(self)
        }
    }
}
