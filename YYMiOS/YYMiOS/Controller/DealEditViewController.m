//
//  DealEditViewController.m
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DealEditViewController.h"
#import "POISelectViewController.h"

@interface DealEditViewController () <POISelectViewControllerDelegate, UITextViewDelegate>

@end

@implementation DealEditViewController

@synthesize delegate = _delegate;
@synthesize deal = _deal;

#pragma mark - private

- (void)clickBackButton:(id)sender
{
    [super clickBackButton:sender];
    
    if(_deal.site != nil)
    {
        NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
        
        for(Deal *deal in draftArray)
        {
            if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
            {
                [draftArray removeObject:deal];
                break;
            }
        }
        
        [draftArray insertObject:_deal atIndex:0];
        [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
    }
}

- (void)clickDeleteButton:(id)sender
{
    if(_deal.site != nil)
    {
        NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
        
        for(Deal *deal in draftArray)
        {
            if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
            {
                [draftArray removeObject:deal];
                break;
            }
        }
        
        [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPublishButton:(id)sender
{
    if(_deal.site == nil || [_deal.site.siteName isEqualToString:@""] || [_deal.content isEqualToString:@""])
    {
        [self.view hideToast];
        [self.view makeToast:@"发送内容不完整" duration:1.5 position:@"center"];
        
        return;
    }
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    [Deal createDealDetailWithPublished:0
                                 userId:[[User sharedUser] userId]
                                 atList:nil
                                   star:0
                                content:_deal.content
                                 images:nil
                               keywords:nil
                                  total:0
                               currency:nil
                                 siteId:_deal.site.siteId
                                success:^(NSArray *array) {
                                    
                                    NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
                                    
                                    for(Deal *deal in draftArray)
                                    {
                                        if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
                                        {
                                            [draftArray removeObject:deal];
                                            break;
                                        }
                                    }
                                    
                                    [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
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
    
    UIView *tapView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableFooterView.frame.size.width, _tableFooterView.frame.size.height)] autorelease];
    tapView.backgroundColor = [UIColor clearColor];
    [_tableFooterView addSubview:tapView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [tapView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, _tableFooterView.frame.size.width - 15 * 2, 70)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.delegate = self;
    [_tableFooterView addSubview:_textView];
    
    _publishButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _publishButton.frame = CGRectMake(40, _tableFooterView.frame.size.height - 40, _tableFooterView.frame.size.width - 40 * 2, 40);
    _publishButton.backgroundColor = [UIColor redColor];
    [_publishButton setTitle:@"发布评论" forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(clickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_publishButton];
    
    if(self.deal == nil)
    {
        self.deal = [[Deal alloc] init];
        self.deal.dealKey = [NSString stringWithFormat:@"%i_%i", (int)[[NSDate date] timeIntervalSince1970], arc4random()];
    }
    
    [self refreshData];
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

- (void)refreshData
{
    _textView.text = _deal.content;
}

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
            if(_deal.site.siteName && ![_deal.site.siteName isEqualToString:@""])
            {
                cell.textLabel.text = _deal.site.siteName;
            }
            else
            {
                cell.textLabel.text = @"选择店铺";
            }
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
    switch (indexPath.row) {
        case 0:
        {
            POISelectViewController *poiSelectVC = [[[POISelectViewController alloc] init] autorelease];
            poiSelectVC.delegate = self;
            [self.navigationController pushViewController:poiSelectVC animated:YES];
        }
            break;
        case 1:
        {
        
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - POISelectViewControllerDelegate

- (void)poiSelectViewControllerDidSelectPOI:(POI *)poi
{
    if(_deal.site == nil)
    {
        _deal.site = [[Site alloc] init];
    }
    
    _deal.site.siteId = poi.poiId;
    _deal.site.siteName = poi.name;
    
    [_tableView reloadData];
}

#pragma mark - UIGestureRecognizer

- (void)tapView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if([_textView isFirstResponder])
        {
            [_textView resignFirstResponder];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _deal.content = textView.text;
}

@end
