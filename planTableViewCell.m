//
//  planTableViewCell.m
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "planTableViewCell.h"

@interface planTableViewCell(){
    
    CGFloat _height;
    
    UILabel* _timeLB;
    UILabel* _contentLB;
    UILabel* _titleLB;
    
    UIView* _backview;
    
    UIView* _mask;
    
    UIImageView* _icon;
    
}
@property (nonatomic, weak)   NSIndexPath *m_tmpIndexPath;
@property (nonatomic, weak)   id m_date;



@end

@implementation planTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initsubviews];
        [self registerNSNotificationCenter];
        _isDisplay = YES;
        _index = 1;
        _ration = 0.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        
 
    }
    return self;
}

-(void)initsubviews{
 
    
  
    
    //背景
    _backview = [UIView new];
    [self.contentView addSubview:_backview];

    
    //遮盖层
    _mask = [UIView new];
    _mask.backgroundColor = [UIColor clearColor];
    [_backview addSubview:_mask];
    
    
    //标题
    _titleLB = [UILabel new];
    _titleLB.text = @"任务-";
    _titleLB.textColor = [UIColor blackColor];
    _titleLB.font      = [UIFont fontWithName:@"Avenir-Light" size:20];
    [_backview addSubview:_titleLB];
    
    
    //剩余时间
    _timeLB = [UILabel new];
    //_timeLB.font = [UIFont boldSystemFontOfSize:30];
    _timeLB.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:30];
    _timeLB.textColor = [UIColor redColor];
    _timeLB.text =[NSString stringWithFormat:@"剩余时间:"];
    _timeLB.backgroundColor =[UIColor clearColor];
    _timeLB.textAlignment = NSTextAlignmentRight;
    [_backview  addSubview:_timeLB];


    _contentLB = [UILabel new];
    _contentLB.font = [UIFont systemFontOfSize:13];
    _contentLB.numberOfLines = 0;
    _contentLB.backgroundColor =[UIColor clearColor];
    _contentLB.textColor = [UIColor grayColor];
    _contentLB.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail ;
    [_backview addSubview:_contentLB];
    
    
    
    //图标
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    
}



-(void)loyoutWithDataAndHeight:(planMJ*)plan height:(CGFloat)height{

    _height = 100;
    _plan = plan;
    
    
    _backview.frame = CGRectMake(0, 0, screenwith, _height-0.5);
    _backview.backgroundColor = [UIColor whiteColor];
    
    
    //任务内容
    _contentLB.text = _plan.content;
  
    _titleLB.text = [NSString stringWithFormat:@"任务-%d",_index ];//@"任务 - "
    
    [_titleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(15).topSpace(10).heightValue(30);
        
    }];
    
    [_timeLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(5).rightSpace(10);
    }];
    
    [_contentLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.bottomSpace(4).leftSpace(15).widthValue(screenwith-30).heightValue(59);
    }];
    
    //遮盖层
    _mask.frame = CGRectMake(0, 0, 0, _height-0.5);
    _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
      [self removeNSNotificationCenter];
}


- (void)loadTime:(id)date indexPath:(NSIndexPath *)indexPath {
    
    
    m_date *da = (m_date*)date;
    [self storeWeakValueWithData:date indexPath:indexPath];

    NSDate* nowdate = [NSDate date];
    NSInteger now = [nowdate minuteTime];
    //当前时间还未到任务开始时间
    if(now < da.startTime){
        NSLog(@"还未开始");

        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.870 alpha:1.000];

        [_icon setImage:[UIImage imageNamed:@"before_start"]];
        [_icon zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
            layout.leftSpace(screenwith/3).topSpaceEqualTo(_timeLB,-2);
        }];
        
        _timeLB.text =[[NSDate dateWithYear:0 month:0 day:0 hour:0 minute:(da.endTime - da.startTime) second:0] currentTimeStringHM];
        _timeLB.textColor = [UIColor grayColor];

        
    }else if(now > da.endTime) {
        //当任务超时
        NSLog(@"超时");
        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];

        [_icon setImage:[UIImage imageNamed:@"overtime"]];
        [_icon zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
            layout.leftSpace(screenwith/3).topSpaceEqualTo(_timeLB,-2);
        }];
          _timeLB.text =@"00:00";
        
        if(_disableCell){
            _disableCell();
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];

        
    }else {
        double cop = now - da.startTime;
        double total = da.endTime - da.startTime;
        _ration = cop/(double)total;
        
        NSLog(@"开始计时...");

        _icon = nil;
        _timeLB.textColor = [UIColor redColor];
        _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
        
        if(_ration >(3/4.0) && _ration< (7/8.0)){
            _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:0.300];
        
        }else if(_ration>=7/8.0){
            _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];
        }else if(_ration == 1.0){
            
            [_icon setImage:[UIImage imageNamed:@"overtime"]];
            [_icon zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
                layout.leftSpace(screenwith/3).topSpaceEqualTo(_timeLB,-2);
            }];
            if(_disableCell){
                _disableCell();
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
        }
        
        //[UIView animateWithDuration:1 animations:^{
            _mask.frame = CGRectMake(0, 0, screenwith*cop/total, _height-0.5);
       // }];
        _timeLB.text  = [[NSDate dateWithYear:0 month:0 day:0 hour:0 minute:da.m_countNum second:0] currentTimeStringHM];
        

    }
  
}

-(void)storeWeakValueWithData:(id)date indexPath:(NSIndexPath *)indexPath {
    
    self.m_date = date;
    self.m_tmpIndexPath = indexPath;
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (_isDisplay) {
        [self loadTime:self.m_date indexPath:self.m_tmpIndexPath];
    }
}



@end
