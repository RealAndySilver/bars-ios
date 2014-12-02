//
//  SKProduct+PriceAsString.h
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 12/2/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (PriceAsString)
-(NSString *)priceAsString:(NSDecimalNumber *)price;
@end
