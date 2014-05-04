//
//  HomeViewController.h
//  collisor
//
//  Created by OurEDA on 14-4-8.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface HomeViewController : UIViewController<ViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *challenge;
@property (weak, nonatomic) IBOutlet UIButton *score;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;


@end
