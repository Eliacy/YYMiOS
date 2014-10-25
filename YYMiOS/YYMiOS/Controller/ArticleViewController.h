//
//  ArticleViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface ArticleViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton        *_shareButton;
    
    UIView          *_footerView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    
    UIView          *_tableHeaderView;
    UIView          *_headerBackView;
    
    NSMutableArray  *_commentArray;
}

@end
