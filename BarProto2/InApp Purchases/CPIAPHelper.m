//
//  CPIAPHelper.m
//  CaracolPlay
//
//  Created by Developer on 4/03/14.
//  Copyright (c) 2014 iAmStudio. All rights reserved.
//

#import "CPIAPHelper.h"
#import "IAPProduct.h"

@interface CPIAPHelper()
@property (strong, nonatomic) NSString *productoComprado;
@end

@implementation CPIAPHelper

-(instancetype)init {
    IAPProduct *hundredCoinsProduct = [[IAPProduct alloc] initWithProductIdentifier:@"com.iamstudio.bars.coins100"];
    IAPProduct *twoHundredCoinsProduct = [[IAPProduct alloc] initWithProductIdentifier:@"com.iamstudio.bars.coins250"];
    IAPProduct *sixHundredCoinsProduct = [[IAPProduct alloc] initWithProductIdentifier:@"com.iamstudio.bars.coins600"];
    IAPProduct *thousanCoinsProduct = [[IAPProduct alloc] initWithProductIdentifier:@"com.iamstudio.bars.coins1200"];
    
    NSMutableDictionary *products = [@{hundredCoinsProduct.productIdentifier : hundredCoinsProduct,
                                       twoHundredCoinsProduct.productIdentifier : twoHundredCoinsProduct,
                                       sixHundredCoinsProduct.productIdentifier : sixHundredCoinsProduct,
                                       thousanCoinsProduct.productIdentifier : thousanCoinsProduct}
                                     mutableCopy];
    if (self = [super initWithProducts:products]) {
        
    }
    return self;
}

+(CPIAPHelper *)sharedInstance {
    static CPIAPHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)notifyStatusForProduct:(IAPProduct *)product
                 transactionID:(NSString *)transactionID
                        string:(NSString *)string {
    NSLog(@"************* TRANSACTION ID :%@", transactionID);
    NSLog(@"************* PRODUCT %@", product);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidSuscribe" object:nil userInfo:@{@"TransactionID": transactionID,
                                                                                                        @"Product" : product}];
}

@end
