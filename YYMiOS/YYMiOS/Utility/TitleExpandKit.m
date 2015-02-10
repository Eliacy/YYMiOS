//
//  TitleExpandKit.m
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TitleExpandKit.h"

@implementation TitleExpandKit

@synthesize delegate = _delegate;

#pragma mark - public

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _itemArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height)];
        _blockView.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_blockView];
        
        UITapGestureRecognizer *tapBlockView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlockView:)];
        [_blockView addGestureRecognizer:tapBlockView];
        [tapBlockView release];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(75, 75, _backgroundView.frame.size.width - 75 * 2, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_backgroundView addSubview:_tableView];
    }
    
    return self;
}

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_backgroundView];
}

- (void)hide
{
    
    [_backgroundView removeFromSuperview];
    
}

- (void)setAlign:(YYMExpandAlign)align
{
    switch (align) {
        case YYMExpandAlignLeft:
            _tableView.frame = CGRectMake(5, 75, _tableView.frame.size.width, _tableView.frame.size.height);
            break;
        case YYMExpandAlignCenter:
            _tableView.frame = CGRectMake(75, 75, _tableView.frame.size.width, _tableView.frame.size.height);
            break;
        case YYMExpandAlignRight:
            _tableView.frame = CGRectMake(145, 75, _tableView.frame.size.width, _tableView.frame.size.height);
            break;
            
        default:
            break;
    }
}

- (void)setWidth:(NSInteger)width
{
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, width, _tableView.frame.size.height);
}

- (void)setItemArray:(NSMutableArray *)itemArray
{
    [_itemArray removeAllObjects];
    [_itemArray addObjectsFromArray:itemArray];
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, 44 * [itemArray count]);
    [_tableView reloadData];
}

#pragma mark - UIGestureRecognizer

- (void)tapBlockView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hide];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleExpandKitIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleExpandKitIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [[_itemArray objectAtIndex:indexPath.row] title];
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide];
    
    if(_delegate && [_delegate respondsToSelector:@selector(titleExpandKitDidSelectWithIndex:)])
    {
        [_delegate titleExpandKitDidSelectWithIndex:indexPath];
    }
    
    return nil;
}

@end
