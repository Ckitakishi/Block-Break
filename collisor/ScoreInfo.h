//
//  ScoreInfo.h
//  collisor
//
//  Created by OurEDA on 14-4-23.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScoreInfo : NSManagedObject

@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSDate * date;

@end
