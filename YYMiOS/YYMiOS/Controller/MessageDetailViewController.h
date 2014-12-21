//
//  MessageDetailViewController.h
//  YYMiOS
//
//  Created by Lide on 14/12/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString        *_emUsername;
    
    UIView          *_footerView;
    UIView          *_textBackView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_messageDetailArray;
}

@property (retain, nonatomic) NSString *emUsername;

@end
