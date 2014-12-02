//
//  SKProduct+PriceAsString.m
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 12/2/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

#import "SKProduct+PriceAsString.h"

@implementation SKProduct (PriceAsString)

-(NSString *)priceAsString:(NSDecimalNumber *)price {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = [NSLocale currentLocale];
    NSString *formattedPrice = [formatter stringFromNumber:price];
    formatter = nil;
    return formattedPrice;
}

@end
