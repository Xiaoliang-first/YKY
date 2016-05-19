//
//  YGLookOldModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGLookOldModel : NSObject

@property (nonatomic , copy) NSString * num;
@property (nonatomic , copy) NSString * serialId;

+(instancetype)modelWithDict:(NSDictionary*)dict;

@end
