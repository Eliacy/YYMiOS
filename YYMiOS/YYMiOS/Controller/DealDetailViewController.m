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

@interface DealDetailViewController () <UITextFieldDelegate>

@end

@implementation DealDetailViewController

#pragma mark - private

- (void)clickShareButton:(id)sender
{
    [[ShareKit sharedKit] show];
}

- (void)clickFollowingButton:(id)sender
{

}

- (void)clickFollowerButton:(id)sender
{

}

- (void)clickFollowButton:(id)sender
{

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
        _commentArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_commentArray addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil]];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"晒单详情";
    
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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 240, 30)];
    _textField.backgroundColor = [UIColor blueColor];
    _textField.placeholder = @"点评晒单";
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
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 300)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    _avatarImageView.backgroundColor = [UIColor brownColor];
    [_tableHeaderView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 130, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    _nameLabel.text = @"我的ID叫小花";
    [_tableHeaderView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, _nameLabel.frame.size.width, 15)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _timeLabel.text = @"昨天晚上10点35分";
    [_tableHeaderView addSubview:_timeLabel];
    
    _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followingButton.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 5, 60, 20);
    _followingButton.backgroundColor = [UIColor clearColor];
    _followingButton.layer.borderWidth = 1.0f;
    _followingButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [_followingButton setTitle:@"关注：15" forState:UIControlStateNormal];
    [_followingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followingButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_followingButton];
    
    _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followingButton.frame.origin.y, _followingButton.frame.size.width, _followingButton.frame.size.height);
    _followerButton.backgroundColor = [UIColor clearColor];
    _followerButton.layer.borderWidth = 1.0f;
    _followerButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [_followerButton setTitle:@"粉丝：300" forState:UIControlStateNormal];
    [_followerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_followerButton];
    
    _followButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followButton.frame = CGRectMake(_tableHeaderView.frame.size.width - 60 - 15, (_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height) / 2 - 15, 60, 30);
    _followButton.backgroundColor = [UIColor purpleColor];
    [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_followButton];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10, _tableHeaderView.frame.size.width - 15 * 2, 60)];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.font = [UIFont systemFontOfSize:16.0f];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"这个词在基督教中是很常见的词汇。根据基督教的教义，耶稣基督降临于世，是为了拯救陷身于罪恶中的世人，故甘愿以己身来代替世人赎罪。这一事件的具体表现就是，耶稣被犹太总督抓起来问罪，并最终被判钉死在十字架上（在古代，十字架是处决犯人的刑具，直到这之后才成为基督教中神圣的象征）。";
    [_tableHeaderView addSubview:_contentLabel];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, _tableHeaderView.frame.size.width - 15 * 2, _tableHeaderView.frame.size.height - 15 * 2 - _contentLabel.frame.origin.y - _contentLabel.frame.size.height)] autorelease];
    imageView.backgroundColor = [UIColor redColor];
    [_tableHeaderView addSubview:imageView];
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height - 0.5, _tableHeaderView.frame.size.width, 0.5)] autorelease];
    line.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_tableHeaderView addSubview:line];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 105.0f;
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

@end