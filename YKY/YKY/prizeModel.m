//
//  prizeModel.m
//  YKY
//
//  Created by 亮肖 on 15/5/1.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//


///** 奖品Id */
//@property (nonatomic , copy) NSString * pdrId;
///** 奖品名称 */
//@property (nonatomic , copy) NSString * prizeName;
///** 奖品市场价格 */
//@property (nonatomic , copy) NSString * prizeMarketPrice;
///** 奖品购买价格 */
//@property (nonatomic , copy) NSString * prizePrice;
///** 奖品剩余数量 */
//@property (nonatomic , copy) NSString * prizeAmount2;
///** 奖品数量 */
//@property (nonatomic , copy) NSString * prizeAmount;
///** 奖品过期日期 */
//@property (nonatomic , copy) NSString * validDate;
///** 奖品图片URL地址字符串 */
//@property (nonatomic , copy) NSString * prizeUrl;
///** 奖品所在城市名 */
//@property (nonatomic , copy) NSString * ciName;
///** 奖品种类 */
//@property (nonatomic , copy) NSString * kindName;
///** 奖品所属商家 */
//@property (nonatomic , copy) NSString * supplierName;
///** 奖品小图地址 */
//@property (nonatomic , copy) NSString * prizeLowUrl;
///** 奖品所属商家描述 */
//@property (nonatomic , copy) NSString * supplierDesc;
///** 奖品所属商家电话 */
//@property (nonatomic , copy) NSString * supplierPhone;
///** 奖品所属商家地址 */
//@property (nonatomic , copy) NSString * supplierAddress;
/** 商家所在位置经度 */
//@property (nonatomic , copy) NSString * lon;
///** 商家所在位置维度 */
//@property (nonatomic , copy) NSString * lat;
///** 商家ID */
//@property (nonatomic , copy) NSString * supplierId;

#import "prizeModel.h"

@implementation prizeModel

+ (instancetype)prizeWithDict:(NSDictionary *)dict{
    prizeModel *prizeInfo = [[prizeModel alloc]init];
    
    
    prizeInfo.pId = [NSString stringWithFormat:@"%@",dict[@"pId"]];
    prizeInfo.pname = dict[@"pname"];
    prizeInfo.marketPrice = dict[@"marketPrice"];
    prizeInfo.shakeNum = [NSString stringWithFormat:@"%@",dict[@"shakeNum"]];
    prizeInfo.num = [NSString stringWithFormat:@"%@",dict[@"num"]];
    prizeInfo.jpId = [NSString stringWithFormat:@"%@",dict[@"jpId"]];
    prizeInfo.url = dict[@"url"];
    prizeInfo.mname = dict[@"mname"];


    DebugLog(@"-=-=-=%@",prizeInfo.url);
    return prizeInfo;
}

@end
