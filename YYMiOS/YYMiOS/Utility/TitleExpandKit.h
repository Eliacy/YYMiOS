//
//  TitleExpandKit.h
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TitleExpandKitDelegate;

@interface TitleExpandKit : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    id<TitleExpandKitDelegate>  _delegate;
    
    UIView          *_backgroundView;
    UIView          *_blockView;
    
    UITableView     *_tableView;
    NSMutableArray  *_itemArray;
}

@property (assign, nonatomic) id<TitleExpandKitDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *itemArray;

+ (id)sharedKit;

- (void)show;
- (void)hide;

@end

@protocol TitleExpandKitDelegate <NSObject>

- (void)titleExpandKitDidSelectWithIndex:(NSIndexPath *)indexPath;

@end
