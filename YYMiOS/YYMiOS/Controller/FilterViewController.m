//
//  FilterViewController.m
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "FilterViewController.h"
#import "Categories.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

#pragma mark - private

- (void)clickSearchButton:(id)sender
{

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
        _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _scaleExpandFlag = NO;
        _categoryExpandFlag = NO;
        _orderExpandFlag = NO;
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
    
    [Categories getCategoryListWithCategoryId:0
                                      success:^(NSArray *array) {
                                          
                                          [_categoryArray removeAllObjects];
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
    view.backgroundColor = [UIColor clearColor];
    
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
                return 10;
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
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"智能范围";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"1公里";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"2公里";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"5公里";
                }
                    break;
                case 4:
                {
                    cell.textLabel.text = @"20公里";
                }
                    break;
                case 5:
                {
                    cell.textLabel.text = @"50公里";
                }
                    break;
                case 6:
                {
                    cell.textLabel.text = @"全城";
                }
                    break;
                case 7:
                {
                    cell.textLabel.text = @"第五大道";
                }
                    break;
                case 8:
                {
                    cell.textLabel.text = @"麦迪逊大道";
                }
                    break;
                case 9:
                {
                    cell.textLabel.text = @"纽约下城区";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = [[_categoryArray objectAtIndex:indexPath.row] categoryName];
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"智能排序";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"离我最近";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"人气最高";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"评价最好";
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
    return nil;
}

@end
