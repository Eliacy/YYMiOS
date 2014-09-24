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

@interface DynamicViewController ()

@end

@implementation DynamicViewController

@synthesize tabVC = _tabVC;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_dynamicArray addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil]];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"动态";
    _backButton.hidden = YES;
    
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
