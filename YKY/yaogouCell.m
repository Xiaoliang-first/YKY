//
//  yaogouCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "yaogouCell.h"
#import "homeNewScuessModel.h"
#import "UIImageView+WebCache.h"
#import "XLProgressBarView.h"

@interface yaogouCell()

@property (nonatomic , strong) XLProgressBarView * progressVeiw;
@property (nonatomic , strong) UILabel * leftLabel;
@property (nonatomic , strong) UILabel * rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *limitRockBtnW;

@end
 
@implementation yaogouCell


-(void)setPrizeModel:(homeNewScuessModel *)prizeModel{
    _prizeModel = prizeModel;

    if (iPhone6) {
        self.limitRockBtnW.constant = 140;
    }else if (iPhone6plus){
        self.limitRockBtnW.constant = 160;
    }

    //设置图片圆角
    self.prizeImgView.layer.cornerRadius = 5;
    self.prizeImgView.layer.masksToBounds = YES;
    self.prizeImgView.layer.borderWidth = 0.01;
    self.prizeImgView.image = [UIImage imageNamed:@"prepareloading_small"];

    self.oderNumLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.prizeNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.plimitLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    
    
    if (prizeModel.url) {
        [self.prizeImgView sd_setImageWithURL:[NSURL URLWithString:prizeModel.url] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    }
    if (prizeModel.serials) {
        self.oderNumLabel.text = [NSString stringWithFormat:@"第%@期",prizeModel.serials];
    }
    if (prizeModel.pname) {
        self.prizeNameLabel.text = prizeModel.pname;
    }
    if ([prizeModel.plimit isEqualToString:@"0"]) {
        self.plimitLabel.hidden = YES;
    }else{
        self.plimitLabel.text = [NSString stringWithFormat:@"每人限摇:%@人次",prizeModel.plimit];
        self.plimitLabel.hidden = NO;
    }
    if (prizeModel.zongNum && prizeModel.shengNum) {
        //添加progress
        CGFloat magin = 15;
        self.progressVeiw = [[XLProgressBarView alloc]initWithFrame:CGRectMake(magin, _prizeImgView.y+_prizeImgView.height+12, kScreenWidth-2*magin, 8) backgroundImage:[UIImage imageNamed:@"progressBack"] foregroundImage:[UIImage imageNamed:@"progress"]];
        //已摇出数量
        CGFloat pro = [prizeModel.zongNum floatValue] - [prizeModel.shengNum floatValue];
        self.progressVeiw.progress = pro/[prizeModel.zongNum floatValue];
        [self.myConnectView addSubview:self.progressVeiw];


        //添加底部左右显示数量label
        //1.左
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(magin, self.progressVeiw.y+self.progressVeiw.height+6, 0.4*self.progressVeiw.width, 13)];
        self.leftLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        self.leftLabel.textColor = [UIColor darkGrayColor];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.text = [NSString stringWithFormat:@"总需%@人次",prizeModel.zongNum];
        [self.myConnectView addSubview:self.leftLabel];
        //2.右
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-self.leftLabel.width-magin, self.progressVeiw.y+self.progressVeiw.height+6, 0.4*self.progressVeiw.width, 13)];
        self.rightLabel.textColor = [UIColor darkGrayColor];
        NSString * red1 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",prizeModel.shengNum];
        NSString * gray1 = @"<font size=\"4\" color=\"#666666\">剩余</font>";
        NSString * gray2 = @"<font size=\"4\" color=\"#666666\">人次</font>";
        NSString * plimit = [NSString stringWithFormat:@"%@%@%@",gray1,red1,gray2];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[plimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.rightLabel.attributedText = attrStr;
        self.rightLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.myConnectView addSubview:self.rightLabel];
    }
}


- (IBAction)goRockBtnClick:(id)sender {

    NSString * index = [NSString stringWithFormat:@"%d",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-yaogou"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"quyao" object:nil];
}


//避免滚动重复显示 重写prepareForReuse方法，在重用时移除添加的视图
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.progressVeiw removeFromSuperview];
    [self.leftLabel removeFromSuperview];
    [self.rightLabel removeFromSuperview];
}



@end
