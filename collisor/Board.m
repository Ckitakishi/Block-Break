//
//  Board.m
//  collision
//
//  Created by OurEDA on 14-3-19.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "Board.h"

@implementation Board

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(460, 670, 120, 20)];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        self.userInteractionEnabled=YES;
    }
    return self;
}
@end
