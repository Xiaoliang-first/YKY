//
//  YGCurrentyaogouListModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/11.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGCurrentyaogouListModel : NSObject

@property (nonatomic , copy) NSString * luckerName;
@property (nonatomic , copy) NSString * luckerIconUrlstr;
@property (nonatomic , copy) NSString * luckerCity;
@property (nonatomic , copy) NSString * luckerRockNum;
@property (nonatomic , copy) NSString * luckDate;

+(instancetype)modeWithDict:(NSDictionary*)dict;

@end
