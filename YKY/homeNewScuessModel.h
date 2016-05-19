//
//  homeNewScuessModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeNewScuessModel : NSObject



/** 用户id */
@property (nonatomic , copy) NSString * uid;
/** 用户参与次数 */
@property (nonatomic , copy) NSString * joinCount;
/** 中奖人参与次数 */
@property (nonatomic , copy) NSString * luckCount;
/** 用户名字（昵称） */
@property (nonatomic , copy) NSString * uname;
/** 用户头像url字符串 */
@property (nonatomic , copy) NSString * headImage;
/** 奖品名字 */
@property (nonatomic , copy) NSString * pname;
/** 奖品id */
@property (nonatomic , copy) NSString * pid;
/** 奖品期号（前段显示例如：16000078期） */
@property (nonatomic , copy) NSString * serials;
/** 用户中奖时间 */
@property (nonatomic , copy) NSString * ptime;
/** 奖品图片url字符串 */
@property (nonatomic , copy) NSString * url;
/** 用户中奖号码缩写（需要处理为10000000+priNum） */
@property (nonatomic , copy) NSString * priNum;
/** 摇购期号ID */
@property (nonatomic , copy) NSString * serialId;

@property (nonatomic , copy) NSString * zongNum;
@property (nonatomic , copy) NSString * shengNum;
/** 0：不限购 */
@property (nonatomic , copy) NSString * plimit;
@property (nonatomic , copy) NSString * perNum;
@property (nonatomic , copy) NSString * luckCode;
@property (nonatomic , copy) NSString * time;
/** 是否领取奖励0：未领取  1：领取 */
@property (nonatomic , copy) NSString * state;
/** 默认-1：未填写地址  0:未发货  1：已发货 2：已完成  3：已作废 */
@property (nonatomic , copy) NSString * orderStatue;
/** 订单id */
@property (nonatomic , copy) NSString * orderId;
/** 奖品代理商id */
@property (nonatomic , copy) NSString * agentId;
/** 商家发货时间 */
@property (nonatomic , copy) NSString * stime;
/** 确认收货信息时间 */
@property (nonatomic , copy) NSString * otime;
/** 确认收货时间 */
@property (nonatomic , copy) NSString * rtime;





+(instancetype)modelWithDict:(NSDictionary*)dict;

-(void)setSerialId:(NSString *)serialId;
-(void)setLuckCode:(NSString *)luckCode;


@end
