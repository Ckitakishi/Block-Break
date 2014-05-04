//
//  ViewController.m
//  collision
//
//  Created by OurEDA on 14-3-17.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "Board.h"
#import "ScoreInfo.h"
@interface ViewController ()
@property (strong, nonatomic) BallView * ballView;
@property (strong, nonatomic) Board * board;
@end

@implementation ViewController
@synthesize myImage;
@synthesize blood;
@synthesize Score;
@synthesize Play;
@synthesize ballView;
@synthesize board;
@synthesize dropView;
@synthesize pan;
@synthesize Time;
@synthesize myTime;
@synthesize now;
@synthesize replay;
@synthesize home;
@synthesize myLabel;
@synthesize choosenumber;

//about data
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

int flag; //用于记录砖块数量；
int flag1;//同上
int flag2;//标记游戏次数。。
int score;
int state;//the game state.
int dis[50];
UIView * dp[50];//砖块存在uiview数组中；
NSTimeInterval secondsBetweenTime;//游戏中的时间
NSTimeInterval timeInterval;  //记录每一次球掉了时总共的游戏时间（不包含未游戏的状态）；
//UILabel * myLabel;

-(UIDynamicAnimator *)animator
{
    if(!_animator) _animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
    return _animator;
}
-(UIDynamicItemBehavior * )myBehavior
{
    return _myBehavior;
}

- (UICollisionBehavior * )collision
{
    return _collision;
}
//添加物理属性和速度方向
-(void)behavioradd
{
    self.myBehavior=[[UIDynamicItemBehavior alloc]initWithItems:@[ballView]];
    self.myBehavior.allowsRotation=YES;
    self.myBehavior.density=1.0;
    self.myBehavior.elasticity=1.0;
    self.myBehavior.friction=0.0;
    self.myBehavior.resistance=0.0;
    self.myBehavior.angularResistance=0.0;
    [self.myBehavior  addAngularVelocity:10.0 forItem:ballView];
    [self.myBehavior addLinearVelocity:CGPointMake(-600, -600) forItem:ballView];
    [self.animator addBehavior:self.myBehavior];
    [self.myBehavior addItem:ballView];

}
//添加碰撞特性
-(void)collisionadd
{
    self.collision=[[UICollisionBehavior alloc]initWithItems:@[ballView]];
    self.collision.translatesReferenceBoundsIntoBoundary=YES;
    [self.animator addBehavior:self.collision];
    [self.collision setCollisionDelegate:self];
    
    [self.collision addItem:ballView];

}

- (IBAction)PlayPressed:(id)sender
{
    state = 1;//将游戏状态置为开始，既为1
    [Play setHidden:YES];
    //为球添加dynamicanimation
    [self behavioradd];
    [self collisionadd];
    [self collisionBoundary];
    
    //pangesture
    [self.board addGestureRecognizer:pan];
    
    //游戏时间，每1s检查一次
    myTime=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    now=[[NSDate alloc]init];
}


-(void)timer
{
    NSDate * newnow=[[NSDate alloc]init];
    secondsBetweenTime= [newnow timeIntervalSinceDate:now];
    Time.text=[NSString stringWithFormat:@"%.f",secondsBetweenTime+timeInterval];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
{
    //掉落到某条线下
    if([@"line" isEqual:identifier])
    {
        state=0;
        timeInterval=secondsBetweenTime+timeInterval;
        [Play setHidden:NO];
        [self.animator removeAllBehaviors];
        [ballView setCenter:CGPointMake(520, 650)];
        [board setCenter:CGPointMake(520, 680)];
        flag2++;
        blood.text=[NSString stringWithFormat:@"%d",(3-flag2)];
        
//        [self.board removeGestureRecognizer:pan];
//        [self.board addGestureRecognizer:pan];
        
        myLabel=[[UILabel alloc]initWithFrame:CGRectMake(280, 100, 500, 300)];
        if(flag2==3)
        {
            myLabel.text=@"Game Over!";
            [Play setHidden:YES];
            [self choose];
            [self.board removeGestureRecognizer:pan];
            
            NSManagedObjectContext * context=[self managedObjectContext];
            ScoreInfo * scoreinfo=[NSEntityDescription
                                   insertNewObjectForEntityForName:@"ScoreInfo"
                                   inManagedObjectContext:context];
            [scoreinfo setValue:[NSString stringWithFormat:@"%d",score] forKey:@"score"];
            [scoreinfo setValue:[NSDate date] forKey:@"date"];
       
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        [myTime invalidate];
        myLabel.font=[UIFont boldSystemFontOfSize:300];
        myLabel.adjustsFontSizeToFitWidth=YES;
        [self.view addSubview:myLabel];
        
    }
    //消砖块
    [self removeBlock:identifier];
    //胜利；
    if(flag1==0)
    {
        [self.animator removeAllBehaviors];
        [ballView setCenter:CGPointMake(520, 650)];
        [board setCenter:CGPointMake(520, 680)];
        [self.collision addItem:ballView];
        [self.board removeGestureRecognizer:pan];
        
        myLabel=[[UILabel alloc]initWithFrame:CGRectMake(280, 100, 500, 300)];
        myLabel.text=@"You Win!";
        Score.text=[NSString stringWithFormat:@"%d",score+(3-flag2)*100+300];
        [myTime invalidate];
        myLabel.font=[UIFont boldSystemFontOfSize:300];
        myLabel.adjustsFontSizeToFitWidth=YES;
        [self.view addSubview:myLabel];
        [self choose];
        
        //存储分数
        NSManagedObjectContext * context=[self managedObjectContext];
        ScoreInfo * scoreinfo=[NSEntityDescription
                               insertNewObjectForEntityForName:@"ScoreInfo"
                               inManagedObjectContext:context];
        [scoreinfo setValue:[NSString stringWithFormat:@"%d",score+(3-flag2)*100+300] forKey:@"score"];
        [scoreinfo setValue:[NSDate date] forKey:@"date"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}
-(void)removeBlock:(id <NSCopying>)identifier
{

    if(choosenumber==11)
    {
        for(int i=0;i<flag;i++)
        {   NSString* mi=[NSString stringWithFormat:@"%d",i];
            NSString* strScore;
            if([mi isEqual:identifier])
            {
                dis[i]=0;
                [dp[i] removeFromSuperview];
                [self.collision removeBoundaryWithIdentifier:mi];
                score=score+10;
                strScore=[NSString stringWithFormat:@"%d",score];
                Score.text=strScore;
                flag1--;
            }
        }
    }
    else if(choosenumber==22)
    {
        for(int i=0;i<flag;i++)
        {   NSString* mi=[NSString stringWithFormat:@"%d",i];
            NSString* strScore;
            if([mi isEqual:identifier])
            {
                if(dp[i].backgroundColor==[UIColor greenColor]) dp[i].backgroundColor=[UIColor yellowColor];
                else if(dp[i].backgroundColor==[UIColor yellowColor]) dp[i].backgroundColor=[UIColor blueColor];
                else if(dp[i].backgroundColor==[UIColor blueColor]) dp[i].backgroundColor=[UIColor orangeColor];
                else if(dp[i].backgroundColor==[UIColor orangeColor]) dp[i].backgroundColor=[UIColor redColor];
                else if(dp[i].backgroundColor==[UIColor redColor]) dp[i].backgroundColor=[UIColor purpleColor];
                else if(dp[i].backgroundColor==[UIColor purpleColor]) dp[i].backgroundColor=[UIColor grayColor];
                else if(dp[i].backgroundColor==[UIColor grayColor])
                {
                    dis[i]=0;
                    [dp[i] removeFromSuperview];
                    [self.collision removeBoundaryWithIdentifier:mi];
                    flag1--;
                }
                score=score+10;
                strScore=[NSString stringWithFormat:@"%d",score];
                Score.text=strScore;
            }
        }

    }
}

//可以选择重来和回到首页
-(void)choose
{
    [replay setImage:[UIImage imageNamed:@"5.jpg"]];
    [home setImage:[UIImage imageNamed:@"6.jpg"]];
    [replay setHidden:NO];
    [home setHidden:NO];
    [self imageTap];
}

-(void)imageTap
{
    replay.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replayPressed)];
    [replay addGestureRecognizer:tap];
    
    home.userInteractionEnabled=YES;
    UITapGestureRecognizer * htap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(homePressed)];
    [home addGestureRecognizer:htap];
}

-(void)replayPressed
{
    //[self viewDidDisappear:YES];
    [self removeViews];
    [self viewDidLoad];
    [Play setHidden:NO];
    [replay setHidden:YES];
    [home setHidden:YES];
    myLabel.text=@"";
}
-(void)homePressed
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
-(void)removeViews
{
    [ballView removeFromSuperview];
    [board removeFromSuperview];
    for(int i=0;i<50;i++)
    {
        if(dis[i]==1)
        {
            [dp[i] removeFromSuperview];
        }
    }
}

static const CGSize Z_SIZE={80,30};

-(void)initData
{
    flag=0; //用于记录砖块数量；
    flag1=0;//同上
    flag2=0;//标记游戏次数。。
    score=0;
    state=0;
    for(int i=0;i<50;i++)
    {
        dis[i]=0;
    }
    secondsBetweenTime=0;//游戏中的时间
    timeInterval=0;  //记录每一次球掉了时总共的游戏时间（不包含未游戏的状态)
    
    ballView=[[BallView alloc]init];
    board=[[Board alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
	CGRect frame;
    frame.origin.x=CGPointZero.x;
    frame.origin.y=CGPointZero.y+30;
    frame.size=Z_SIZE;
    
    int brick[20]={0};
    for(int i=0;i<50;i++){
        int x=(arc4random()%(int)self.gameView.bounds.size.width)/Z_SIZE.width;
        frame.origin.x=x*Z_SIZE.width+20;
        if(frame.origin.x<=820&&frame.origin.x>=0)
        {
            frame.origin.y=CGPointZero.y+30+40*brick[x];
            frame.origin.x=frame.origin.x+x*10;
            brick[x]++;
            dis[flag]=1;
            flag++;
            dropView=[[UIView alloc]initWithFrame:frame];
            dropView.backgroundColor=[self randomColor];
            [self.gameView addSubview:dropView];
            dp[flag-1]=dropView;
        }
    }
    flag1=flag;
   
    self.gameView.userInteractionEnabled=YES;
    
    [self.gameView addSubview:ballView];
    [self.gameView addSubview:board];
    [self collisionBoundary];
    
    [myImage setImage:[UIImage imageNamed:@"1.png"]];
    blood.text=[NSString stringWithFormat:@"%d",(3-flag2)];
    
    pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.board addGestureRecognizer:pan];
}

//砖块的碰撞边界设定
-(void)collisionBoundary
{
     NSString * miao;
    for(int i=0;i<flag;i++)
    {
        if(dis[i]==0)
        {
            continue;
        }
        else{
        miao=[NSString stringWithFormat:@"%d",i];
        [self.collision addBoundaryWithIdentifier:miao
                                    fromPoint:CGPointMake(dp[i].frame.origin.x, dp[i].frame.origin.y+dp[i].frame.size.height)
                                      toPoint:CGPointMake(dp[i].frame.origin.x+dp[i].frame.size.width, dp[i].frame.origin.y+dp[i].frame.size.height)];
        }
    }
    
    [self.collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, 768) toPoint:CGPointMake(1024, 768)];
}

//产生不同颜色的砖块
-(UIColor *)randomColor
{
    switch (arc4random()%7) {
        case 0: return [UIColor greenColor];break;
        case 1: return [UIColor yellowColor];break;
        case 2: return [UIColor blueColor];break;
        case 3: return [UIColor redColor];break;
        case 4: return [UIColor purpleColor];break;
        case 5: return [UIColor orangeColor];break;
        case 6: return [UIColor grayColor];break;
        default:
            break;
    }
    return [UIColor blackColor];
}

//滑块的拖拽手势
-(void)handlePan:(UIPanGestureRecognizer *)pangesture
{
    CGPoint curPoint=[pangesture locationInView:self.gameView];
    [self.collision removeBoundaryWithIdentifier:@"board"];
    [self.collision addBoundaryWithIdentifier:@"board" fromPoint:CGPointMake(curPoint.x-60,board.layer.position.y) toPoint:CGPointMake(curPoint.x+60, board.layer.position.y)];
//    
//    NSLog(@"%f,%f",curPoint.x,curPoint.y);
//    NSLog(@"ball:%f,%f",ballView.center.x,ballView.center.y);
    
    [self.board setCenter:CGPointMake(curPoint.x, board.layer.position.y)];
    if(state==0)
    {
        [self.ballView setCenter:CGPointMake(curPoint.x, 650)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//存储数据到Core Data中

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
