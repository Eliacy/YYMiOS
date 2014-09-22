//
//  BaseViewController.h
//  Secretary
//
//  Created by lide on 14-7-30.
//
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UIView      *_adjustView;
    UIView      *_headerView;
    UILabel     *_titleLabel;
    
    UIButton    *_backButton;
    
    BOOL        _isLoading;
}

- (void)clickBackButton:(id)sender;

@end
