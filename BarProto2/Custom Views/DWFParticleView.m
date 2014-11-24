//
//  DWFParticleView.m
//  DrawWithFire
//
//  Created by Marin Todorov on 25/8/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "DWFParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DWFParticleView
{
    CAEmitterLayer* fireEmitter; //1
}

-(void)awakeFromNib
{
    //set ref to the layer
    /*fireEmitter = (CAEmitterLayer*)self.layer; //2
    
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(50, 50);
    fireEmitter.emitterSize = CGSizeMake(10, 10);
    fireEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 200;
    fire.lifetime = 3.0;
    fire.lifetimeRange = 0.5;
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fire.contents = (id)[[UIImage imageNamed:
                          @"Particles_fire.png"] CGImage];
    [fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = @[fire];
    
    fire.velocity = 10;
    fire.velocityRange = 20;
    fire.emissionRange = M_PI_2;

    fire.scaleSpeed = 0.3;
    fire.spin = 0.5;
    fire.birthRate = 0;
    [fireEmitter setValue:
     [NSNumber numberWithInt: 200]
               forKeyPath:@"emitterCells.fire.birthRate"];*/

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //set ref to the layer
        fireEmitter = (CAEmitterLayer*)self.layer; //2
         
         //configure the emitter layer
         fireEmitter.emitterPosition = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
         fireEmitter.emitterSize = CGSizeMake(3, 3);
        fireEmitter.emitterShape = kCAEmitterLayerCircle;
        fireEmitter.renderMode = kCAEmitterLayerAdditive;
        
         CAEmitterCell* fire = [CAEmitterCell emitterCell];
         fire.birthRate = 10.0;
         fire.lifetime = 2.0;
         fire.lifetimeRange = 0.5;
        fire.scale = 0.2;
         fire.color = [[UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:0.5] CGColor];
         fire.contents = (id)[[UIImage imageNamed:
         @"SquareParticle.png"] CGImage];
         [fire setName:@"fire"];
         
         //add the cell to the layer and we're done
         fireEmitter.emitterCells = @[fire];
         
         fire.velocity = 30.0;
         fire.velocityRange = 20;
        fire.emissionRange = M_PI * 2.0;
        fire.alphaSpeed = 0.01;
         fire.scaleSpeed = 0.3;
         fire.spin = 0.5;
         fire.birthRate = 10.0;
 
         /*[fireEmitter setValue:
         [NSNumber numberWithInt: 20]
         forKeyPath:@"emitterCells.fire.birthRate"];*/
    }
    return self;
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    fireEmitter.emitterPosition = [t locationInView:self];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off particles
    [fireEmitter setValue:
     [NSNumber numberWithInt: isEmitting?200:0]
               forKeyPath:@"emitterCells.fire.birthRate"];
}

@end
