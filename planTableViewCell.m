//
//  planTableViewCell.m
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "planTableViewCell.h"
#import "LocalNotificationsManager.h"
#import "NSDate+Format.h"
#import "Canvas.h"

@interface planTableViewCell(){
    
    CGFloat _height;
    
    UILabel* _timeLB;
    UILabel* _contentLB;
    UILabel* _titleLB;
    
    UIView* _backview;
    
    UIView* _mask;
    
    UILabel* _rangeLB;
    
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
    _timeLB.text =[NSString stringWithFormat:@":"];
    _timeLB.backgroundColor =[UIColor clearColor];
    _timeLB.textAlignment = NSTextAlignmentRight;
    [_backview  addSubview:_timeLB];


    //时间期限
    _rangeLB = [UILabel new];
    _rangeLB.font = [UIFont systemFontOfSize:13];
    _rangeLB.textColor = [UIColor lightGrayColor];
    _rangeLB.backgroundColor =[UIColor clearColor];
    _rangeLB.textAlignment = NSTextAlignmentRight;
    [_backview  addSubview:_rangeLB];

    
    //任务内容
    _contentLB = [UILabel new];
    _contentLB.font = [UIFont systemFontOfSize:13];
    _contentLB.numberOfLines = 0;
    _contentLB.backgroundColor =[UIColor clearColor];
    _contentLB.textColor = [UIColor grayColor];
    _contentLB.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail ;
    [_backview addSubview:_contentLB];
    
    
    //图标
    _icon = [UIImageView new];
    _icon.frame = CGRectMake(screenwith/3, 20, 64, 64);
    [_backview addSubview:_icon];
    
    
}



-(void)loyoutWithDataAndHeight:(planMJ*)plan height:(CGFloat)height isShow:(BOOL)show{

    _height = 100;
    _plan = plan;
    
    
    _backview.frame = CGRectMake(0, 0, screenwith, _height-0.5);
    _backview.backgroundColor = [UIColor whiteColor];
    
    
    //任务内容
    _contentLB.text = _plan.content;
  
    //时间范围
    NSDate* start = [NSDate dateWithYear:0 month:0 day:0 hour:0 minute:_plan.startTime second:0];
    NSDate* end = [NSDate dateWithYear:0 month:0 day:0 hour:0 minute:_plan.endTime second:0];
    if(show){
        

        _rangeLB.text =[NSString stringWithFormat:@"创建时间:%@",[NSDate dateStrFromCstampTime:[[_plan.createTime substringWithRange:NSMakeRange(0,10)] intValue] withDateFormat:@"yyyy-MM-dd HH:mm:ss" ]];

    }else {
    _rangeLB.text =[NSString stringWithFormat:@"%@ - %@",[start currentTimeStringHM],[end currentTimeStringHM]];
    }
    
    _titleLB.text = [NSString stringWithFormat:@"任务-%d",_index ];//@"任务 - "
    
    [_titleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(15).topSpace(10).heightValue(30);
        
    }];
    
    [_timeLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(5).rightSpace(10);
    }];
    
    [_contentLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.bottomSpace(4).leftSpace(15).widthValue(screenwith/3*10).heightValue(59);
    }];
    
    [_rangeLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(screenwith/3).topSpaceEqualTo(_titleLB,4);
    }];
    //遮盖层
    _mask.frame = CGRectMake(0, 0, 0, _height-0.5);
    _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
    
    if(show){
    //表示已经在限时内完成
    if(_plan.remain!=0){
        NSDate *time = [NSDate dateWithYear:0 month:0 day:0 hour:0 minute:_plan.remain second:0];
        _timeLB.text =[time currentTimeStringHM];
        _contentLB.text = _plan.content;
        [self setIcon:@"done"];
        _timeLB.textColor=[UIColor greenColor];
        if(_disableCell){
            _disableCell(cellTypeExistNone);
        }
        
        //提前完成
        if(_plan.remain>(_plan.endTime - _plan.startTime)){
            
            
         
        }else {
            
            [_mask setFrame:CGRectMake(0, 0, screenwith*_plan.ration, _height-.5)];
            _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
        }
      
        
        
    }else {
        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];
        [self setIcon:@"overtime"];
        _contentLB.text = _plan.content;
        _timeLB.text =@"00:00";
        if(_disableCell){
            _disableCell(cellTypeExistNone);
        }

    }
    }
    
}


- (void)loadTime:(id)date indexPath:(NSIndexPath *)indexPath {
    
    
    m_date *da = (m_date*)date;
    [self storeWeakValueWithData:date indexPath:indexPath];

    NSDate* nowdate = [NSDate date];
    NSInteger now = [nowdate minuteTime];
    
//
//    if(((m_date*)_m_date).isDone){
//        
//        _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
//        if(_disableCell){
//            _disableCell(cellTypeExistNone);
//        }
//        return ;
//    }
    
    //表示已经在限时内完成
    if(_plan.remain!=0){
       
        NSDate *time = [NSDate dateWithYear:0 month:0 day:0 hour:0 minute:_plan.remain second:0];
        _timeLB.text =[time currentTimeStringHM];
       
        [self setIcon:@"done"];
        if(_disableCell){
            _disableCell(cellTypeExistNone);
        }
        [_mask setFrame:CGRectMake(0, 0, screenwith*_plan.ration, _height-.5)];
        _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
      
        return;
    }
    
    if(_plan.isPassed){
        NSLog(@"过去日期");
        
        
        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];
        [self setIcon:@"overtime"];
        
        _timeLB.text =@"00:00";
        
        if(_disableCell){
            _disableCell(cellTypeExistNone);
        }
        return;
    }
    //当前时间还未到任务开始时间
    if(now < da.startTime){
        NSLog(@"还未开始");

        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.870 alpha:1.000];

        [self setIcon:@"before_start"];
        _timeLB.text =[[NSDate dateWithYear:0 month:0 day:0 hour:0 minute:(da.endTime - da.startTime) second:0] currentTimeStringHM];
        _timeLB.textColor = [UIColor grayColor];

        if(_disableCell){
            _disableCell(cellTypeExistDelete);
        }
        
    }else if(now >= da.endTime) {
        //当任务超时
        NSLog(@"as");
        _mask.frame = CGRectMake(0, 0, screenwith, _height-0.5);
        _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];
        [self setIcon:@"overtime"];

        //删除通知
        [LocalNotificationsManager removeLocalNotificationWithActivityId:_plan.planName];
        
          _timeLB.text =@"00:00";
        
        if(_disableCell){
            _disableCell(cellTypeExistNone);
        }
        
      //  [self removeNSNotificationCenter];

        
    }else {
        
        if(_disableCell){
            _disableCell(cellTypeExistAll);
        }
        _icon.hidden = YES;
        
        
        
        
        double cop = now - da.startTime;
        double total = da.endTime - da.startTime;
        _ration = cop/(double)total;
        
        NSLog(@"开始计时...");

        _timeLB.textColor = [UIColor redColor];
        _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
        
        if(_ration >(1/2.0) && _ration< (2/3.0)){
            _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:0.300];
        
        }else if(_ration>=2/3.0){
            _mask.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.305];
        }
//        else if(_ration == 1.0){
//            
//            
//            [self setIcon:@"overtime"];
//
//            if(_disableCell){
//                _disableCell(cellTypeExistNone);
//            }
//            [self removeNSNotificationCenter];
//        }
        
        //[UIView animateWithDuration:1 animations:^{
            _mask.frame = CGRectMake(0, 0, screenwith*_ration, _height-0.5);
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

//-(void)wellDone{
//    
//    [self setIcon:@"done"];
//    [_mask setFrame:CGRectMake(0, 0, screenwith*_ration, _height-.5)];
//    _mask.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.298];
//
//    ((m_date*)self.m_date).isDone = YES;
//    
//    if(_disableCell){
//        _disableCell(cellTypeExistNone);
//    }
//    
//}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (_isDisplay) {
        [self loadTime:self.m_date indexPath:self.m_tmpIndexPath];
    }
}


#pragma  mark - 设定图标
-(void)setIcon:(NSString*)iconUrl{
//    
//    UIImageView *icon = [UIImageView new];
//    [icon setImage:[UIImage imageNamed:iconUrl]];
//    [self.contentView addSubview:icon];
//    [icon zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//       
//        layout.bottomSpace(10).rightSpace(10);
//    }];
    [_icon setImage:[UIImage imageNamed:iconUrl]];
    _icon.hidden = NO;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
- (void)dealloc
{
    [self removeNSNotificationCenter];
}

@end
