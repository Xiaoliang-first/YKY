//
//  managerCommendatoryCell.m
//  YKY
//
//  Created by 亮肖 on 15/6/15.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "managerCommendatoryCell.h"
#import "UIImageView+WebCache.h"
#import "managerCommendatoryModel.h"

@implementation managerCommendatoryCell


-(void)setManagerModel:(managerCommendatoryModel *)managerModel{
    _managerModel = managerModel;
    self.prizeNameLabel.text = managerModel.goodsName;
    self.prizePriceLael.text = [NSString stringWithFormat:@"%@",managerModel.goodsPrice];
    self.prizeType.text = managerModel.goodsDesc;
    NSString *string = [managerModel.goodsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
}





@end
