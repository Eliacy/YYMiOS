//
//  ArticleViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Article.h"

@interface ArticleViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger       _articleId;
    Article         *_article;
    
    UIButton        *_shareButton;
    
    UIView          *_footerView;
    UIView          *_textBackView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    
    NSMutableArray  *_commentArray;
    
    NSString        *_atListString;
}

@property (assign, nonatomic) NSInteger articleId;
@property (retain, nonatomic) Article *article;

@property (retain, nonatomic) NSString *atListString;

@end
