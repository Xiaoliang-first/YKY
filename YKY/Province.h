//
//  Province.h
//  03-城市选择
//
//  Created by Romeo on 15/7/18.
//  Copyright (c) 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

@property (nonatomic, strong) NSArray* cities;
@property (nonatomic, copy) NSString* state;

+(instancetype)provinceWithDict:(NSDictionary *) dict;

@end
