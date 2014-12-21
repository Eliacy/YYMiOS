//
//  MessageDetailViewController.m
//  YYMiOS
//
//  Created by Lide on 14/12/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "ChatSendHelper.h"

#define KPageCount 20

@interface MessageDetailViewController () <IChatManagerDelegate, UITextFieldDelegate>
{
    dispatch_queue_t _messageQueue;
    
    EMConversation  *_conversation;
}

@end

@implementation MessageDetailViewController

@synthesize emUsername = _emUsername;

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
    if(!_textField.text && [_textField.text isEqualToString:@""])
    {
        return;
    }
    
    //创建messsage对象
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:_textField.text toUsername:_emUsername isChatGroup:NO requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];
}

- (void)loadMoreMessages
{
    dispatch_async(_messageQueue, ^{
        
        NSInteger currentCount = [_messageDetailArray count];
        EMMessage *latestMessage = [_conversation latestMessage];
        NSTimeInterval beforeTime = 0;
        if (latestMessage)
        {
            beforeTime = latestMessage.timestamp + 1;
        }
        else
        {
            beforeTime = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        }
        
        NSArray *chats = [_conversation loadNumbersOfMessages:(currentCount + KPageCount) before:beforeTime];
        
        if ([chats count] > currentCount) {
            [_messageDetailArray removeAllObjects];
            //自定义
            
            for(NSInteger i = 0; i < [chats count]; i++)
            {
                EMMessage *message = [chats objectAtIndex:i];
                //补完message detail
                
                [_messageDetailArray addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDetailArray count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
    });
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

- (void)addChatDataToMessage:(EMMessage *)message
{
    //补完message detail
    [_messageDetailArray addObject:message];
    
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDetailArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _messageDetailArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height - _footerView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_emUsername isGroup:NO];
    [_conversation markMessagesAsRead:YES];
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    
    //通过会话管理者获取已收发消息
    [self loadMoreMessages];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageDetailViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EMMessage *message = [_messageDetailArray objectAtIndex:indexPath.row];
    id<IEMMessageBody> messageBody = message.messageBodies.lastObject;
    NSString *ret;
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Image:{
            ret = @"[图片]";
        } break;
        case eMessageBodyType_Text:{
            // 表情映射。
            NSString *didReceiveText = ((EMTextMessageBody *)messageBody).text;
            ret = didReceiveText;
        } break;
        case eMessageBodyType_Voice:{
            ret = @"[声音]";
        } break;
        case eMessageBodyType_Location: {
            ret = @"[位置]";
        } break;
        case eMessageBodyType_Video: {
            ret = @"[视频]";
        } break;
        default: {
        } break;
    }
    
    cell.textLabel.text = ret;
    
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

#pragma mark - IChatManagerDelegate

- (void)didSendMessage:(EMMessage *)message
                 error:(EMError *)error
{
    
}

- (void)didReceiveMessage:(EMMessage *)message
{
    if((message.from && [message.from isEqualToString:_emUsername]))
    {
        [self addChatDataToMessage:message];
    }
}

@end
