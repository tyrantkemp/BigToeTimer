//
//  UIButton+create.m
//  qunxin_edu
//
//  Created by 肖准 on 6/14/16.
//  Copyright © 2016 肖准. All rights reserved.
//



//使用方法，首先在要使用的ViewController
//
//包含#import
//"UIButton+Create.h"
//
//然后使用方法
//
//
//
//-
//(void)viewDidLoad
//
//{
//
//    [super
//
//     viewDidLoad];
//
//    [self.view
//
//     addSubview:[UIButton
//
//                 createButtonWithFrame:CGRectMake(0,
//                                                  0,
//                                                  160,
//                                                  40)
//
//                 Title:@"测试"
//
//                 Target:self
//
//                 Selector:@selector(buttonPressed:)]];
//
//    [self.view
//
//     addSubview:[UIButton
//
//                 createButtonWithFrame:CGRectMake(0,
//                                                  100,
//                                                  160,
//                                                  40)
//
//                 Target:self
//
//                 Selector:@selector(buttonPressed:)
//
//                 Image:@"这个是你给这个Button设置的默认图片"
//
//                 ImagePressed:@"button点击后显示的高亮的图片"]];
//
//}
//
//
//
//-
//(void)buttonPressed:(id)sender
//
//{
//
//
//
//}

#import "UIButton+create.h"

@implementation

UIButton
(Create)



+
(UIButton*)
createButtonWithFrame:
(CGRect) frame
Target:(id)target

Selector:(SEL)selector

Image:(NSString
       
       *)image
ImagePressed:(NSString
              
              *)imagePressed

{
    
    UIButton
    
    * button = [UIButton
                
                buttonWithType:UIButtonTypeCustom];
    
    [button
     
     setFrame:frame];
    
    UIImage
    
    *newImage = [UIImage
                 
                 imageNamed:
                 
                 image];
    
    [button
     
     setBackgroundImage:newImage
     
     forState:UIControlStateNormal];
    
    UIImage
    
    *newPressedImage = [UIImage
                        
                        imageNamed:
                        
                        imagePressed];
    
    [button
     
     setBackgroundImage:newPressedImage
     
     forState:UIControlStateHighlighted];
    
    [button
     
     addTarget:target
     
     action:selector
     
     forControlEvents:UIControlEventTouchUpInside];
    
    return
    
    button;
    
}



+
(UIButton
 
 *)
createButtonWithFrame:(CGRect)frame

Title:(NSString
       
       *)title
Target:(id)target

Selector:(SEL)selector

{
    
    UIButton
    
    * button = [UIButton
                
                buttonWithType:UIButtonTypeRoundedRect];
    
    [button
     
     setFrame:frame];
    
    [button
     
     setTitle:title
     
     forState:UIControlStateNormal];
    
    [button
     
     addTarget:target
     
     action:selector
     
     forControlEvents:UIControlEventTouchUpInside];
    
    return
    
    button;
    
}



@end


