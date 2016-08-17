//
//  AnalyTableViewCell.m
//  BigToeTimer
//
//  Created by 肖准 on 7/18/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "AnalyTableViewCell.h"

@implementation AnalyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initsubviews];
        [self setlayouts];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
    
    
    
}
-(void)initsubviews{
    
    //左边的图标
    _iconIV = [UIImageView new];
    [self.contentView addSubview:_iconIV];
    
    //右边的解释
    _titleLB = [UILabel new];
    _titleLB.numberOfLines =2;
    _titleLB.textColor = [UIColor lightGrayColor];
    _titleLB.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleLB];
    
    
}
-(void)setlayouts{
    [_iconIV zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5).topSpace(26).bottomSpace(26).widthValue(48);
    }];
    [_titleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(_iconIV,15).rightSpace(10).heightValue(80);
    }];
}

-(void)loadData:(NSString*)imgUrl title:(NSString*)title{
    
    [_iconIV setImage:[UIImage imageNamed:imgUrl]];
    [_titleLB setText:title];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
