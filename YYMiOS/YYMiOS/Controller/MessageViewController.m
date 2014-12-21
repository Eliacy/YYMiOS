//
//  MessageViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDetailViewController.h"
#import "MessageCell.h"
#import "Message.h"

@interface MessageViewController () <IChatManagerDelegate>

@end

@implementation MessageViewController

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    for(NSInteger i = 0; i < [sorte count]; i++)
    {
        EMConversation *conversation = [sorte objectAtIndex:i];
        
        [ret addObject:conversation];
    }
    
    return ret;
}

- (void)refreshDataSource
{
    NSMutableArray *conversationArray = [self loadDataSource];
    if(conversationArray && [conversationArray count] > 0)
    {
        NSMutableString *string = [NSMutableString stringWithCapacity:0];
        for(NSInteger i = 0; i < [conversationArray count]; i++)
        {
            if(i == [conversationArray count] - 1)
            {
                [string appendString:[(EMConversation *)[conversationArray objectAtIndex:i] chatter]];
            }
            else
            {
                [string appendFormat:@"%@,", [(EMConversation *)[conversationArray objectAtIndex:i] chatter]];
            }
        }
        
        [User getUserListWithEmIds:string
                             brief:1
                           success:^(NSArray *array) {
                               
                               if([array count] > 0)
                               {
                                   [_messageArray removeAllObjects];
                                   
                                   for(User *user in array)
                                   {
                                       Message *message = [[[Message alloc] init] autorelease];
                                       message.user = user;
                                       for(EMConversation *conversation in conversationArray)
                                       {
//                                           if([[conversation.chatter uppercaseString] isEqualToString:[user.emUsername uppercaseString]])
                                           if([conversation.chatter isEqualToString:user.emUsername])
                                           {
                                               message.conversation = conversation;
                                               break;
                                           }
                                       }
                                       [_messageArray addObject:message];
                                   }
                                   
                                   [_tableView reloadData];
                               }
                               
                           } failure:^(NSError *error) {
                               
                           }];
    }
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"用户消息";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
    
    [self refreshDataSource];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!_isAppear)
    {
        return;
    }
    _isAppear = NO;
    
    [self unregisterNotifications];
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
    return [_messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.message = [_messageArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController *messageDetailVC = [[[MessageDetailViewController alloc] init] autorelease];
    messageDetailVC.emUsername = [[(Message *)[_messageArray objectAtIndex:indexPath.row] user] emUsername];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
    
    return nil;
}

#pragma mark - registerNotifications

- (void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate

- (void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

- (void)willReceiveOfflineMessages
{
    NSLog(@"开始接收离线消息");
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    NSLog(@"离线消息接收成功");
    [self refreshDataSource];
}

@end
