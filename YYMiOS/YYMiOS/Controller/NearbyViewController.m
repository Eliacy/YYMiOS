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
#import "POI.h"

#import "FilterViewController.h"
#import "NearbyMapViewController.h"
#import "ShopViewController.h"
#import "SearchCell.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController
{
    NSArray *data;
    NSArray *filterData;
    UISearchBar *searchBar;
    UITableView *searchTableView;
    UISearchDisplayController *searchDisplayController;
    UIButton *cancelBtn;
    UIButton *searchBtn;
}

@synthesize tabVC = _tabVC;

@synthesize areaId = _areaId;
@synthesize categoryId = _categoryId;
@synthesize order = _order;

#pragma mark - private

- (void)clickFilterButton:(id)sender
{
    FilterViewController *filterVC = [[[FilterViewController alloc] init] autorelease];
    
    filterVC.areaId = _areaId;
    filterVC.categoryId = _categoryId;
    filterVC.order = _order;
    filterVC.nearbyVC = self;
    
    [self.tabVC.navigationController pushViewController:filterVC animated:YES];
}

- (void)clickMapButton:(id)sender
{
    NearbyMapViewController *nearbyMapVC = [[[NearbyMapViewController alloc] init] autorelease];
    nearbyMapVC.nearbyArray = _nearbyArray;
    [self.tabVC.navigationController pushViewController:nearbyMapVC animated:YES];
}

#pragma mark - 取消
- (void)clickCancelButton:(id)sender
{
    searchTableView.hidden = YES;
    cancelBtn.hidden = YES;
    searchBtn.hidden = YES;
    _filterButton.hidden = NO;
    _mapButton.hidden = NO;
    [searchBar resignFirstResponder];
    
}
#pragma mark - 搜索
- (void)clickSearchButton:(id)sender
{
    searchTableView.hidden = YES;
    cancelBtn.hidden = YES;
    searchBtn.hidden = YES;
    _filterButton.hidden = NO;
    _mapButton.hidden = NO;
    [searchBar resignFirstResponder];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _nearbyArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"附近";
    _backButton.hidden = YES;
    
    _filterButton = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
    _filterButton.frame = CGRectMake(2, 2, 40, 40);
    _filterButton.backgroundColor = [UIColor clearColor];
    [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_filterButton addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_filterButton];
    
    _mapButton = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
    _mapButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _mapButton.backgroundColor = [UIColor clearColor];
    [_mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [_mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _mapButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_mapButton addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_mapButton];
    
    //附近视图
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _slimeView = [[[SRRefreshView alloc] init] autorelease];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:187.0 / 255.0 green:187.0 / 255.0 blue:187.0 / 255.0 alpha:1.0];
    _slimeView.slime.skinColor = [UIColor colorWithRed:187.0 / 255.0 green:187.0 / 255.0 blue:187.0 / 255.0 alpha:1.0];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor clearColor];
    [_tableView addSubview:_slimeView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
    
    //搜索取消
    cancelBtn = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
    cancelBtn.frame = CGRectMake(2, 2, 40, 40);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [cancelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:cancelBtn];
    cancelBtn.hidden = YES;
    //搜索确认
    searchBtn = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
    searchBtn.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [searchBtn addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:searchBtn];
    searchBtn.hidden = YES;
    //搜索控件
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(65, 0, 200, 28)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @"输入店铺名或地点";
    searchBar.backgroundImage = [Function createImageWithColor:GColor(251, 100, 129)];
    searchBar.delegate = self;
    [_headerView addSubview:searchBar];
    //搜索视图
    data = [[NSArray alloc] initWithObjects:@"1",@"2",@"333",@"44",@"55",@"6666",@"777",@"8",@"3",@"44",@"1111",@"11",@"111", nil];
    searchDisplayController = [[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] autorelease];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    //搜索列表
    searchTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.backgroundView = nil;
    searchTableView.backgroundColor = GColor(246, 246, 246);
    searchTableView.hidden = YES;
    [self.view addSubview:searchTableView];
    
    UIView *searchHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, searchTableView.frame.size.width, 150)] autorelease];
    searchHeaderView.backgroundColor = [UIColor clearColor];
    searchTableView.tableHeaderView = searchHeaderView;
    //提示
    UILabel *promptTitlelabel = [Function createLabelWithFrame:CGRectMake(10, 10, 40, 20) FontSize:16 Text:@"提示:"];
    [searchHeaderView addSubview:promptTitlelabel];
    //提示内容
    UILabel *promptContentlabel = [Function createLabelWithFrame:CGRectMake(30, 30, 240, 85) FontSize:16 Text:@"如果要切换到当前正在搜索的城市，请点击首页功能最上方的城市名进行切换"];
    promptContentlabel.textColor = GColor(149, 149, 149);
    promptContentlabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptContentlabel.numberOfLines = 0;
    [searchHeaderView addSubview:promptContentlabel];
    //搜索历史
    UILabel *historyLabel = [Function createLabelWithFrame:CGRectMake(10, searchHeaderView.frame.size.height-30, 80, 20) FontSize:16 Text:@"搜索历史:"];
    [searchHeaderView addSubview:historyLabel];
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
    
    if([_nearbyArray count] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_nearby_data"] boolValue] == YES)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"refresh_nearby_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [POI getPOIListWithOffset:0
                            limit:20
                          keyword:@""
                             area:_areaId
                             city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                            range:-1
                         category:_categoryId
                            order:_order
                        longitude:0
                         latitude:0
                          success:^(NSArray *array) {
                              
                              [_nearbyArray removeAllObjects];
                              [_nearbyArray addObjectsFromArray:array];
                              [_tableView reloadData];
                              
                              if([array count] < 20)
                              {
                                  _isHaveMore = NO;
                              }
                              else
                              {
                                  _isHaveMore = YES;
                              }
                              
                          } failure:^(NSError *error) {
                              
                          }];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    
    if(_tableView.contentOffset.y + _tableView.frame.size.height > _tableView.contentSize.height - 500 && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        [self loadMore];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - SlimeRefreshDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:0
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    [self performSelector:@selector(refreshAfterPull) withObject:nil afterDelay:0];
}

- (void)refreshAfterPull
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    [POI getPOIListWithOffset:0
                        limit:20
                      keyword:@""
                         area:_areaId
                         city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        range:-1
                     category:_categoryId
                        order:_order
                    longitude:0
                     latitude:0
                      success:^(NSArray *array) {
                          
                          _isLoading = NO;
                          
                          [_nearbyArray removeAllObjects];
                          [_nearbyArray addObjectsFromArray:array];
                          [_tableView reloadData];
                          
                          if([array count] < 20)
                          {
                              _isHaveMore = NO;
                          }
                          else
                          {
                              _isHaveMore = YES;
                          }
                          
                      } failure:^(NSError *error) {
                          
                          _isLoading = NO;
                          
                      }];
}

- (void)loadMore
{
    if(!_isHaveMore)
    {
        return;
    }
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    [POI getPOIListWithOffset:[_nearbyArray count]
                        limit:20
                      keyword:@""
                         area:_areaId
                         city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        range:-1
                     category:_categoryId
                        order:_order
                    longitude:0
                     latitude:0
                      success:^(NSArray *array) {
                          
                          _isLoading = NO;
                          
                          [_nearbyArray addObjectsFromArray:array];
                          [_tableView reloadData];
                          
                          if([array count] < 20)
                          {
                              _isHaveMore = NO;
                          }
                          else
                          {
                              _isHaveMore = YES;
                          }
                          
                      } failure:^(NSError *error) {
                          
                          _isLoading = NO;
                          
                      }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView){
        return 155;
    }else{
        return 45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView){
        //主视图
        return [_nearbyArray count];
    }else if (tableView == searchTableView){
        //搜索列表
        return data.count;
    }else{
        //筛选
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]] autorelease];
        return filterData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView){
        //附近主视图
        NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyViewControllerIdentifier"];
        if(cell == nil)
        {
            cell = [[[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NearbyViewControllerIdentifier"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.poi = [_nearbyArray objectAtIndex:indexPath.row];
        if(cell.poi.keywordArray && [cell.poi.keywordArray isKindOfClass:[NSArray class]] && [cell.poi.keywordArray count] > 0)
        {
            cell.keywordImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)indexPath.row % 6 + 1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        }
        else
        {
            cell.keywordImageView.image = nil;
        }
        return cell;
    }else if(tableView == searchTableView){
        //搜索列表
        NSString *CellIdentifier = @"SearchCell";
        SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        cell.textLabel.text = data[indexPath.row];
        return cell;
    }else{
        //筛选列表
        NSString *CellIdentifier = @"SearchCell";
        SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        cell.textLabel.text = filterData[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    shopVC.poiId = [[_nearbyArray objectAtIndex:indexPath.row] poiId];
    [self.tabVC.navigationController pushViewController:shopVC animated:YES];
    
    return nil;
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _filterButton.hidden = YES;
    _mapButton.hidden = YES;
    searchTableView.hidden = NO;
    cancelBtn.hidden = NO;
    searchBtn.hidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //隐藏HeaderView
//    if(searchTableView.tableHeaderView.hidden == NO){
//        searchTableView.tableHeaderView.hidden = YES;
//    }
    //过滤文字
    
    //刷新列表
}


@end
