//
//  MessageDetailViewController.m
//  YYMiOS
//
//  Created by Lide on 14/12/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "ChatSendHelper.h"
#import "MessageDetailCell.h"
#import "User.h"
#import "PhotoSelectView.h"
#import "ShopPictureViewController.h"

#define KPageCount 20

@interface MessageDetailViewController () <IChatManagerDelegate, UITextFieldDelegate,PhotoSelectViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    dispatch_queue_t _messageQueue;
    
    EMConversation  *_conversation;
}

@end

@implementation MessageDetailViewController

@synthesize user = _user;

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
    if(_textField.text == nil || [_textField.text isEqualToString:@""])
    {
        return;
    }
    
    //创建messsage对象
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:_textField.text toUsername:_user.emUsername isChatGroup:NO requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];
    
    _textField.text = @"";
}

- (void)clickSendImgButton:(id)sender
{
    //上传照片
    PhotoSelectView *photoSelectView = [[[PhotoSelectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)] autorelease];
    photoSelectView.backgroundColor = [UIColor clearColor];
    photoSelectView.delegate = self;
    [photoSelectView show];
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
                //刷新列表
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDetailArray count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        
        //如果是产品经理添加一条默认数据
        if(self.user.userId == PM_ID){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_messageDetailArray addObject:[Function addMessageWithSender:self.user.emUsername Receiver:[[User sharedUser] emUsername] Text:@"请您将希望反馈的意见、建议发送给我，我会跟进并尽力推动改善。感谢您使用“优游全球”～"]];
                //刷新列表
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
    
    //标题为当前聊天对象昵称
    _titleLabel.text = _user.userName;
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)] autorelease];
    line.backgroundColor = [UIColor lightGrayColor];
    [_footerView addSubview:line];
    
    //发送图片按钮
    _sendImgButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _sendImgButton.frame = CGRectMake(15, 10, 40, 30);
    _sendImgButton.backgroundColor = [UIColor colorWithRed:252.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _sendImgButton.layer.cornerRadius = 3.0;
    _sendImgButton.layer.masksToBounds = YES;
    [_sendImgButton setTitle:@"+" forState:UIControlStateNormal];
    [_sendImgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendImgButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_sendImgButton addTarget:self action:@selector(clickSendImgButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_sendImgButton];
    
    //输入框背景
    _textBackView = [[UIView alloc] initWithFrame:CGRectMake(_sendImgButton.frame.size.width+15*2, 10, _footerView.frame.size.width-40*2-15*4, 30)];
    _textBackView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _textBackView.layer.borderWidth = 0.5;
    _textBackView.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    _textBackView.layer.cornerRadius = 3.0;
    _textBackView.layer.masksToBounds = YES;
    [_footerView addSubview:_textBackView];
    //输入框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 4, _textBackView.frame.size.width-20, 24)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.placeholder = @"说点啥吧";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    [_textBackView addSubview:_textField];
    
    //发送消息按钮
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
    
    //主视图列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height - _footerView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 12)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
    
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
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_user.emUsername isGroup:NO];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0;
    
    EMMessage *message = [_messageDetailArray objectAtIndex:indexPath.row];
    
    //对不同类型信息做判断
    if([(EMTextMessageBody *)message.messageBodies.lastObject messageBodyType]==eMessageBodyType_Text){
        
        //文本
        CGSize textSize = [LPUtility getTextHeightWithText:[(EMTextMessageBody *)message.messageBodies.lastObject text]
                                                      font:[UIFont systemFontOfSize:14.0f]
                                                      size:CGSizeMake(150, 2000)];
        height += textSize.height;
        
    }else if([(EMTextMessageBody *)message.messageBodies.lastObject messageBodyType]==eMessageBodyType_Image){
        
        //预览图
        CGSize imageSize = [(EMImageMessageBody *)message.messageBodies.lastObject thumbnailImage].size;
        height += imageSize.height;
    }else{
        //其他情况
        
    }
    
    height += 45 + 20;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[MessageDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageDetailViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.user = _user;
    cell.message = [_messageDetailArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是图片类型消息 点击后进入大图界面
    EMMessage *message = [_messageDetailArray objectAtIndex:indexPath.row];
    if([(EMTextMessageBody *)message.messageBodies.lastObject messageBodyType]==eMessageBodyType_Image){
        ShopPictureViewController *shopPictureVC = [[[ShopPictureViewController alloc] init] autorelease];
        shopPictureVC.index = 0;
        NSMutableArray *imageArray = [[NSMutableArray alloc] initWithObjects:[(EMImageMessageBody *)message.messageBodies.lastObject image], nil];
        shopPictureVC.pictureArray = [NSMutableArray arrayWithArray:imageArray];
        [self.navigationController pushViewController:shopPictureVC animated:YES];
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

#pragma mark - IChatManagerDelegate

- (void)didSendMessage:(EMMessage *)message
                 error:(EMError *)error
{
    
}

- (void)didReceiveMessage:(EMMessage *)message
{
    if((message.from && [message.from isEqualToString:_user.emUsername]))
    {
        [self addChatDataToMessage:message];
    }
}

#pragma mark -
#pragma mark - PhotoSelectViewDelegate

- (void)photoSelectViewDidClickCameraButton:(PhotoSelectView *)photoSelectView
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        NSLog(@"不能使用照相机");
    }
}

- (void)photoSelectViewDidClickLibraryButton:(PhotoSelectView *)photoSelectView
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        NSLog(@"不能访问图片库");
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //取得压缩后的图片
    UIImage *image = [LPUtility imageByScalingToMaxSize:[info valueForKey:UIImagePickerControllerEditedImage]];
    //创建messsage对象 并上传图片
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image toUsername:_user.emUsername isChatGroup:NO requireEncryption:NO];
    //发送消息
    [self addChatDataToMessage:tempMessage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
