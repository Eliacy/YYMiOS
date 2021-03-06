//
//  DraftViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DraftViewController.h"
#import "DraftCell.h"
#import "DealEditViewController.h"

@interface DraftViewController ()

@end

@implementation DraftViewController

#pragma mark - private

- (void)clickAddButton:(id)sender
{
    DealEditViewController *dealEditVC = [[[DealEditViewController alloc] init] autorelease];
    [self.navigationController pushViewController:dealEditVC animated:YES];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _draftArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"草稿列表";
    
    _addButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _addButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _addButton.backgroundColor = [UIColor clearColor];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_addButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *draftArray = [LPUtility unarchiveDataFromCache:@"draft_list"];
    [_draftArray removeAllObjects];
    [_draftArray addObjectsFromArray:draftArray];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_draftArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DraftViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[DraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DraftViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.deal = [_draftArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealEditViewController *dealEditVC = [[[DealEditViewController alloc] init] autorelease];
    dealEditVC.deal = [_draftArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dealEditVC animated:YES];
    
    return nil;
}

@end
