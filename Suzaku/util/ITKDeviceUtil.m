//
//  ITKDeviceUtil.m
//  yiyou
//
//  Created by liangqi on 15/6/28.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKDeviceUtil.h"

@implementation ITKDeviceUtil

+ (NSString *) appVersionName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) appVersionBuild{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}
@end
