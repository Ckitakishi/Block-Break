//
//  BallView.m
//  collision
//
//  Created by OurEDA on 14-3-19.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//1024*768

#import "BallView.h"

@implementation BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(500, 630, 40, 40)];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 20;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        //direction=CGPointMake(-0.5, -0.5);
       // speed=CGPointMake(3, 3);
    }
    return self;
}
-(void)ballPosition
{
    NSLog(@"%f,%f",self.layer.position.x,self.layer.position.y);
}

@end
