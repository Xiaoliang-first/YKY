//
//  noticeCell.m
//  一块摇
//
//  Created by 亮肖 on 15/4/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "noticeCell.h"
#import "noticeModel.h"

@implementation noticeCell


-(void)setNoticeModel:(noticeModel *)noticeModel{
    _noticeModel = noticeModel;
    
    self.noticeLabel.text = _noticeModel.sysTitle;
    self.noticeTimeLabel.text = _noticeModel.publicDate;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
