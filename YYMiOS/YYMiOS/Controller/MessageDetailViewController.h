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
    
    UITableView     *_tableView;
    NSMutableArray  *_messageDetailArray;
}

@property (retain, nonatomic) NSString *emUsername;

@end
