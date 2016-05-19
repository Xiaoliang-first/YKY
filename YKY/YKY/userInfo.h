//
//  userInfo.h
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject


//ciName = ,
//uiName = 默默积极,
//uiSilverCoin = 9,
//age = 0,
//uiHeadImage = http://115.28.179.212/amd/upload/1428077318301image.jpg,
//hobby = ,
//uiSex = 0,
//toId = <null>,
//uiGoldCoin = 926

/** 用户昵称 */
@property(nonatomic,copy)NSString *uiName;
/** 用户id */
@property(nonatomic,copy)NSString * uid;
/** 用户age */
@property(nonatomic,copy)NSString *age;
/** 用户头像Url */
@property(nonatomic,copy)NSString *uiHeadImage;
/** gold为当前用户金币数量 */
@property(nonatomic,copy)NSString *uiGoldCoin;
/** silverCoin为当前用户银币数量 */
@property(nonatomic,copy)NSString *uiSilverCoin;
/** 钻石数量 */
@property(nonatomic,copy)NSString *diamonds;
/** 用户的默认爱好（喜爱food类型） */
@property (nonatomic , copy) NSString * hobby ;
/** 用户性别 */
@property (nonatomic,copy) NSString * uiSex;
/** 用户资料中填写的城市名 */
//@property (nonatomic , copy) NSString * ciName;


+ (instancetype)accountWithDict:(NSDictionary *)dict;


@end
