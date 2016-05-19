//
//  meAdressCell.h
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class meAdressModel;
@interface meAdressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backImagView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isMyAdressImgv;
@property (weak, nonatomic) IBOutlet UILabel *adressDetail;


@property (nonatomic , strong) meAdressModel * model;

@end
