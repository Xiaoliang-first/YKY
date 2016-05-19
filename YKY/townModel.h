//
//  townModel.h
//  YKY
//
//  Created by 肖亮 on 15/9/16.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface townModel : NSObject


/** 县区tiName */
@property (nonatomic , copy) NSString * tiName;
/** 县区townId */
@property (nonatomic , copy) NSString * townId;


+(instancetype)townModelWithDict:(NSDictionary *)dict;


@end
