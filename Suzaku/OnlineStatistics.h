//
//  OnlineStatistics.h
//  ServerManager
//
//  Created by liangqi on 15/8/30.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OnlineStatistics : NSManagedObject

@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSNumber * total_time;

@end
