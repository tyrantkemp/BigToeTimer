//
//  AnalysisTableViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/18/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "AnalysisTableViewController.h"
#import "AnalyTableViewCell.h"
#import "DoneViewController.h"
#import "ChartViewController.h"

static NSString* cellId=@"analy_cell";

@interface AnalysisTableViewController (){
    NSArray* _imgArr;
    NSArray* _titleArr;
}

@end

@implementation AnalysisTableViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        _imgArr = [NSMutableArray new];
        _titleArr = [NSMutableArray new];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.navigationItem.title = @"统计";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[AnalyTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenwith, 45)];
    
   
    
    
    _imgArr = @[@"pie",@"chart"];
    _titleArr = @[@"任务的完成情况占比:提前完成、超时、规定时间内完成任务所占比例",@"任务完成情况曲线对比:按月、周进行横向对比"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _imgArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  45;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenwith, 45)];
    footv.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];
    return  footv;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    view.frame = CGRectMake(0, 0, screenwith, 45);
//    
//    UILabel* titleLB = [UILabel new];
//    titleLB.font =[UIFont systemFontOfSize:14];
//    titleLB.textColor= [UIColor lightGrayColor];
//    [view addSubview:titleLB];
//    if(section == 0){
//      [titleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//          layout.leftSpace(5).bottomSpace(2);
//      }];
//        titleLB.text=@"任务完成情况统计";
//    }
//  
//    return  view;
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   AnalyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
        [cell loadData:_imgArr[indexPath.section] title:_titleArr[indexPath.section]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section:%d,row:%d",indexPath.section,indexPath.row);
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            DoneViewController* donectl = [DoneViewController new];
            donectl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:donectl animated:YES];
            
        }
        
    }else if(indexPath.section == 1){
        if(indexPath.row==0){
            ChartViewController* chartCtl = [ChartViewController new];
            chartCtl.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:chartCtl animated:YES];

        }
    }
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
