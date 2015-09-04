//
//  ITKDeviceUtil.h
//  yiyou
//
//  Created by liangqi on 15/6/28.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITKDeviceUtil : NSObject

/**
 *  获取app版本号
 *
 *  @return such as 1.0.0
 */
+ (NSString *) appVersionName;


/**
 *  获取app build number string
 *
 *  @return such as 1
 */
+ (NSString *) appVersionBuild;

@end
