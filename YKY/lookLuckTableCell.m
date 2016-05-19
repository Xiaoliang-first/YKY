//
//  lookLuckTableCell.m
//  YKY
//
//  Created by 肖亮 on 15/9/13.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "lookLuckTableCell.h"
#import "UIImageView+WebCache.h"
#import "lookLucksModel.h"

@implementation lookLuckTableCell

-(void)setLookLucksmodels:(lookLucksModel *)lookLucksmodels{
    _lookLucksmodels = lookLucksmodels;
    self.prizerNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.getPrizeDateLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.prizeNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];

    if (![lookLucksmodels.pname isKindOfClass:[NSNull class]]) {
        self.prizeNameLabel.text = lookLucksmodels.pname;
    }
    if (![lookLucksmodels.uname isKindOfClass:[NSNull class]]) {
        self.prizerNameLabel.text = lookLucksmodels.uname;
    }
    if (![lookLucksmodels.time isKindOfClass:[NSNull class]]) {
        self.getPrizeDateLabel.text = lookLucksmodels.time;
    }
    if (![lookLucksmodels.url isKindOfClass:[NSNull class]]) {
        [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:lookLucksmodels.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    }else{
        [self.prizeImageView setImage:[UIImage imageNamed:@"prepare_loading_big"]];
    }

    //设置图片圆角
    self.prizeImageView.layer.cornerRadius = 5;
    self.prizeImageView.layer.masksToBounds = YES;
    self.prizeImageView.layer.borderWidth = 0.01;
}




@end
