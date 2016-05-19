//
//  YGChooseKindCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGChooseKindCell.h"
#import "kindModel.h"

@implementation YGChooseKindCell


-(void)setKindmodel:(kindModel *)kindmodel{
    _kindmodel = kindmodel;
    self.kindTitleLabel.text = [NSString stringWithFormat:@"%@",kindmodel.kindName];
    self.kindTitleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
}


@end
