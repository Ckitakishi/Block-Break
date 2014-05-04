//
//  BallView.h
//  collision
//
//  Created by OurEDA on 14-3-19.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIView
{
    CGPoint direction;
    CGPoint speed;
}
-(void)ballPosition;
@end
