//
//  DealDetailViewController.m
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DealDetailViewController.h"
#import "ShareKit.h"
#import "CommentCell.h"
#import "Comment.h"
#import "ShopViewController.h"
#import "FollowingViewController.h"
#import "FollowerViewController.h"
#import "Share.h"
#import "UserDetailViewController.h"

#define kImageViewTag 81521

@interface DealDetailViewController () <UITextFieldDelegate, ArticlePOIViewDelegate, DealDetailExtViewDelegate>

@end

@implementation DealDetailViewController

@synthesize deal = _deal;
@synthesize dealId = _dealId;
@synthesize siteId = _siteId;

#pragma mark - private

- (void)clickShareButton:(id)sender
{
    [[ShareKit sharedKit] show];
    //share
//    [Share shareSomethingWithUserId:[[User sharedUser] userId]
//                             siteId:0
//                           reviewId:_dealId
//                          articleId:0
//                             target:@"微信"
//                            success:^(NSArray *array) {
//                                
//                            } failure:^(NSError *error) {
//                                
//                                }];
    [[ShareKit sharedKit] setArticleId:0];
    [[ShareKit sharedKit] setReviewId:_dealId];
    [[ShareKit sharedKit] setSiteId:0];
}

- (void)clickFollowingButton:(id)sender
{
    FollowingViewController *followingVC = [[[FollowingViewController alloc] init] autorelease];
    followingVC.userId = _deal.user.userId;
    [self.navigationController pushViewController:followingVC animated:YES];
}

- (void)clickFollowerButton:(id)sender
{
    FollowerViewController *followerVC = [[[FollowerViewController alloc] init] autorelease];
    followerVC.userId = _deal.user.userId;
    [self.navigationController pushViewController:followerVC animated:YES];
}

- (void)clickFollowButton:(id)sender
{
    if(_deal.user.followed)
    {
        [User unfollowSomeoneWithUserId:_deal.user.userId
                             fromUserId:[[User sharedUser] userId]
                                success:^(NSArray *array) {
                                    
                                    _deal.user.followed = !_deal.user.followed;
                                    if(_deal.user.followed)
                                    {
                                        [_followButton setTitle:@"取消" forState:UIControlStateNormal];
                                    }
                                    else
                                    {
                                        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
    }
    else
    {
        [User followSomeoneWithUserId:_deal.user.userId
                           fromUserId:[[User sharedUser] userId]
                              success:^(NSArray *array) {
                                  
                                  _deal.user.followed = !_deal.user.followed;
                                  if(_deal.user.followed)
                                  {
                                      [_followButton setTitle:@"取消" forState:UIControlStateNormal];
                                  }
                                  else
                                  {
                                      [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
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
    if(!_textField.text && [_textField.text isEqualToString:@""])
    {
        return;
    }
    
    //发送晒单评论
    [self.view makeToastActivity];
    [Comment createCommentWithDealId:_dealId
                           articleId:0
                              userId:[[User sharedUser] userId]
                              atList:@""
                             content:_textField.text
                             success:^(NSArray *array) {
                                 
                                 Comment *comment = [[[Comment alloc] init] autorelease];
                                 User *user = [[[User alloc] init] autorelease];
                                 user.userId = [[User sharedUser] userId];
                                 comment.user = user;
                                 comment.content = _textField.text;
                                 [_commentArray insertObject:comment atIndex:0];
                                 [_tableView reloadData];
                                 
                                 _textField.text = @"";
                                 
                                [self.view hideToastActivity];
                             } failure:^(NSError *error) {
                                 [self.view hideToastActivity];
                                 [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                             }];
    
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
        _commentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"晒单评论";
    
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _shareButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_shareButton];
    
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
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 300)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _backUserView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableHeaderView.frame.size.width, 90)];
    _backUserView.backgroundColor = [UIColor clearColor];
    _backUserView.userInteractionEnabled = YES;
    [_tableHeaderView addSubview:_backUserView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 30.0;
    [_backUserView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 130, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    [_backUserView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, _nameLabel.frame.size.width + 30, 15)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [_backUserView addSubview:_timeLabel];
    
//    _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    _followingButton.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 5, 60, 20);
//    _followingButton.backgroundColor = [UIColor clearColor];
//    [_followingButton setTitleColor:[UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//    _followingButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//    _followingButton.layer.borderWidth = 0.5;
//    _followingButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
//    [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
//    _followingButton.layer.cornerRadius = 2.0;
//    _followingButton.layer.masksToBounds = YES;
//    [_tableHeaderView addSubview:_followingButton];
//    
//    _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followingButton.frame.origin.y, 60, 20);
//    _followerButton.backgroundColor = [UIColor clearColor];
//    [_followerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    _followerButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//    _followerButton.layer.borderWidth = 0.5;
//    _followerButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
//    [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
//    _followerButton.layer.cornerRadius = 2.0;
//    _followerButton.layer.masksToBounds = YES;
//    [_tableHeaderView addSubview:_followerButton];
    
    _followButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followButton.frame = CGRectMake(_tableHeaderView.frame.size.width - 60 - 15, (_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height) / 2 - 15, 60, 30);
    _followButton.backgroundColor = [UIColor clearColor];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _followButton.layer.borderWidth = 1.0;
    _followButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backUserView addSubview:_followButton];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarImageView:)];
    [_backUserView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10, _tableHeaderView.frame.size.width - 15 * 2, 60)];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.font = [UIFont systemFontOfSize:16.0f];
    _contentLabel.numberOfLines = 0;
    [_tableHeaderView addSubview:_contentLabel];
    
    _dealDetailExtView = [[DealDetailExtView alloc] initWithFrame:CGRectMake(0, _contentLabel.frame.origin.y + _contentLabel.frame.size.height, _tableHeaderView.frame.size.width, 90)];
    _dealDetailExtView.backgroundColor = [UIColor clearColor];
    _dealDetailExtView.delegate = self;
    [_tableHeaderView addSubview:_dealDetailExtView];
    
    _articlePOIView = [[ArticlePOIView alloc] initWithFrame:CGRectMake(0, _dealDetailExtView.frame.origin.y + _dealDetailExtView.frame.size.height, _tableHeaderView.frame.size.width, 88)];
    _articlePOIView.delegate = self;
    [_tableHeaderView addSubview:_articlePOIView];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height - 0.5, _tableHeaderView.frame.size.width, 0.5)];
    _line.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_tableHeaderView addSubview:_line];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    //请求晒单详情接口
    [self.view makeToastActivity];
    [Deal getDealDetailListWithDealId:_dealId
                                brief:0
                             selected:0
                            published:0
                               offset:0
                                limit:1
                                 user:0
                                 site:_siteId
                                 city:0
                              success:^(NSArray *array) {
                                  
                                  if([array count] > 0)
                                  {
                                      self.deal = [array objectAtIndex:0];
                                  }
                                  
                                  //请求子评论接口
                                  [Comment getCommentListWithCommentId:0
                                                                offset:0
                                                                 limit:20
                                                             articleId:0
                                                              reviewId:_dealId
                                                               success:^(NSArray *array) {
                                                                   
                                                                   _isLoading = NO;
                                                                   
                                                                   [_commentArray removeAllObjects];
                                                                   [_commentArray addObjectsFromArray:array];
                                                                   [_tableView reloadData];
                                                                   
                                                                   if([array count] < 20)
                                                                   {
                                                                       _isHaveMore = NO;
                                                                   }
                                                                   else
                                                                   {
                                                                       _isHaveMore = YES;
                                                                   }
                                                                   
                                                                   [self.view hideToastActivity];
                                                               } failure:^(NSError *error) {
                                                                   _isLoading = NO;
                                                                   [self.view hideToastActivity];
                                                                   [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                                               }];
                                  
                              } failure:^(NSError *error) {
                                  _isLoading = NO;
                                  [self.view hideToastActivity];
                                  [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
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

- (void)setDeal:(Deal *)deal
{
    if(_deal != nil)
    {
        LP_SAFE_RELEASE(_deal);
    }
    _deal = [deal retain];
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:deal.user.userIcon.imageURL imageSize:CGSizeMake(100, 100)]]];
    _nameLabel.text = deal.user.userName;
    _timeLabel.text = [LPUtility friendlyStringFromDate:deal.updateTime];
    
    if(deal.user.followed)
    {
        [_followButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
//    NSString *followingString = [NSString stringWithFormat:@"关注:%i", deal.user.followCount];
//    CGSize followingSize = [LPUtility getTextHeightWithText:followingString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
//    _followingButton.frame = CGRectMake(_followingButton.frame.origin.x, _followingButton.frame.origin.y, followingSize.width + 20, _followingButton.frame.size.height);
//    [_followingButton setTitle:followingString forState:UIControlStateNormal];
//    
//    NSString *followerString = [NSString stringWithFormat:@"粉丝:%i", deal.user.fanCount];
//    CGSize followerSize = [LPUtility getTextHeightWithText:followerString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
//    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followerButton.frame.origin.y, followerSize.width + 20, _followerButton.frame.size.height);
//    [_followerButton setTitle:followerString forState:UIControlStateNormal];
    
    NSMutableArray *badges = [Function addBadgesWithArray:deal.user.badges
                                                  OffsetX:_timeLabel.frame.origin.x
                                                  OffsetY:_timeLabel.frame.origin.y + _timeLabel.frame.size.height + 5
                                                    Width:_tableHeaderView.frame.size.width
                              ];
    for (UIImageView *badge in badges)
    {
        [_backUserView addSubview:badge];
    }
    
    CGSize contentSize = [LPUtility getTextHeightWithText:deal.content
                                                     font:_contentLabel.font
                                                     size:CGSizeMake(_contentLabel.frame.size.width, 2000)];
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, contentSize.height);
    _contentLabel.text = deal.content;
    
    for(UIView *view in _tableHeaderView.subviews)
    {
        if(view.tag >= kImageViewTag)
        {
            [view removeFromSuperview];
        }
    }
    
    _tableHeaderView.frame = CGRectMake(_tableHeaderView.frame.origin.x, _tableHeaderView.frame.origin.y, _tableHeaderView.frame.size.width, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + [deal.imageArray count] * 170 + 10 + 90 + 88);
    
    for(NSInteger i = 0; i < [deal.imageArray count]; i++)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 10 + 170 * i, 300, 160)] autorelease];
        imageView.tag = kImageViewTag + i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[deal.imageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(600, 320)]]];
        [_tableHeaderView addSubview:imageView];
    }
    
    _articlePOIView.frame = CGRectMake(_articlePOIView.frame.origin.x, _tableHeaderView.frame.size.height - 88, _articlePOIView.frame.size.width, _articlePOIView.frame.size.height);
    _articlePOIView.poiId = deal.site.siteId;
    _dealDetailExtView.frame = CGRectMake(_dealDetailExtView.frame.origin.x, _articlePOIView.frame.origin.y - _dealDetailExtView.frame.size.height, _dealDetailExtView.frame.size.width, _dealDetailExtView.frame.size.height);
    _dealDetailExtView.deal = deal;
    
    _line.frame = CGRectMake(_line.frame.origin.x, _tableHeaderView.frame.size.height - 0.5, _line.frame.size.width, _line.frame.size.height);
    _tableView.tableHeaderView = _tableHeaderView;
}

#pragma mark - SlimeRefreshDelegate

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
    
    //获取子评论
    [self.view makeToastActivity];
    [Comment getCommentListWithCommentId:0
                                  offset:[_commentArray count]
                                   limit:20
                               articleId:0
                                reviewId:_dealId
                                 success:^(NSArray *array) {
                                     
                                     _isLoading = NO;
                                     
                                     [_commentArray addObjectsFromArray:array];
                                     [_tableView reloadData];
                                     
                                     if([array count] < 20)
                                     {
                                         _isHaveMore = NO;
                                     }
                                     else
                                     {
                                         _isHaveMore = YES;
                                     }
                                     
                                     [self.view hideToastActivity];
                                 } failure:^(NSError *error) {
                                     _isLoading = NO;
                                     [self.view hideToastActivity];
                                     [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                 }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_tableView.contentOffset.y + _tableView.frame.size.height > _tableView.contentSize.height - 500 && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        [self loadMore];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    height += 75;
    
    CGSize commentSize = [LPUtility getTextHeightWithText:[[_commentArray objectAtIndex:indexPath.row] content]
                                                     font:[UIFont systemFontOfSize:13.0f]
                                                     size:CGSizeMake(290, 2000)];
    
    return height + commentSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealDetailViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealDetailViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.comment = [_commentArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - ArticlePOIViewDelegate

- (void)articlePOIViewDidTap:(ArticlePOIView *)articlePOIView
{
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    shopVC.poiId = articlePOIView.poi.poiId;
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark - DealDetailExtViewDelegate

- (void)dealDetailExtViewDidClickLikeButton:(DealDetailExtView *)dealDetailExtView
{
    if(dealDetailExtView.deal.liked)
    {
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [Deal unlikeReviewWithUserId:[[User sharedUser] userId]
                            reviewId:dealDetailExtView.deal.dealId
                             success:^(NSArray *array) {
                                 
                                 _isLoading = NO;
                                 dealDetailExtView.deal.liked = NO;
                                 dealDetailExtView.deal.likeCount -= 1;
                                 [dealDetailExtView refresh];
                                 
                             } failure:^(NSError *error) {
                                 
                                 _isLoading = NO;
                                 
                             }];
    }
    else
    {
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [Deal likeReviewWithUserId:[[User sharedUser] userId]
                          reviewId:dealDetailExtView.deal.dealId
                           success:^(NSArray *array) {
                               
                               _isLoading = NO;
                               dealDetailExtView.deal.liked = YES;
                               dealDetailExtView.deal.likeCount += 1;
                               [dealDetailExtView refresh];
                               
                           } failure:^(NSError *error) {
                               
                               _isLoading = NO;
                               
                           }];
    }
}

#pragma mark - UIGestureRecognizer

- (void)tapAvatarImageView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(_deal != nil)
    {
        UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
        userDetailVC.userId = _deal.user.userId;
        [self.navigationController pushViewController:userDetailVC animated:YES];
    }
}

@end
