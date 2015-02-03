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
{
    NSMutableArray *filterData;
    RATreeView *filterTreeView;
}

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
        
//        _scaleExpandFlag = NO;
//        _categoryExpandFlag = NO;
//        _orderExpandFlag = NO;
        
        filterData = [[NSMutableArray alloc] init];
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
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
//
//    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
//    tableFooterView.backgroundColor = [UIColor clearColor];
//    _tableView.tableFooterView = tableFooterView;
//
//    //范围
//    _scaleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    _scaleButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
//    _scaleButton.backgroundColor = [UIColor clearColor];
//    [_scaleButton addTarget:self action:@selector(clickScaleButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //分类
//    _categoryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    _categoryButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
//    _categoryButton.backgroundColor = [UIColor clearColor];
//    [_categoryButton addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //排序
//    _orderButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    _orderButton.frame = CGRectMake(0, 0, _tableView.frame.size.width, 40);
//    _orderButton.backgroundColor = [UIColor clearColor];
//    [_orderButton addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    
    filterTreeView = [[[RATreeView alloc] initWithFrame:CGRectMake(15, _adjustView.frame.size.height, self.view.frame.size.width-30, self.view.frame.size.height - _adjustView.frame.size.height)] autorelease];
    filterTreeView.backgroundColor = [UIColor whiteColor];
    filterTreeView.delegate = self;
    filterTreeView.dataSource = self;
    filterTreeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [filterTreeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    [filterTreeView registerClass:[RATableViewCell class] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    [self.view addSubview:filterTreeView];
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
                                          
                                      } failure:^(NSError *error) {
                                          
                                      }];
    
    [self performSelector:@selector(filterTreeViewReload) withObject:nil afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)] autorelease];
//    view.backgroundColor = GColor(136, 136, 136);
//    
//    switch (section) {
//        case 0:
//        {
//            //范围
//            [view addSubview:_scaleButton];
//            UILabel *scaleLabel = [Function createLabelWithFrame:view.frame FontSize:16 Text:@"范围"];
//            [view addSubview:scaleLabel];
//            if(_scaleExpandFlag){
//                scaleLabel.textColor = [UIColor whiteColor];
//            }else{
//                scaleLabel.textColor = GColor(191, 191, 191);
//            }
//        }
//            break;
//        case 1:
//        {
//            //分类
//            [view addSubview:_categoryButton];
//            UILabel *categoryLabel = [Function createLabelWithFrame:view.frame FontSize:16 Text:@"分类"];
//            [view addSubview:categoryLabel];
//            if(_categoryExpandFlag){
//                categoryLabel.textColor = [UIColor whiteColor];
//            }else{
//                categoryLabel.textColor = GColor(191, 191, 191);
//            }
//        }
//            break;
//        case 2:
//        {
//            //排序
//            [view addSubview:_orderButton];
//            UILabel *orderLabel = [Function createLabelWithFrame:view.frame FontSize:16 Text:@"排序"];
//            [view addSubview:orderLabel];
//            if(_orderExpandFlag){
//                orderLabel.textColor = [UIColor whiteColor];
//            }else{
//                orderLabel.textColor = GColor(191, 191, 191);
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return view;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    switch (section) {
//        case 0:
//        {
//            if(_scaleExpandFlag)
//            {
//                return [_rangeArray count] + [_areaArray count];
//            }
//            else
//            {
//                return 0;
//            }
//        }
//            break;
//        case 1:
//        {
//            if(_categoryExpandFlag)
//            {
//                return [_categoryArray count];
//            }
//            else
//            {
//                return 0;
//            }
//        }
//            break;
//        case 2:
//        {
//            if(_orderExpandFlag)
//            {
//                return 4;
//            }
//            else
//            {
//                return 0;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterViewControllerIdentifier"];
//    if(cell == nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterViewControllerIdentifier"] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    switch (indexPath.section) {
//        case 0:
//        {
//            if(indexPath.row < [_rangeArray count])
//            {
//                cell.textLabel.text = [_rangeArray objectAtIndex:indexPath.row];
//                if(indexPath.row == [_rangeArray count] - 1)
//                {
//                    if(_areaId == 0)
//                    {
//                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                    }
//                    else
//                    {
//                        cell.accessoryView = nil;
//                    }
//                }
//            }
//            else
//            {
//                cell.textLabel.text = [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaName];
//                if(_areaId == [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaId])
//                {
//                    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                }
//                else
//                {
//                    cell.accessoryView = nil;
//                }
//            }
//        }
//            break;
//        case 1:
//        {
//            cell.textLabel.text = [[_categoryArray objectAtIndex:indexPath.row] categoryName];
//            if(_categoryId == [[_categoryArray objectAtIndex:indexPath.row] categoryId])
//            {
//                cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//            }
//            else
//            {
//                cell.accessoryView = nil;
//            }
//        }
//            break;
//        case 2:
//        {
//            switch (indexPath.row) {
//                case 0:
//                {
//                    cell.textLabel.text = @"智能排序";
//                    if(_order == 0)
//                    {
//                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                    }
//                    else
//                    {
//                        cell.accessoryView = nil;
//                    }
//                }
//                    break;
//                case 1:
//                {
//                    cell.textLabel.text = @"离我最近";
//                    if(_order == 1)
//                    {
//                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                    }
//                    else
//                    {
//                        cell.accessoryView = nil;
//                    }
//                }
//                    break;
//                case 2:
//                {
//                    cell.textLabel.text = @"人气最高";
//                    if(_order == 2)
//                    {
//                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                    }
//                    else
//                    {
//                        cell.accessoryView = nil;
//                    }
//                }
//                    break;
//                case 3:
//                {
//                    cell.textLabel.text = @"评价最好";
//                    if(_order == 3)
//                    {
//                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirm.png"]] autorelease];
//                    }
//                    else
//                    {
//                        cell.accessoryView = nil;
//                    }
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.section)
//    {
//        case 0:
//        {
//            if(indexPath.row == [_rangeArray count] - 1)
//            {
//                _areaId = 0;
//            }
//            else if(indexPath.row >= [_rangeArray count])
//            {
//                _areaId = [[_areaArray objectAtIndex:(indexPath.row - [_rangeArray count])] areaId];
//            }
//        }
//            break;
//        case 1:
//        {
//            _categoryId = [[_categoryArray objectAtIndex:indexPath.row] categoryId];
//        }
//            break;
//        case 2:
//        {
//            _order = indexPath.row;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    [_tableView reloadData];
//    
//    return nil;
//}

#pragma mark -
#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 45;
}

#pragma mark -
#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    NSInteger level = [filterTreeView levelForCellForItem:item];
    RATableViewCell *cell = [filterTreeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name level:level];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [filterData count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [filterData objectAtIndex:index];
    }
    
    return data.children[index];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    int level =  [filterTreeView levelForCellForItem:item];
    GLog(@"level : %d",level);
}

#pragma mark - 初始化树形结构数据
- (void)loadFilterData
{
    //范围
    NSMutableArray *rangeMutableArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray *rangeArray = [NSArray arrayWithObjects:@"智能范围", @"1公里", @"2公里", @"5公里", @"20公里", @"50公里", @"全城", nil];
    for(int i=0;i<rangeArray.count;i++){
        RADataObject *range = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[rangeArray objectAtIndex:i]] children:nil];
        [rangeMutableArray addObject:range];
    }
    GLog(@"_areaArray.count : %d",_areaArray.count);
    for(int i=0;i<_areaArray.count;i++){
        Area *area = [_areaArray objectAtIndex:i];
        RADataObject *areaData = nil;
        
        if(area.areaChildren.count>0){
            NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
            for(int i=0;i<area.areaChildren.count;i++){
                areaData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[[area.areaChildren objectAtIndex:i] areaName]] children:nil];
                [tempArray addObject:areaData];
            }
            RADataObject *arrayList = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",area.areaName] children:tempArray];
            [rangeMutableArray addObject:arrayList];
        }else{
            areaData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",area.areaName] children:nil];
            [rangeMutableArray addObject:areaData];

        }
    }
    
    RADataObject *rangeList = [RADataObject dataObjectWithName:@"范围" children:rangeMutableArray];
    
    //分类
    NSMutableArray *categoryMutableArray = [[[NSMutableArray alloc] init] autorelease];
    for(int i=0;i<_categoryArray.count;i++){
        Categories *categories = [_categoryArray objectAtIndex:i];
        RADataObject *category = nil;
        
        if(categories.subCategoryArray.count>0){
            NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
            for(int i=0;i<categories.subCategoryArray.count;i++){
                category = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[[categories.subCategoryArray objectAtIndex:i] categoryName]] children:nil];
                [tempArray addObject:category];
            }
            RADataObject *categoryList = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",categories.categoryName] children:tempArray];
            [categoryMutableArray addObject:categoryList];
        }else{
            category = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",categories.categoryName] children:nil];
            [categoryMutableArray addObject:category];
        }
        
    }
    RADataObject *categoryList = [RADataObject dataObjectWithName:@"分类" children:categoryMutableArray];
    
    //排序
    NSMutableArray *orderMutableArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *orderArray = [NSArray arrayWithObjects:@"智能排序", @"离我最近", @"人气最高", @"评价最好", nil];
    for(int i=0;i<orderArray.count;i++){
        RADataObject *order = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[orderArray objectAtIndex:i]] children:nil];
        [orderMutableArray addObject:order];
    }
    RADataObject *orderList = [RADataObject dataObjectWithName:@"排序" children:orderMutableArray];
    
    //数据汇总
    [filterData addObjectsFromArray:[NSArray arrayWithObjects:rangeList,categoryList,orderList, nil]];

}


#pragma mark - 加载树结构数据
- (void)filterTreeViewReload
{
    [self loadFilterData];
    [filterTreeView reloadData];
}


@end
