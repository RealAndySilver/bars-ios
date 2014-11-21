//
//  ParticlesView.m
//  BarProto2
//
//  Created by Developer on 21/11/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

#import "ParticlesView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ParticlesView {
    CAEmitterLayer *fireEmitter; //1
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Entre acaaaaaaaaa");
        fireEmitter = (CAEmitterLayer *)self.layer;
        fireEmitter.position = CGPointMake(0.0, 0.0);
        fireEmitter.emitterSize = CGSizeMake(20.0, 20.0);
        
        CAEmitterCell *fire = [CAEmitterCell emitterCell];
        if (fire) {
            NSLog(@"si cree el fire");
        } else NSLog(@"No cree el fire");
        fire.birthRate = 200.0;
        fire.lifetime = 3.0;
        fire.lifetimeRange = 0.5;
        fire.color = [UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1].CGColor;
        fire.contents = (id)[[UIImage imageNamed:@"fire.png"] CGImage];
        if (fire.contents) {
            NSLog(@"si existe el contenido");
        } else NSLog(@"No existe el contenido");
        fire.name = @"fire";
        fireEmitter.emitterCells = @[fire];
    }
    return self;
}

+(Class)layerClass {
    return [CAEmitterLayer class];
}

@end
