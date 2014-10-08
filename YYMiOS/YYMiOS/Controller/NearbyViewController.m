//
//  NearbyViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NearbyViewController.h"
#import "TabViewController.h"
#import "NearbyCell.h"

#import "FilterViewController.h"
#import "ShopViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickFilterButton:(id)sender
{
    FilterViewController *filterVC = [[[FilterViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:filterVC animated:YES];
}

- (void)clickMapButton:(id)sender
{
    
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _nearbyArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_nearbyArray addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", nil]];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"附近";
    _backButton.hidden = YES;
    
    _filterButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _filterButton.frame = CGRectMake(2, 2, 40, 40);
    _filterButton.backgroundColor = [UIColor clearColor];
    [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_filterButton addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_filterButton];
    
    _mapButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _mapButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _mapButton.backgroundColor = [UIColor clearColor];
    [_mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [_mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _mapButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_mapButton addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_mapButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 155;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nearbyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NearbyViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:shopVC animated:YES];
    
    return nil;
}

@end
