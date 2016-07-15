//
//  UIButton+create.h
//  qunxin_edu
//
//  Created by 肖准 on 6/14/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (create)





+
(UIButton*)
createButtonWithFrame:
(CGRect) frame
Target:(id)target

Selector:(SEL)selector

Image:(NSString
       
       *)image
ImagePressed:(NSString
              
              *)imagePressed;

+
(UIButton
 
 *)
createButtonWithFrame:(CGRect)frame

Title:(NSString
       
       *)title
Target:(id)target

Selector:(SEL)selector;



@end