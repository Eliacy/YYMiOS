//
//  MessageDetailViewController.m
//  YYMiOS
//
//  Created by Lide on 14/12/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageDetailViewController.h"

#define KPageCount 20

@interface MessageDetailViewController () <IChatManagerDelegate>
{
    dispatch_queue_t _messageQueue;
    
    EMConversation  *_conversation;
}

@end

@implementation MessageDetailViewController

@synthesize emUsername = _emUsername;

#pragma mark - private

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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
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

@end
