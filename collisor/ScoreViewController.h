//
//  ScoreViewController.h
//  collisor
//
//  Created by OurEDA on 14-4-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UITableViewController
//@property (strong, nonatomic) IBOutlet UILabel * dateLabel;
//@property (strong, nonatomic) IBOutlet UILabel * scoreLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopBar;
- (IBAction)stop:(id)sender;
//数组存储分数；
@property (nonatomic,strong) NSArray * scoreInfos;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
