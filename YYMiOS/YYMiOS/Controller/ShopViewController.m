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
#import "POIAnnotation.h"
#import "ShopPictureViewController.h"
#import "ShopMapViewController.h"
#import "ShareKit.h"
#import "Share.h"

@interface ShopViewController () <UITextFieldDelegate>

@end

@implementation ShopViewController

@synthesize poiId = _poiId;
@synthesize poiDetail = _poiDetail;

#pragma mark - private

- (void)clickShareButton:(id)sender
{
    [[ShareKit sharedKit] show];
    //share
//    [Share shareSomethingWithUserId:[[User sharedUser] userId]
//                             siteId:_poiId
//                           reviewId:0
//                          articleId:0
//                             target:@"微信"
//                            success:^(NSArray *array) {
//                                
//                            } failure:^(NSError *error) {
//                                
//                            }];
    [[ShareKit sharedKit] setArticleId:0];
    [[ShareKit sharedKit] setReviewId:0];
    [[ShareKit sharedKit] setSiteId:_poiId];
}

- (void)clickFavouriteButton:(id)sender
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    if(_poiDetail.favorited)
    {
        [POI cancelCollectPOIWithUserId:[[User sharedUser] userId]
                                  POIId:_poiId
                                success:^(NSArray *array) {
                                    
                                    _isLoading = NO;
                                    
                                    _poiDetail.favorited = 0;
                                    [_favouriteButton setTitle:@"收藏" forState:UIControlStateNormal];
                                    
                                } failure:^(NSError *error) {
                                   
                                    _isLoading = NO;
                                    
                                }];
    }
    else
    {
        [POI collectPOIWithUserId:[[User sharedUser] userId]
                            POIId:_poiId
                          success:^(NSArray *array) {
                              
                              _isLoading = NO;
                              
                              _poiDetail.favorited = 1;
                              [_favouriteButton setTitle:@"取消" forState:UIControlStateNormal];
                              
                          } failure:^(NSError *error) {
                              
                              _isLoading = NO;
                              
                          }];
    }
}

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
    
    _titleLabel.text = @"详情";
    
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _shareButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40 - 2 - 40, 2, 40, 40);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_shareButton];
    
    _favouriteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _favouriteButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _favouriteButton.backgroundColor = [UIColor clearColor];
    [_favouriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_favouriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _favouriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_favouriteButton addTarget:self action:@selector(clickFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_favouriteButton];
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)] autorelease];
    line.backgroundColor = [UIColor lightGrayColor];
    [_footerView addSubview:line];
    
    _textBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 240, 30)];
    _textBackView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _textBackView.layer.borderWidth = 0.5;
    _textBackView.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    _textBackView.layer.cornerRadius = 3.0;
    _textBackView.layer.masksToBounds = YES;
    [_footerView addSubview:_textBackView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(6, 4, 228, 24)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.placeholder = @"点评晒单";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    [_textBackView addSubview:_textField];
    
    _sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _sendButton.frame = CGRectMake(_footerView.frame.size.width - 15 - 40, 10, 40, 30);
    _sendButton.backgroundColor = [UIColor colorWithRed:252.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _sendButton.layer.cornerRadius = 3.0;
    _sendButton.layer.masksToBounds = YES;
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
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 68, 68)];
    _logoImageView.backgroundColor = [UIColor clearColor];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.layer.masksToBounds = YES;
    [_tableHeaderView addSubview:_logoImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.frame.origin.x + _logoImageView.frame.size.width + 10, _logoImageView.frame.origin.y, 230, 15)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [_tableHeaderView addSubview:_nameLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tableHeaderView.frame.size.width - 8 - 15, 8, 15, 15)];
    _levelLabel.backgroundColor = [UIColor clearColor];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.font = [UIFont systemFontOfSize:12.0f];
    _levelLabel.textAlignment = NSTextAlignmentCenter;
    
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_levelLabel.frame.origin.x, _levelLabel.frame.origin.y + (_levelLabel.frame.size.height - 15) / 3, _levelLabel.frame.size.width, 15)];
    _levelImageView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_levelImageView];
    [_tableHeaderView addSubview:_levelLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 15, 70, 10)];
    _starView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_starView];
    
    _reviewButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _reviewButton.frame = CGRectMake(_starView.frame.origin.x + _starView.frame.size.width + 10, _starView.frame.origin.y, 100, 12);
    [_reviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_reviewButton setImage:[UIImage imageNamed:@"talk_gray.png"] forState:UIControlStateNormal];
    [_reviewButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    _reviewButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_tableHeaderView addSubview:_reviewButton];
    
    _shopDetailView = [[ShopDetailView alloc] initWithFrame:CGRectMake(_starView.frame.origin.x, _starView.frame.origin.y + _starView.frame.size.height + 12, _tableHeaderView.frame.size.width - _starView.frame.origin.x - 8, 160)];
    _shopDetailView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_shopDetailView];
    
    _descriptionBackView = [[UIView alloc] initWithFrame:CGRectMake(12, _shopDetailView.frame.origin.y + _shopDetailView.frame.size.height + 8, _tableHeaderView.frame.size.width - 12 * 2, 50)];
    _descriptionBackView.backgroundColor = [UIColor clearColor];
    _descriptionBackView.layer.borderWidth = 0.5;
    _descriptionBackView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [_tableHeaderView addSubview:_descriptionBackView];
    
    _descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(12 + _descriptionBackView.frame.origin.x, -10 + _descriptionBackView.frame.origin.y, 45, 20)];
    _descriptionHeaderLabel.backgroundColor = _tableHeaderView.backgroundColor;
    _descriptionHeaderLabel.textColor = [UIColor darkGrayColor];
    _descriptionHeaderLabel.font = [UIFont systemFontOfSize:16.0f];
    _descriptionHeaderLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionHeaderLabel.text = @"简介";
    [_tableHeaderView addSubview:_descriptionHeaderLabel];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, _descriptionBackView.frame.size.width - 12 * 2, _descriptionBackView.frame.size.height - 12 * 2)];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = [UIColor darkGrayColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    _descriptionLabel.numberOfLines = 0;
    [_descriptionBackView addSubview:_descriptionLabel];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height - 140, _tableHeaderView.frame.size.width, 140)];
    _mapView.delegate = self;
    [_tableHeaderView addSubview:_mapView];
    
    _floatView = [[UIView alloc] initWithFrame:CGRectMake(0, _mapView.frame.size.height - 60, _mapView.frame.size.width, 60)];
    _floatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [_mapView addSubview:_floatView];
    
    _mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, _floatView.frame.size.width - 40 * 2, _floatView.frame.size.height)];
    _mapLabel.backgroundColor = [UIColor clearColor];
    _mapLabel.textColor = [UIColor blackColor];
    _mapLabel.font = [UIFont systemFontOfSize:14.0f];
    [_floatView addSubview:_mapLabel];
    
    _mapTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height)];
    _mapTapView.backgroundColor = [UIColor clearColor];
    [_mapView addSubview:_mapTapView];
    
    UITapGestureRecognizer *mapViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapView:)];
    [_mapView addGestureRecognizer:mapViewTap];
    [mapViewTap release];
    
    _keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, _mapView.frame.origin.y + _mapView.frame.size.height, _tableHeaderView.frame.size.width, 20)];
    _keywordView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_keywordView];
    
    _topImageView = [[UIView alloc] initWithFrame:CGRectMake(0, _keywordView.frame.origin.y + _keywordView.frame.size.height, _tableHeaderView.frame.size.width, 100)];
    _topImageView.backgroundColor = [UIColor clearColor];
    [_tableHeaderView addSubview:_topImageView];
    
    UITapGestureRecognizer *topImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopImageView:)];
    [_topImageView addGestureRecognizer:topImageViewTap];
    [topImageViewTap release];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
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
    
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:0
                            published:0
                               offset:0
                                limit:20
                                 user:0
                                 site:_poiId
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
    
    if(poiDetail.favorited)
    {
        [_favouriteButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_favouriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
    [_logoImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:poiDetail.logo.imageURL imageSize:CGSizeMake(100, 100)]]];
    _nameLabel.text = poiDetail.name;
    
    if(poiDetail.level)
    {
        CGSize size = [LPUtility getTextHeightWithText:poiDetail.level font:_levelLabel.font size:CGSizeMake(200, 20)];
        _levelLabel.frame = CGRectMake(_tableHeaderView.frame.size.width - 8 - size.width - 5, _levelLabel.frame.origin.y, size.width + 5, _levelLabel.frame.size.height);
        _levelImageView.frame = CGRectMake(_levelLabel.frame.origin.x, _levelLabel.frame.origin.y + (_levelLabel.frame.size.height - 15) / 3, _levelLabel.frame.size.width, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank.png"];
        _levelLabel.text = poiDetail.level;
    }
    else
    {
        _levelLabel.text = @"";
    }
    
    _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y, _tableHeaderView.frame.size.width - _logoImageView.frame.origin.x - _logoImageView.frame.size.width - 15 - _levelImageView.frame.size.width, _nameLabel.frame.size.height);
    
    [_starView setStars:poiDetail.stars];
    [_reviewButton setTitle:[NSString stringWithFormat:@"%i", (int)poiDetail.reviewNum] forState:UIControlStateNormal];
    
    CGFloat height = [ShopDetailView getShopDetailViewHeightWithPOIDetail:poiDetail];
    _shopDetailView.frame = CGRectMake(_shopDetailView.frame.origin.x, _shopDetailView.frame.origin.y, _shopDetailView.frame.size.width, height);
    [_shopDetailView setPoiDetail:poiDetail];
    
    CGSize descriptionSize = [LPUtility getTextHeightWithText:poiDetail.description
                                                         font:_descriptionLabel.font
                                                         size:CGSizeMake(_descriptionLabel.frame.size.width, 2000)];
    _descriptionBackView.frame = CGRectMake(_descriptionBackView.frame.origin.x, _shopDetailView.frame.origin.y + _shopDetailView.frame.size.height + 8, _descriptionBackView.frame.size.width, descriptionSize.height + 12 * 2);
    _descriptionHeaderLabel.frame = CGRectMake(12 + _descriptionBackView.frame.origin.x, -10 + _descriptionBackView.frame.origin.y, 45, 20);
    _descriptionLabel.frame = CGRectMake(_descriptionLabel.frame.origin.x, _descriptionLabel.frame.origin.y, _descriptionLabel.frame.size.width, descriptionSize.height);
    _descriptionLabel.text = poiDetail.description;
    
    _mapView.frame = CGRectMake(_mapView.frame.origin.x, _descriptionBackView.frame.origin.y + _descriptionBackView.frame.size.height + 10, _mapView.frame.size.width, _mapView.frame.size.height);
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poiDetail.latitude, poiDetail.longitude) zoomLevel:13 animated:YES];
    
    POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
    annotation.coordinate = CLLocationCoordinate2DMake(poiDetail.latitude, poiDetail.longitude);
    annotation.title = poiDetail.address;
    annotation.subtitle = poiDetail.addressOrigin;
    
    [_mapView addAnnotation:annotation];
    _mapLabel.text = poiDetail.address;
    
    for(UIView *view in _keywordView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if(poiDetail.keywordArray && [poiDetail.keywordArray count] > 0)
    {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 10, _keywordView.frame.size.width - 15 * 2, 15)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"大家觉得：";
        [_keywordView addSubview:label];
        
        CGSize textSize = [LPUtility getTextHeightWithText:label.text
                                                      font:label.font
                                                      size:CGSizeMake(200, 100)];
        CGFloat offsetX = textSize.width + 15;
        CGFloat offsetY = 10;
        
        for(NSInteger i = 0; i < [poiDetail.keywordArray count]; i++)
        {
            NSString *keyword = [poiDetail.keywordArray objectAtIndex:i];
            CGSize keywordSize = [LPUtility getTextHeightWithText:keyword
                                                             font:[UIFont systemFontOfSize:10.0f]
                                                             size:CGSizeMake(200, 100)];
            if(offsetX + keywordSize.width + 5 + 10 > _keywordView.frame.size.width - 15)
            {
                offsetX = textSize.width + 15;
                offsetY += 25;
            }
            
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY + 1, keywordSize.width + 5, 14)] autorelease];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)(i % 6 + 1)]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
            [_keywordView addSubview:imageView];
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 1, imageView.frame.size.width, 12)] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:10.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = keyword;
            [imageView addSubview:label];
            
            offsetX += keywordSize.width + 5 + 10;
        }
        
        _keywordView.frame = CGRectMake(_keywordView.frame.origin.x, _mapView.frame.origin.y + _mapView.frame.size.height, _keywordView.frame.size.width, offsetY + 15);
    }
    else
    {
        _keywordView.frame = CGRectMake(_keywordView.frame.origin.x, _mapView.frame.origin.y + _mapView.frame.size.height, _keywordView.frame.size.width, 0);
    }
    
    for(UIView *view in _topImageView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if(poiDetail.topImageArray && [poiDetail.topImageArray count] > 0)
    {
        _topImageView.frame = CGRectMake(_topImageView.frame.origin.x, _keywordView.frame.origin.y + _keywordView.frame.size.height, _topImageView.frame.size.width, 110);
        for(NSInteger i = 0; i < [poiDetail.topImageArray count]; i++)
        {
            if(i == 3)
            {
                break;
            }
            
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(25 + 93 * i, 10, 80, 80)] autorelease];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[poiDetail.topImageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(160, 160)]]];
            [_topImageView addSubview:imageView];
        }
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 90, _topImageView.frame.size.width - 15 * 2, 20)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:251.0 / 255.0 green:123.0 / 255.0 blue:147.0 / 255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"查看所有%i张照片", (int)[poiDetail.topImageArray count]];
        [_topImageView addSubview:label];
        
        UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(15, _topImageView.frame.size.height - 0.5, _topImageView.frame.size.width - 15, 0.5)] autorelease];
        line.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
        [_topImageView addSubview:line];
    }
    else
    {
        _topImageView.frame = CGRectMake(_topImageView.frame.origin.x, _keywordView.frame.origin.y + _keywordView.frame.size.height, _topImageView.frame.size.width, 0);
    }
    
    _tableHeaderView.frame = CGRectMake(_tableHeaderView.frame.origin.x, _tableHeaderView.frame.origin.y, _tableHeaderView.frame.size.width, _descriptionBackView.frame.origin.y + _descriptionBackView.frame.size.height + _mapView.frame.size.height + 10 + _keywordView.frame.size.height + _topImageView.frame.size.height);
    
    _tableView.tableHeaderView = _tableHeaderView;
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
    dealDetailVC.dealId = [[_dealArray objectAtIndex:indexPath.row] dealId];
    dealDetailVC.siteId = [[[_dealArray objectAtIndex:indexPath.row] site] siteId];
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

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        if (currentAnnotation != mapView.userLocation) {
            [mapView selectAnnotation:currentAnnotation animated:YES];
            break;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ShopViewControllerIdentifier"];
    
    view.pinColor = MKPinAnnotationColorRed;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    view.draggable = NO;
    
    return view;
}

#pragma mark - UIGestureRecognizer

- (void)tapTopImageView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        ShopPictureViewController *shopPictureVC = [[[ShopPictureViewController alloc] init] autorelease];
        shopPictureVC.index = 0;
        shopPictureVC.pictureArray = [NSMutableArray arrayWithArray:_poiDetail.topImageArray];
        [self.navigationController pushViewController:shopPictureVC animated:YES];
    }
}

- (void)tapMapView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        ShopMapViewController *shopMapVC = [[[ShopMapViewController alloc] init] autorelease];
        shopMapVC.poiDetail = _poiDetail;
        [self.navigationController pushViewController:shopMapVC animated:YES];
    }
}

@end
