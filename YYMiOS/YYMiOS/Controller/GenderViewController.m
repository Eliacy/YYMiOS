//
//  GenderViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "GenderViewController.h"
#import "GenderCell.h"
#import "User.h"

@interface GenderViewController ()

@end

@implementation GenderViewController
{
    //性别状态： 男 女 未知 （与服务器一致）
    NSString *genderStateStr;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"性别";
    
    //获取当前性别
    genderStateStr = [[User sharedUser] gender];
    
    //保存
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [saveBtn addTarget:self action:@selector(saveGender) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:saveBtn];
    
    //列表主视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, 90) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GenderCell";
    GenderCell *cell = (GenderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GenderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //重新布局视图
    [cell layoutCellWithRow:indexPath.row Gender:genderStateStr];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    genderStateStr = [genderStrArray objectAtIndex:indexPath.row];
    [_tableView reloadData];
    
    return nil;
}


#pragma mark - 保存性别
- (void)saveGender
{
    //性别数组中包含 且只为 男或女
    if([genderStrArray indexOfObject:genderStateStr]==0||[genderStrArray indexOfObject:genderStateStr]==1){
        [self.view makeToastActivity];
        //请求接口
        [User modifyUserInfoWithUserId:[[User sharedUser] userId]
                                iconId:0
                              userName:nil
                              password:nil
                                gender:genderStateStr
                               success:^(NSArray *array) {
                                   //更新用户信息
                                   if([array count] > 0)
                                   {
                                       [LPUtility archiveData:array IntoCache:@"LoginUser"];
                                   }
                                   [self.view hideToastActivity];
                                   //修改成功直接返回用户信息设置页面
                                   [self.navigationController popViewControllerAnimated:YES];
                                   [self.view.window makeToast:@"性别修改成功" duration:TOAST_DURATION position:@"center"];
                                   
                               } failure:^(NSError *error) {
                                   [self.view hideToastActivity];
                                   [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                               }];
    }else{
        [self.view makeToast:@"请选择性别" duration:TOAST_DURATION position:@"center"];
    }
    
}


@end
