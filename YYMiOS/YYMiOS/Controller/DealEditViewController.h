//
//  DealEditViewController.h
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Deal.h"
#import "RankView.h"

@protocol DealEditViewControllerDelegate;

@interface DealEditViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    id<DealEditViewControllerDelegate>  _delegate;
    UIButton        *_deleteButton;
    
    UITableView     *_tableView;
    
    UIView          *_tableFooterView;
    UILabel         *_rankLabel;
    RankView        *_rankView;
    UILabel         *_priceLabel;
    UIScrollView    *_scrollView;
    UILabel         *_keywordLabel;
    UITextField     *_keywordTextField;
    UITextView      *_textView;
    UIButton        *_addPhotoButton;
    UIButton        *_publishButton;
    
    Deal            *_deal;
}

@property (assign, nonatomic) id<DealEditViewControllerDelegate> delegate;
@property (retain, nonatomic) Deal *deal;

@end

@protocol DealEditViewControllerDelegate <NSObject>

- (void)dealEditViewControllerDidClickDeleteButton:(DealEditViewController *)dealEditVC;
- (void)dealEditViewControllerDidClickPublishButton:(DealEditViewController *)dealEditVC;

@end
