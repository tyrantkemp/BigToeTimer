//
//  RootViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
-(void)awakeFromNib{
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainContentBarCtl"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
