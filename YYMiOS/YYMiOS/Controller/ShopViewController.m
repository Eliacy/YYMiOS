//
//  ShopViewController.m
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopDealCell.h"
#import "DealDetailViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "Deal.h"

@interface ShopViewController () <UITextFieldDelegate>

@end

@implementation ShopViewController

@synthesize poiId = _poiId;
@synthesize poiDetail = _poiDetail;

#pragma mark - private

- (void)clickSendButton:(id)sender
{
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    [self sendMessage];
}

- (void)sendMessage
{
    
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.33
                     animations:^{
                         
                         if(_tableView.frame.size.height - _tableView.contentSize.height < keyboardSize.height - 44)
                         {
                             _tableView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardSize.height);
                         }
                         _footerView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardSize.height);
                         
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.33
                     animations:^{
                         
                         _tableView.transform = CGAffineTransformIdentity;
                         _footerView.transform = CGAffineTransformIdentity;
                         
                     }];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _dealArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"店铺主页";
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 240, 30)];
    _textField.backgroundColor = [UIColor blueColor];
    _textField.placeholder = @"说点啥吧";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    [_footerView addSubview:_textField];
    
    _sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _sendButton.frame = CGRectMake(_footerView.frame.size.width - 15 - 40, 10, 40, 30);
    _sendButton.backgroundColor = [UIColor brownColor];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_sendButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height - _footerView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 500)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 65, 65)];
    _logoImageView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_logoImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.frame.origin.x + _logoImageView.frame.size.width + 10, _logoImageView.frame.origin.y, _tableHeaderView.frame.size.width - _logoImageView.frame.origin.x - _logoImageView.frame.size.width - 15 - 10 - 15, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    [_tableHeaderView addSubview:_nameLabel];
    
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 30, _nameLabel.frame.size.width, 20)];
    _categoryLabel.backgroundColor = [UIColor clearColor];
    _categoryLabel.textColor = [UIColor grayColor];
    _categoryLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_categoryLabel];
    
    _environmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_categoryLabel.frame.origin.x, _categoryLabel.frame.origin.y + _categoryLabel.frame.size.height, _categoryLabel.frame.size.width, _categoryLabel.frame.size.height)];
    _environmentLabel.backgroundColor = [UIColor clearColor];
    _environmentLabel.textColor = [UIColor grayColor];
    _environmentLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_environmentLabel];
    
    _paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_environmentLabel.frame.origin.x, _environmentLabel.frame.origin.y + _environmentLabel.frame.size.height, _environmentLabel.frame.size.width, _environmentLabel.frame.size.height)];
    _paymentLabel.backgroundColor = [UIColor clearColor];
    _paymentLabel.textColor = [UIColor grayColor];
    _paymentLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_paymentLabel];
    
    _menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(_paymentLabel.frame.origin.x, _paymentLabel.frame.origin.y + _paymentLabel.frame.size.height, _paymentLabel.frame.size.width, _paymentLabel.frame.size.height)];
    _menuLabel.backgroundColor = [UIColor clearColor];
    _menuLabel.textColor = [UIColor grayColor];
    _menuLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_menuLabel];
    
    _ticketLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuLabel.frame.origin.x, _menuLabel.frame.origin.y + _menuLabel.frame.size.height, _menuLabel.frame.size.width, _menuLabel.frame.size.height)];
    _ticketLabel.backgroundColor = [UIColor clearColor];
    _ticketLabel.textColor = [UIColor grayColor];
    _ticketLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_ticketLabel];
    
    _bookingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_ticketLabel.frame.origin.x, _ticketLabel.frame.origin.y + _ticketLabel.frame.size.height, _ticketLabel.frame.size.width, _ticketLabel.frame.size.height)];
    _bookingLabel.backgroundColor = [UIColor clearColor];
    _bookingLabel.textColor = [UIColor grayColor];
    _bookingLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_bookingLabel];
    
    _businessHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bookingLabel.frame.origin.x, _bookingLabel.frame.origin.y + _bookingLabel.frame.size.height, _bookingLabel.frame.size.width, _bookingLabel.frame.size.height)];
    _businessHoursLabel.backgroundColor = [UIColor clearColor];
    _businessHoursLabel.textColor = [UIColor grayColor];
    _businessHoursLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_businessHoursLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_businessHoursLabel.frame.origin.x, _businessHoursLabel.frame.origin.y + _businessHoursLabel.frame.size.height, _businessHoursLabel.frame.size.width, _businessHoursLabel.frame.size.height)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.textColor = [UIColor grayColor];
    _phoneLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tableHeaderView addSubview:_phoneLabel];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height - 180, _tableHeaderView.frame.size.width, 180)];
    [_tableHeaderView addSubview:_mapView];
    
    _floatView = [[UIView alloc] initWithFrame:CGRectMake(0, _mapView.frame.size.height - 60, _mapView.frame.size.width, 60)];
    _floatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [_mapView addSubview:_floatView];
    
    _mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, _floatView.frame.size.width - 40 * 2, _floatView.frame.size.height)];
    _mapLabel.backgroundColor = [UIColor clearColor];
    _mapLabel.textColor = [UIColor darkGrayColor];
    _mapLabel.font = [UIFont systemFontOfSize:16.0f];
    [_floatView addSubview:_mapLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [POIDetail getPOIListWithPOIId:_poiId
                             brief:0
                            offset:0
                             limit:0
                           keyword:@""
                              area:0
                              city:0
                             range:-1
                          category:0
                             order:0
                         longitude:0
                          latitude:0
                           success:^(NSArray *array) {
                               
                               if([array count] > 0)
                               {
                                   self.poiDetail = [array objectAtIndex:0];
                               }
                               
                           } failure:^(NSError *error) {
                               
                           }];
    
    [Deal getDealDetailListWithBrief:1
                            selected:0
                           published:0
                              offset:0
                               limit:20
                                user:0
                                site:3422
                                city:0
                             success:^(NSArray *array) {
                                 
                                 [_dealArray removeAllObjects];
                                 [_dealArray addObjectsFromArray:array];
                                 [_tableView reloadData];
                                 
                             } failure:^(NSError *error) {
                                 
                             }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (void)setPoiDetail:(POIDetail *)poiDetail
{
    if(_poiDetail != nil)
    {
        LP_SAFE_RELEASE(_poiDetail);
    }
    _poiDetail = [poiDetail retain];
    
    [_logoImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:poiDetail.logo.imageURL imageSize:CGSizeMake(100, 100)]]];
    _nameLabel.text = poiDetail.name;
    
    if(poiDetail.categoryArray && [poiDetail.categoryArray count] > 0)
    {
        NSMutableString *mutableString = [NSMutableString string];
        for(NSInteger i = 0; i < [poiDetail.categoryArray count]; i++)
        {
            if(i == [poiDetail.categoryArray count] - 1)
            {
                [mutableString appendString:[poiDetail.categoryArray objectAtIndex:i]];
            }
            else
            {
                [mutableString appendString:[NSString stringWithFormat:@"%@｜", [poiDetail.categoryArray objectAtIndex:i]]];
            }
        }
    }
    if(poiDetail.environment && ![poiDetail.environment isEqualToString:@""])
    {
        _environmentLabel.text = [NSString stringWithFormat:@"环境：%@", poiDetail.environment];
    }
    if(poiDetail.paymentArray && [poiDetail.paymentArray count] > 0)
    {
        NSMutableString *mutableString = [NSMutableString string];
        [mutableString appendString:@"付款方式："];
        for(NSInteger i = 0; i < [poiDetail.paymentArray count]; i++)
        {
            if(i == [poiDetail.paymentArray count] - 1)
            {
                [mutableString appendString:[poiDetail.paymentArray objectAtIndex:i]];
            }
            else
            {
                [mutableString appendString:[NSString stringWithFormat:@"%@ ", [poiDetail.paymentArray objectAtIndex:i]]];
            }
        }
        _paymentLabel.text = mutableString;
    }
    if(poiDetail.menu && ![poiDetail.menu isEqualToString:@""])
    {
        _menuLabel.text = [NSString stringWithFormat:@"中文菜单：%@", poiDetail.menu];
    }
    if(poiDetail.ticket && ![poiDetail.ticket isEqualToString:@""])
    {
        _ticketLabel.text = [NSString stringWithFormat:@"门票：%@", poiDetail.ticket];
    }
    if(poiDetail.booking && ![poiDetail.booking isEqualToString:@""])
    {
        _bookingLabel.text = [NSString stringWithFormat:@"提前预定：%@", poiDetail.booking];
    }
    if(poiDetail.businessHours && ![poiDetail.businessHours isEqualToString:@""])
    {
        _businessHoursLabel.text = [NSString stringWithFormat:@"营业时间：%@", poiDetail.businessHours];
    }
    if(poiDetail.phone && ![poiDetail.phone isEqualToString:@""])
    {
        _phoneLabel.text = [NSString stringWithFormat:@"电话号码：%@", poiDetail.phone];
    }
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poiDetail.latitude, poiDetail.longitude) zoomLevel:13 animated:YES];
    _mapLabel.text = poiDetail.address;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dealArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[ShopDealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.deal = [_dealArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
    [self.navigationController pushViewController:dealDetailVC animated:YES];
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    [self sendMessage];
    
    return YES;
}

@end
