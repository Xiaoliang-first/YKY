//
//  btnsModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface btnsModel : NSObject

@property (nonatomic , copy) NSString * title;
@property (nonatomic , copy) NSString * identify;

+(instancetype)modeWithDict:(NSDictionary*)dict;

@end
