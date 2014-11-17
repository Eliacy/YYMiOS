//
//  DynamicViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DynamicViewController.h"
#import "TabViewController.h"
#import "DynamicCell.h"

#import "DealDetailViewController.h"
#import "Deal.h"

@interface DynamicViewController ()

@end

@implementation DynamicViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickBestButton:(id)sender
{

}

- (void)clickAddButton:(id)sender
{

}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"动态";
    _backButton.hidden = YES;
    
    _bestButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _bestButton.frame = CGRectMake(2, 2, 40, 40);
    _bestButton.backgroundColor = [UIColor clearColor];
    [_bestButton setTitle:@"精选" forState:UIControlStateNormal];
    [_bestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bestButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_bestButton addTarget:self action:@selector(clickBestButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_bestButton];
    
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
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 10)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
    
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:0
                            published:0
                               offset:0
                                limit:20
                                 user:0
                                 site:0
                                 city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                              success:^(NSArray *array) {
                                  
                                  [_dynamicArray removeAllObjects];
                                  [_dynamicArray addObjectsFromArray:array];
                                  [_tableView reloadData];
                                  
                              } failure:^(NSError *error) {
                                  
                              }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!_isAppear)
    {
        return;
    }
    _isAppear = NO;
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
    return 445.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dynamicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.deal = [_dynamicArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
    dealDetailVC.dealId = [[_dynamicArray objectAtIndex:indexPath.row] dealId];
    dealDetailVC.siteId = [[[_dynamicArray objectAtIndex:indexPath.row] site] siteId];
    [self.tabVC.navigationController pushViewController:dealDetailVC animated:YES];
    
    return nil;
}

@end
