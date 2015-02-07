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

#define kRangeArray @[@"智能范围", @"1公里", @"2公里", @"5公里", @"20公里", @"50公里", @"全城"]
#define kOrderArray @[@"智能排序", @"离我最近", @"人气最高", @"评价最好"]

@interface FilterViewController ()

@end

@implementation FilterViewController
{
    NSMutableArray *filterData;
    RATreeView *filterTreeView;
    
    NSMutableArray *selectedAreaChildArray;
    NSMutableArray *selectedCategoryChildArray;
    NSMutableArray *selectedOrderChildArray;
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
        
        filterData = [[NSMutableArray alloc] init];
        
        selectedAreaChildArray = [[NSMutableArray alloc] init];
        selectedCategoryChildArray = [[NSMutableArray alloc] init];
        selectedOrderChildArray = [[NSMutableArray alloc] init];
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
    
    //树形结构视图
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
    
    //请求地区列表
    [self.view makeToastActivity];
    [City getCityListWithCityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        success:^(NSArray *array) {
                            
                            if([array count] > 0)
                            {
                                [_areaArray removeAllObjects];
                                [_areaArray addObjectsFromArray:[[array objectAtIndex:0] areaArray]];
                            }
                            
                            //请求分类列表
                            [Categories getCategoryListWithCategoryId:0
                                                              success:^(NSArray *array) {
                                                                  
                                                                  [_categoryArray removeAllObjects];
                                                                  
                                                                  Categories *category = [[[Categories alloc] init] autorelease];
                                                                  category.categoryId = 0;
                                                                  category.categoryName = @"全部分类";
                                                                  [_categoryArray addObject:category];
                                                                  [_categoryArray addObjectsFromArray:array];
                                                                  
                                                                  //刷新树形结构视图
                                                                  [self loadFilterData];
                                                                  [filterTreeView reloadData];
                                                                  
                                                                  [self.view hideToastActivity];
                                                              } failure:^(NSError *error) {
                                                                  [self.view hideToastActivity];
                                                              }];
                            
                        } failure:^(NSError *error) {
                            [self.view hideToastActivity];
                        }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 45;
}

#pragma mark -
#pragma mark - TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    //级数
    NSInteger level = [filterTreeView levelForCellForItem:item];
    
    //根据各层菜单中存储数据设置颜色
    UIColor *titleColor;
    if([selectedCategoryChildArray containsObject:dataObject]||[selectedAreaChildArray containsObject:dataObject]||[selectedOrderChildArray containsObject:dataObject]){
        titleColor = [UIColor redColor];
    }else{
        titleColor = [UIColor blackColor];
    }
    
    RATableViewCell *cell = [filterTreeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name titleColor:titleColor level:level];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [filterData count];
    }
    
    RADataObject *dataObject = item;
    return [dataObject.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *dataObject = item;
    if (item == nil) {
        return [filterData objectAtIndex:index];
    }
    return dataObject.children[index];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    //层级
    int level =  [treeView levelForCellForItem:item];
    //对象
    RADataObject *dataObject = item;
    
    /***********************************处理变色*****************************************/
    //1级
    if(level==1){
        //范围
        if([[[filterData objectAtIndex:0] children] containsObject:dataObject]){
            if(dataObject.children.count==0){
                [self saveAreaStateWithDataObject:dataObject];
            }
        }
        //分类
        if([[[filterData objectAtIndex:1] children] containsObject:dataObject]){
            if(dataObject.children.count==0){
                [self saveCategoryStateWithDataObject:dataObject];
            }
        }
        //排序
        if([[[filterData objectAtIndex:2] children] containsObject:dataObject]){
            if(dataObject.children.count==0){
                [self saveOrderStateWithDataObject:dataObject];
            }
        }
    }
    
    //2级
    if(level==2){
        //范围
        NSArray *areaArray = [[filterData objectAtIndex:0] children];
        for(RADataObject *areaData in areaArray){
            if([[areaData children] containsObject:dataObject]){
                [self saveAreaStateWithDataObject:dataObject];
            }
        }
        //分类 subCategoryArray
        NSArray *categoryArray = [[filterData objectAtIndex:1] children];
        for(RADataObject *categoryData in categoryArray){
            if([[categoryData children] containsObject:dataObject]){
                [self saveCategoryStateWithDataObject:dataObject];
            }
        }
    }
    
    /**************************************保存ID**********************************************/
    
    NSArray *areaArray = [[filterData objectAtIndex:0] children];
    NSArray *categoryArray = [[filterData objectAtIndex:1] children];
    NSArray *orderArray = [[filterData objectAtIndex:2] children];
    
    if(level==1||level==2){
        
        //范围id
        if(selectedAreaChildArray.count>0){
            if([kRangeArray containsObject:[[selectedAreaChildArray objectAtIndex:0] name]]){

                //kRangeArray
                _areaId = 0;
            }else{

                //Area
                for(int i=0;i<areaArray.count;i++){
                    RADataObject *areaObject = [areaArray objectAtIndex:i];
                    if(areaObject.children.count==0){
                        //2级
                        if([areaObject.name isEqualToString:[[selectedAreaChildArray objectAtIndex:0] name]]){
                            _areaId = [[_areaArray objectAtIndex:i-kRangeArray.count] areaId];
                        }
                    }else{
                        //3级
                        for(int j=0;j<areaObject.children.count;j++){
                            RADataObject *subAreaObject = [areaObject.children objectAtIndex:j];
                            if([subAreaObject.name isEqualToString:[[selectedAreaChildArray objectAtIndex:0] name]]){
                                NSArray *subAreaArray = [[_areaArray objectAtIndex:i-kRangeArray.count] areaChildren];
                                if(j!=0){
                                    //因全部**是再数据初始化时收到添加的 并非服务器返回数据 获取id时需要减去父节点（-1）
                                    _areaId = [[subAreaArray objectAtIndex:j-1] areaId];
                                }else{
                                    //全部**
                                    _areaId = [[_areaArray objectAtIndex:i-kRangeArray.count] areaId];
                                }

                            }
                        }
                    }
                }
            }
        }
        
        //分类id
        if(selectedCategoryChildArray.count>0){
            for(int i=0;i<categoryArray.count;i++){
                RADataObject *categoryObject = [categoryArray objectAtIndex:i];
                if(categoryObject.children.count==0){
                    //2级
                    if([categoryObject.name isEqualToString:[[selectedCategoryChildArray objectAtIndex:0] name]]){
                        _categoryId = [[_categoryArray objectAtIndex:i] categoryId];
                    }
                }else{
                    //3级
                    for(int j=0;j<categoryObject.children.count;j++){
                        RADataObject *subCategoyObject = [categoryObject.children objectAtIndex:j];
                        if([subCategoyObject.name isEqualToString:[[selectedCategoryChildArray objectAtIndex:0] name]]){
                            NSArray *subCategoyArray = [[_categoryArray objectAtIndex:i] subCategoryArray];
                            if(j!=0){
                                //因全部**是再数据初始化时收到添加的 并非服务器返回数据 获取id时需要减去父节点（-1）
                                _categoryId = [[subCategoyArray objectAtIndex:j-1] categoryId];
                            }else{
                                //全部**
                                _categoryId = [[_categoryArray objectAtIndex:i] categoryId];
                            }
                        }
                    }
                }
            }
        }
        
        //排序id
        if(selectedOrderChildArray.count>0){
            for(int i=0;i<orderArray.count;i++){
                RADataObject *orderObject = [orderArray objectAtIndex:i];
                if([orderObject.name isEqualToString:[[selectedOrderChildArray objectAtIndex:0] name]]){
                    _order = [kOrderArray indexOfObject:orderObject.name];
                }
            }
        }
    }
    
    
    [filterTreeView performSelector:@selector(reloadRows) withObject:nil afterDelay:.2];
}

#pragma mark - 记录所选范围
- (void)saveAreaStateWithDataObject:(RADataObject *)dataObject
{
    [selectedAreaChildArray removeAllObjects];
    [selectedAreaChildArray addObject:dataObject];

}

#pragma mark - 记录所选分类
- (void)saveCategoryStateWithDataObject:(RADataObject *)dataObject
{
    [selectedCategoryChildArray removeAllObjects];
    [selectedCategoryChildArray addObject:dataObject];
}

#pragma mark - 记录所选排序
- (void)saveOrderStateWithDataObject:(RADataObject *)dataObject
{
    [selectedOrderChildArray removeAllObjects];
    [selectedOrderChildArray addObject:dataObject];
}


#pragma mark - 初始化树形结构数据
- (void)loadFilterData
{
    //范围
    NSMutableArray *rangeMutableArray = [[[NSMutableArray alloc] init] autorelease];
    
    for(int i=0;i<kRangeArray.count;i++){
        RADataObject *range = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[kRangeArray objectAtIndex:i]] children:nil];
        [rangeMutableArray addObject:range];
    }
    
    for(int i=0;i<_areaArray.count;i++){
        Area *area = [_areaArray objectAtIndex:i];
        RADataObject *areaData = nil;
        
        if(area.areaChildren.count>0){
            NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
            //添加当前父节点到其子类列表中
            areaData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"全部%@",area.areaName] children:nil];
            [tempArray addObject:areaData];
            //添加其他子节点
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
        RADataObject *categoryData = nil;
        
        if(categories.subCategoryArray.count>0){
            NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
            //添加当前父节点到其子类列表中
            categoryData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"全部%@",categories.categoryName] children:nil];
            [tempArray addObject:categoryData];
            //添加其他子节点
            for(int i=0;i<categories.subCategoryArray.count;i++){
                categoryData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[[categories.subCategoryArray objectAtIndex:i] categoryName]] children:nil];
                [tempArray addObject:categoryData];
            }
            RADataObject *categoryList = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",categories.categoryName] children:tempArray];
            [categoryMutableArray addObject:categoryList];
        }else{
            categoryData = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",categories.categoryName] children:nil];
            [categoryMutableArray addObject:categoryData];
        }
        
    }
    RADataObject *categoryList = [RADataObject dataObjectWithName:@"分类" children:categoryMutableArray];
    
    //排序
    NSMutableArray *orderMutableArray = [[[NSMutableArray alloc] init] autorelease];

    for(int i=0;i<kOrderArray.count;i++){
        RADataObject *order = [RADataObject dataObjectWithName:[NSString stringWithFormat:@"%@",[kOrderArray objectAtIndex:i]] children:nil];
        [orderMutableArray addObject:order];
    }
    RADataObject *orderList = [RADataObject dataObjectWithName:@"排序" children:orderMutableArray];
    
    //数据汇总
    [filterData addObjectsFromArray:[NSArray arrayWithObjects:rangeList,categoryList,orderList, nil]];

}



@end
