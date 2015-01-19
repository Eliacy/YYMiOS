//
//  FilterViewController.m
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "FilterViewController.h"
#import "Categories.h"
#import "City.h"
#import "Area.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize areaId = _areaId;
@synthesize categoryId = _categoryId;
@synthesize order = _order;

@synthesize nearbyVC = _nearbyVC;

#pragma mark - private

- (void)clickSearchButton:(id)sender
{
    if(_nearbyVC != nil)
    {
        _nearbyVC.areaId = _areaId;
        _nearbyVC.categoryId = _categoryId;
        _nearbyVC.order = _order;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"refresh_nearby_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickScaleButton:(id)sender
{
    _scaleExpandFlag = !_scaleExpandFlag;
    [_tableView reloadData];
}

- (void)clickCategoryButton:(id)sender
{
    _categoryExpandFlag = !_categoryExpandFlag;
    [_tableView reloadData];
}

- (void)clickOrderButton:(id)sender
{
    _orderExpandFlag = !_orderExpandFlag;
    [_tableView reloadData];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _rangeArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_rangeArray addObjectsFromArray:[NSArray arrayWithObjects:@"智能范围", @"1公里", @"2公里", @"5公里", @"20公里", @"50公里", @"全城", nil]];
        
        _areaArray = [[NSMutableArray alloc] initWithCapacity:0];
        _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _scaleExpandFlag = YES;
        _categoryExpandFlag = YES;
        _orderExpandFlag = YES;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"筛选";
    
    _searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _searchButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _searchButton.backgroundColor = [UIColor clearColor];
    [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_searchButton addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_searchButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
    
    _scaleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _scaleButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
    _scaleButton.backgroundColor = [UIColor clearColor];
    [_scaleButton setTitle:@"范围" forState:UIControlStateNormal];
    [_scaleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_scaleButton addTarget:self action:@selector(clickScaleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _categoryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _categoryButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
    _categoryButton.backgroundColor = [UIColor clearColor];
    [_categoryButton setTitle:@"分类" forState:UIControlStateNormal];
    [_categoryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_categoryButton addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _orderButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
    _orderButton.backgroundColor = [UIColor clearColor];
    [_orderButton setTitle:@"排序" forState:UIControlStateNormal];
    [_orderButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_orderButton addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [City getCityListWithCityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        success:^(NSArray *array) {
                            
                           if([array count] > 0)
                           {
                               [_areaArray removeAllObjects];
                               [_areaArray addObjectsFromArray:[[array objectAtIndex:0] areaArray]];
                               [_tableView reloadData];
                           }
                            
                        } failure:^(NSError *error) {
                            
                        }];
    
    [Categories getCategoryListWithCategoryId:0
                                      success:^(NSArray *array) {
                                          
                                          [_categoryArray removeAllObjects];
                                          
                                          Categories *category = [[[Categories alloc] init] autorelease];
                                          category.categoryId = 0;
                                          category.categoryName = @"全部分类";
                                          [_categoryArray addObject:category];
                                          [_categoryArray addObjectsFromArray:array];
                                          [_tableView reloadData];
                                          
                                      } failure:^(NSError *error) {
                                          
                                      }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)] autorelease];
    view.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    
    switch (section) {
        case 0:
        {
            [view addSubview:_scaleButton];
        }
            break;
        case 1:
        {
            [view addSubview:_categoryButton];
        }
            break;
        case 2:
        {
            [view addSubview:_orderButton];
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if(_scaleExpandFlag)
            {
                return [_rangeArray count] + [_areaArray count];
            }
            else
            {
                return 0;
            }
        }
            break;
        case 1:
        {
            if(_categoryExpandFlag)
            {
                return [_categoryArray count];
            }
            else
            {
                return 0;
            }
        }
            break;
        case 2:
        {
            if(_orderExpandFlag)
            {
                return 4;
            }
            else
            {
                return 0;
            }
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row < [_rangeArray count])
            {
                cell.textLabel.text = [_rangeArray objectAtIndex:indexPath.row];
                if(indexPath.row == [_rangeArray count] - 1)
                {
                    if(_areaId == 0)
                    {
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                    }
                    else
                    {
                        cell.accessoryView = nil;
                    }
                }
            }
            else
            {
                cell.textLabel.text = [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaName];
                if(_areaId == [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaId])
                {
                    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                }
                else
                {
                    cell.accessoryView = nil;
                }
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = [[_categoryArray objectAtIndex:indexPath.row] categoryName];
            if(_categoryId == [[_categoryArray objectAtIndex:indexPath.row] categoryId])
            {
                cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
            }
            else
            {
                cell.accessoryView = nil;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"智能排序";
                    if(_order == 0)
                    {
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                    }
                    else
                    {
                        cell.accessoryView = nil;
                    }
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"离我最近";
                    if(_order == 1)
                    {
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                    }
                    else
                    {
                        cell.accessoryView = nil;
                    }
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"人气最高";
                    if(_order == 2)
                    {
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                    }
                    else
                    {
                        cell.accessoryView = nil;
                    }
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"评价最好";
                    if(_order == 3)
                    {
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
                    }
                    else
                    {
                        cell.accessoryView = nil;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if(indexPath.row == [_rangeArray count] - 1)
            {
                _areaId = 0;
            }
            else if(indexPath.row >= [_rangeArray count])
            {
                _areaId = [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaId];
            }
        }
            break;
        case 1:
        {
            _categoryId = [[_categoryArray objectAtIndex:indexPath.row] categoryId];
        }
            break;
        case 2:
        {
            _order = indexPath.row;
        }
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
    
    return nil;
}

@end
