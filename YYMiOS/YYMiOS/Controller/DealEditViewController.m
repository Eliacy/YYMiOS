//
//  DealEditViewController.m
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DealEditViewController.h"

@interface DealEditViewController ()

@end

@implementation DealEditViewController

@synthesize delegate = _delegate;

#pragma mark - private

- (void)clickDeleteButton:(id)sender
{
    
}

- (void)clickPublishButton:(id)sender
{
    
}

#pragma mark - super

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"编辑评论";
    
    _deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _deleteButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _deleteButton.backgroundColor = [UIColor clearColor];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_deleteButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 200)];
    _tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _tableFooterView;
    
    _publishButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _publishButton.frame = CGRectMake(40, _tableFooterView.frame.size.height - 40, _tableFooterView.frame.size.width - 40 * 2, 40);
    _publishButton.backgroundColor = [UIColor redColor];
    [_publishButton setTitle:@"发布评论" forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(clickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_publishButton];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealEditViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealEditViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"选择店铺";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"我要@TA";
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
