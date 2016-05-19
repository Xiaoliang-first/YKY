//
//  meAdressCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meAdressCell.h"
#import "meAdressModel.h"

@interface meAdressCell()





@end

@implementation meAdressCell

-(void)setModel:(meAdressModel *)model{
    _model = model;
    if (model.name) {
        self.nameLabel.text = model.name;
    }
    if (model.phone) {
        self.phoneLabel.text = model.phone;
    }
//    if (_isSelected) {
//        self.isMyAdressImgv.hidden = NO;
//        self.backImagView.hidden = NO;
//        self.nameLabel.textColor = [UIColor whiteColor];
//        self.phoneLabel.textColor = [UIColor whiteColor];
//        self.adressDetail.textColor = [UIColor whiteColor];
//    }else{
        if ([model.isHost isEqualToString:@"1"]) {
            self.isMyAdressImgv.hidden = NO;
            self.backImagView.hidden = NO;
            self.nameLabel.textColor = [UIColor whiteColor];
            self.phoneLabel.textColor = [UIColor whiteColor];
            self.adressDetail.textColor = [UIColor whiteColor];
        }else{
            self.backImagView.hidden = YES;
            self.isMyAdressImgv.hidden = YES;
            self.nameLabel.textColor = YKYColor(51, 51, 51);
            self.phoneLabel.textColor = YKYColor(51, 51, 51);
            self.adressDetail.textColor = YKYColor(102, 102, 102);
        }
//    }
    if (model.adressDetail) {
        self.adressDetail.text = model.adressDetail;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
