//
//  ScoreViewController.m
//  collisor
//
//  Created by OurEDA on 14-4-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "ScoreViewController.h"
#import "ScoreInfo.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

@synthesize scoreInfos;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

ScoreInfo * infozero;
ScoreInfo * infoi;
ScoreInfo * infoj;
ScoreInfo * info;
ScoreInfo * infomin;
ScoreInfo * infoflag;
NSMutableArray * marray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSManagedObjectContext * context=[self managedObjectContext];
 
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"ScoreInfo"
                                               inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
     NSError * error;
     self.scoreInfos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    for(id obj in scoreInfos)
//    {
//        NSLog(@"here: %@",obj);
//    }
    marray=[[NSMutableArray alloc]initWithArray:scoreInfos];
    infoflag=[marray objectAtIndex:0];
    [self sort:0  right:(int)[scoreInfos count]-1];
    for(int k=0;k<(int)[scoreInfos count];k++)
    {
        info=[marray objectAtIndex:k];
        infomin=[marray objectAtIndex:((int)[scoreInfos count]-1)];
        if([(info.score) intValue]==[(infomin.score) intValue]&& k!=((int)[scoreInfos count]-1))
            [marray replaceObjectAtIndex:k withObject:infoflag];
    }
    

    scoreInfos =marray;
}

-(void)sort:(int)left right:(int)right
{
    if(left<right)
    {
        int i=left,j=right;
        infozero=[marray objectAtIndex:left];
        int x=[(infozero.score)intValue];
        NSLog(@"%@",infozero.score);
        while (i<j)
        {
            infoj=[marray objectAtIndex:j];
            while ((i<j)&& ([(infoj.score)intValue]<=x))
            {
                j--;
                infoj=[marray objectAtIndex:j];
            }
            if(i<j)
            {
                infoi=[marray objectAtIndex:i];
                infoj=[marray objectAtIndex:j];
                [marray replaceObjectAtIndex:i withObject:[marray objectAtIndex:j]];
                i++;
                infoi=[marray objectAtIndex:i];
            }
            infoi=[marray objectAtIndex:i];
            infoj=[marray objectAtIndex:j];
            while ((i<j) && ([(infoi.score)intValue]>x))
            {
                i++;
                infoi=[marray objectAtIndex:i];
            }
            if(i<j)
            {
                infoi=[marray objectAtIndex:i];
                infoj=[marray objectAtIndex:j];
                [marray replaceObjectAtIndex:j withObject:[marray objectAtIndex:i]];
                j--;
                infoj=[marray objectAtIndex:j];
            }
            [marray replaceObjectAtIndex:i withObject:infozero];
                        [self sort:left right:i-1];
            [self sort:i+1 right:right];
        }
    }
}

-(void)stop:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [scoreInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myScore";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel * scoreLabel=(UILabel *)[cell viewWithTag:123];
    UILabel * dateLabel=(UILabel *)[cell viewWithTag:321];
    ScoreInfo * info=[scoreInfos objectAtIndex:indexPath.row];
    scoreLabel.text=info.score;
    dateLabel.text=[[NSString stringWithFormat:@"%@",info.date]substringToIndex:10];
    return cell;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
