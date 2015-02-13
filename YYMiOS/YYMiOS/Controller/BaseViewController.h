//
//  BaseViewController.h
//  Secretary
//
//  Created by lide on 14-7-30.
//
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Function.h"
#import "StaticVariable.h"

@interface BaseViewController : UIViewController
{
    UIView      *_adjustView;
    UIView      *_headerView;
    UILabel     *_titleLabel;
    
    UIButton    *_backButton;
    
    BOOL        _isLoading;
    BOOL        _isAppear;
    BOOL        _isHaveMore;
}

- (void)clickBackButton:(id)sender;
- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer;

@end
