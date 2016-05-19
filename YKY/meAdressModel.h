//
//  meAdressModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface meAdressModel : NSObject

/** 收货人地址id */
@property (nonatomic , copy) NSString * ID;
/** 收货人姓名 */
@property (nonatomic , copy) NSString * name;
/** 收货人电话 */
@property (nonatomic , copy) NSString * phone;
/** 收货人详细地址 */
@property (nonatomic , copy) NSString * adressDetail;
/** 收货地址是否是默认地址 1:是默认地址  0：非默认*/
@property (nonatomic , copy) NSString * isHost;


+(instancetype)modelWithDict:(NSDictionary*)dict;


@end
