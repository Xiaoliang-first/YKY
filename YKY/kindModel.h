//
//  kindModel.h
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kindModel : NSObject

/** 分类的Id */
@property (nonatomic , copy) NSString * kindId;
/** 分类的名字 */
@property (nonatomic , copy) NSString * kindName;


+(instancetype)modelWithDict:(NSDictionary *)dict;


@end
