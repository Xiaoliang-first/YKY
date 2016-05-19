//
//  homeMyYGLuckNumModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/22.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeMyYGLuckNumModel : NSObject

/** 摇购时间 */
@property (nonatomic , copy) NSString * time;
/** 参与人次 */
@property (nonatomic , copy) NSString * unum;
/** 我的摇码数组串 */
@property (nonatomic , strong) NSArray * luckNums;


+(instancetype)modelWithDict:(NSDictionary*)dict;

@end
