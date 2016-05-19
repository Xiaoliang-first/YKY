//
//  baseRequest.h
//  YKY
//
//  Created by 亮肖 on 15/5/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseRequest : NSObject


/**
 *  参数字典
 */
@property (nonatomic , strong) NSMutableDictionary * paremeters;


/**
 *  传入参数 返回一个带有 account.uiId 和uiPhone 和 responseToken 三个参数的字典
 *
 *  @param page 传入页码 （-1）表示不翻页 0以上表示翻page页
 *  @param Bool 是否需要加上边传入的那三个参数
 *
 *  @return 返回一个对应的参数字典
 */
- (NSMutableDictionary *)dictWithParametes:(int)page BOOL:(BOOL)Bool;

@end
