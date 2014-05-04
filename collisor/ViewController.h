//
//  ViewController.h
//  collision
//
//  Created by OurEDA on 14-3-17.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@protocol ViewControllerDelegate <NSObject>
@end
@interface ViewController : UIViewController<UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *blood;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIImageView * replay;
@property (weak, nonatomic) IBOutlet UIImageView * home;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UIButton *Play;
@property (weak, nonatomic) IBOutlet UILabel *Score;
@property (weak, nonatomic) IBOutlet UIView *gameView;

@property (strong, nonatomic) UIView * dropView;
@property (strong, nonatomic) UIDynamicItemBehavior * myBehavior;
@property (strong, nonatomic) UIDynamicAnimator * animator;
@property (strong, nonatomic) UICollisionBehavior * collision;
@property (strong, nonatomic) UIGravityBehavior * gravity;
@property (strong, nonatomic) UIAttachmentBehavior * attachment;

@property (strong, nonatomic) UIPanGestureRecognizer * pan;
@property (strong, nonatomic) NSTimer * myTime;
@property (strong, nonatomic) NSDate * now;
@property (strong, nonatomic) UILabel * myLabel;

@property(nonatomic,weak)id<ViewControllerDelegate>delegate;
@property (readwrite, nonatomic)NSInteger  choosenumber;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)handlePan:(UIPanGestureRecognizer *)pan;
-(void)collisionBoundary;
-(void)collisionadd;
-(void)behavioradd;

@end
