//
//  routeMessageModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/26.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface routeMessageModel : NSObject

@property (nonatomic , copy) NSString * lname;
@property (nonatomic , copy) NSString * lnumber;
@property (nonatomic , copy) NSString * raddress;
@property (nonatomic , copy) NSString * rname;
@property (nonatomic , copy) NSString * rphone;
@property (nonatomic , copy) NSString * otime;
@property (nonatomic , copy) NSString * stime;
@property (nonatomic , copy) NSString * rtime;

+(instancetype)modelWithDict:(NSDictionary*)dict;



//lname = 中通快递,
//raddress = 风风光光,
//lnumber = d2342353245,
//rphone = 14541254125,
//rtime = 2016-04-26 18:26:47,
//stime = 2016-04-26 18:26:06,
//rname = 方法,
//otime = 2016-04-26 18:22:53

@end
