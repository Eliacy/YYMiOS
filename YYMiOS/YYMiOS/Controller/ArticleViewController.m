//
//  ArticleViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ArticleViewController.h"
#import "ShareKit.h"
#import "CommentCell.h"
#import "Comment.h"
#import "POI.h"
#import "ArticlePOIView.h"
#import "ShopViewController.h"
#import "Share.h"
#import "UserDetailViewController.h"

@interface ArticleViewController () <UITextFieldDelegate, ArticlePOIViewDelegate, CommentCellDelegate>

@end

@implementation ArticleViewController

@synthesize articleId = _articleId;
@synthesize article = _article;

@synthesize atListString = _atListString;

#pragma mark - private

- (void)clickShareButton:(id)sender
{
    [[ShareKit sharedKit] show];
    //share
//    [Share shareSomethingWithUserId:[[User sharedUser] userId]
//                             siteId:0
//                           reviewId:0
//                          articleId:_articleId
//                             target:@"微信"
//                            success:^(NSArray *array) {
//                                
//                            } failure:^(NSError *error) {
//                                
//                            }];
    [[ShareKit sharedKit] setArticleId:_articleId];
    [[ShareKit sharedKit] setReviewId:0];
    [[ShareKit sharedKit] setSiteId:0];
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
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    //发送评论
    [self.view makeToastActivity];
    [Comment createCommentWithDealId:0
                           articleId:_articleId
                              userId:[[User sharedUser] userId]
                              atList:self.atListString//@""
                             content:_textField.text
                             success:^(NSArray *array) {
                                 
                                 _textField.text = @"";
                                 
                                 //发送成功后 刷新评论列表
                                 [Comment getCommentListWithCommentId:0
                                                               offset:0
                                                                limit:20
                                                            articleId:_articleId
                                                             reviewId:0
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
                                                                  //滚动到新评论添加的位置 (处于视图中间)
                                                                  [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                                                  
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
    
    _titleLabel.text = @"文章";
    
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
    _textField.placeholder = @"说点啥吧";
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height - _footerView.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    //获取文章详情
    [self.view makeToastActivity];
    [Article getArticleListWithArticleId:_articleId
                                   brief:0
                                  offset:0
                                   limit:1
                                  cityId:0
                                 success:^(NSArray *array) {
                                     
                                     if([array count] > 0)
                                     {
                                         self.article = [array objectAtIndex:0];
                                     }
                                     
                                     //获取子评论
                                     [Comment getCommentListWithCommentId:0
                                                                   offset:0
                                                                    limit:20
                                                                articleId:_articleId
                                                                 reviewId:0
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

- (void)setArticle:(Article *)article
{
    if(_article != nil)
    {
        LP_SAFE_RELEASE(_article);
    }
    _article = [article retain];
    
    [_tableView reloadData];
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
                               articleId:_articleId
                                reviewId:0
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
    switch (indexPath.section) {
        case 0:
        {
            CGFloat height = 0;
            
            NSDictionary *dictionary = [_article.contentArray objectAtIndex:indexPath.row];
            switch ([[dictionary objectForKey:@"type"] integerValue])
            {
                case 1:
                {
                    CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                              font:[UIFont systemFontOfSize:12.0f]
                                                              size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
                    height += size.height + 15;
                }
                    break;
                case 2:
                {
                    CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                              font:[UIFont systemFontOfSize:14.0f]
                                                              size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
                    height += size.height + 15;
                }
                    break;
                case 3:
                {
                    height += 165 + 15;
                }
                    break;
                case 4:
                {
                    height += 88;
                }
                    break;
                case 5:
                {
                    height += 1;
                }
                    break;
                    
                default:
                    break;
            }
            return height;
        }
            break;
        case 1:
        {
            CGFloat height = 0;
            
            height += 75;
            
            //如果有回复的情况 计算高度时要加上用户名的长度
            if([[_commentArray objectAtIndex:indexPath.row] atList].count>0){
                User *user = [[[_commentArray objectAtIndex:indexPath.row] atList] objectAtIndex:0];
                NSString *placeStr = @"";
                for(int i=0;i<user.userName.length;i++){
                    placeStr = [placeStr stringByAppendingString:@"   "];
                }
                NSString *allStr = [NSString stringWithFormat:@"%@%@",placeStr,[[_commentArray objectAtIndex:indexPath.row] content]];
                CGSize commentSize = [LPUtility getTextHeightWithText:allStr
                                                                 font:[UIFont systemFontOfSize:13.0f]
                                                                 size:CGSizeMake(290, 2000)];
                return height + commentSize.height;
            }else{
                CGSize commentSize = [LPUtility getTextHeightWithText:[[_commentArray objectAtIndex:indexPath.row] content]
                                                                 font:[UIFont systemFontOfSize:13.0f]
                                                                 size:CGSizeMake(290, 2000)];
                return height + commentSize.height;
            }
        }
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if(_article && _article.contentArray && [_article.contentArray count] > 0)
            {
                return [_article.contentArray count];
            }
            else
            {
                return 0;
            }
        }
            break;
        case 1:
        {
            return [_commentArray count];
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleViewControllerIdentifier"];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArticleViewControllerIdentifier"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSDictionary *dictionary = [_article.contentArray objectAtIndex:indexPath.row];
        switch ([[dictionary objectForKey:@"type"] integerValue])
        {
            case 1:
            {
                //内容
                CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                          font:[UIFont systemFontOfSize:12.0f]
                                                          size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, size.height)] autorelease];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:12.0f];
                label.numberOfLines = 0;
                label.text = [dictionary objectForKey:@"content"];
                [cell.contentView addSubview:label];
            }
                break;
            case 2:
            {
                //标题
                CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                          font:[UIFont systemFontOfSize:14.0f]
                                                          size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, size.height)] autorelease];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = GColor(252, 43, 101);
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [dictionary objectForKey:@"content"];
                [cell.contentView addSubview:label];
            }
                break;
            case 3:
            {
                LPImage *image = [[LPImage alloc] initWithAttribute:[dictionary objectForKey:@"content"]];
                
                UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, 165)] autorelease];
                [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:image.imageURL imageSize:CGSizeMake((_tableView.frame.size.width - 15 * 2) * 2, 165 * 2)]]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = YES;
                [cell.contentView addSubview:imageView];
            }
                break;
            case 4:
            {
                dictionary = [dictionary objectForKey:@"content"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    POI *poi = [[[POI alloc] initWithAttribute:dictionary] autorelease];
                    ArticlePOIView *articlePOIView = [[[ArticlePOIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 88)] autorelease];
                    articlePOIView.delegate = self;
                    [cell.contentView addSubview:articlePOIView];
                    [articlePOIView setPoi:poi];
                    
                    if(poi.keywordArray && [poi.keywordArray isKindOfClass:[NSArray class]] && [poi.keywordArray count] > 0)
                    {
                        articlePOIView.keywordImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)indexPath.row % 6 + 1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
                    }
                    else
                    {
                        articlePOIView.keywordImageView.image = nil;
                    }
                    
                    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5)] autorelease];
                    view.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:view];
                }
            }
                break;
            case 5:
            {
                UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5)] autorelease];
                view.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:view];
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.comment = [_commentArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击评论 跳转到个人主页
    if(indexPath.section == 1){
        UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
        Comment *comment = [_commentArray objectAtIndex:indexPath.row];
        userDetailVC.userId = comment.user.userId;
        [self.navigationController pushViewController:userDetailVC animated:YES];
    }
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

#pragma mark - CommentCellDelegate
#pragma mark - 回复评论
- (void)commentCellDidClickReplyButton:(CommentCell *)commentCell
{
    //要回复的评论的用户id
    self.atListString = [NSString stringWithFormat:@"%i", commentCell.comment.user.userId];
    //变更输入框提示语
    _textField.placeholder = [NSString stringWithFormat:@"@%@：", commentCell.comment.user.userName];
    //获得焦点 弹出键盘
    [_textField becomeFirstResponder];
}

#pragma mark - 点击@用户
- (void)commentCellDidClickAtButton:(CommentCell *)commentCell
{
    //跳转到所点击用户的个人主页
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[commentCell.comment.atList objectAtIndex:0] userId];
    [self.navigationController pushViewController:userDetailVC animated:YES];
}

@end
