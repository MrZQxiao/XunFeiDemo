//
//  ISRDataHelper.h
//  XunFeiDemo
//
//  Created by 肖兆强 on 2018/1/13.
//  Copyright © 2018年 ZQDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRDataHelper : NSObject
// 解析命令词返回的结果
+ (NSString*)stringFromAsr:(NSString*)params;

/**
 解析JSON数据
 ****/
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 解析语法识别返回的结果
 ****/
+ (NSString *)stringFromABNFJson:(NSString*)params;
@end
