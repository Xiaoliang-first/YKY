//
//  XLQRCode.h
//  YKY
//
//  Created by 肖 亮 on 16/5/30.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLQRCode : UIView

@property (nonatomic , copy) NSString * codeStr;

@property (nonatomic , strong) UIImageView * imgView;

- (void)getQRCode;

@end
