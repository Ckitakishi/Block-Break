//
//  HomeViewController.m
//  collisor
//
//  Created by OurEDA on 14-4-8.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize homeImage;
@synthesize play;
@synthesize score;
@synthesize challenge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [homeImage setImage:[UIImage imageNamed:@"4.jpg"]];
    play.layer.cornerRadius=40;
    score.layer.cornerRadius=40;
    challenge.layer.cornerRadius=40;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"start"])
    {
        ViewController * controller=(ViewController *)segue.destinationViewController;
        controller.choosenumber=11;
    }
    else if([segue.identifier isEqualToString:@"challenge"])
    {
        ViewController * controller=(ViewController *)segue.destinationViewController;
        controller.choosenumber=22;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
