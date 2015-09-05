//
//  AppLog.h
//  Suzaku
//
//  Created by liangqi on 15/9/5.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppLog : NSManagedObject

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * time;

@end
