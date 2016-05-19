//
//  messageCentercell.m
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "messageCentercell.h"
#import "noticeModel.h"

@implementation messageCentercell


-(void)setNoticeModel:(noticeModel *)noticeModel{
    _noticeModel = noticeModel;
    
    self.titleLabel.text = _noticeModel.sysTitle;
    self.timeLabel.text = _noticeModel.publicDate;
    self.detailLabel.text = _noticeModel.sysContent;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
