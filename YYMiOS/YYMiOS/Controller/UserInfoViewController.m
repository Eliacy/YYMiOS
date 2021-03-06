//
//  UserInfoViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "UserInfoViewController.h"
#import "PhotoSelectView.h"
#import "NicknameViewController.h"
#import "GenderViewController.h"
#import "ModifyPasswordViewController.h"
#import "User.h"
#import "UserInfoCell.h"

@interface UserInfoViewController () <PhotoSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation UserInfoViewController
{
    
}

#pragma mark - private

- (void)clickLogoutButton:(id)sender
{
//    if([[User sharedUser] anonymous])
//    {
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showRegisterViewController];
//        
//        return;
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"login_flag"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchLoginViewController];
    
    //anonymous
    [[LPAPIClient sharedAPIClient] registerWithIconId:0
                                             userName:nil
                                               mobile:nil
                                             password:nil
                                               gender:nil
                                                token:nil
                                               device:[NSString stringWithFormat:@"%i_%i", (int)[[NSDate date] timeIntervalSince1970], arc4random()]//[[NSUserDefaults standardUserDefaults] objectForKey:@"AppGuid"]
                                              success:^(id respondObject) {
                                                  
                                                  if([respondObject objectForKey:@"data"] && ![[respondObject objectForKey:@"data"] isEqual:[NSNull null]])
                                                  {
                                                      respondObject = [respondObject objectForKey:@"data"];
                                                      if([respondObject objectForKey:@"token"] && ![[respondObject objectForKey:@"token"] isEqual:[NSNull null]])
                                                      {
                                                          [[NSUserDefaults standardUserDefaults] setObject:[respondObject objectForKey:@"token"] forKey:@"user_access_token"];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                      }
                                                      
                                                      if([respondObject objectForKey:@"user"] && ![[respondObject objectForKey:@"user"] isEqual:[NSNull null]])
                                                      {
                                                          NSDictionary *userDictionary = [respondObject objectForKey:@"user"];
                                                          if(userDictionary && [userDictionary isKindOfClass:[NSDictionary class]])
                                                          {
                                                              User *user = [[[User alloc] initWithAttribute:userDictionary] autorelease];
                                                              [LPUtility archiveData:[NSArray arrayWithObject:user] IntoCache:@"LoginUser"];
                                                          }
                                                      }
                                                  }
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"login_flag"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchTabViewController];
                                                  
                                                  [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[User sharedUser] emUsername]
                                                                                                      password:[[User sharedUser] emPassword]
                                                                                                    completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                                                        
                                                                                                    } onQueue:nil];
                                                  
                                              } failure:^(NSError *error) {
                                                  
                                              }];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_tableView){
        [_tableView reloadData];
    }
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"个人信息";
    //列表主视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height+15, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.separatorColor = GColor(225, 225, 223);
    [self.view addSubview:_tableView];
    //列表底视图
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _tableFooterView;
    //退出登录按钮
    _logoutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _logoutButton.frame = CGRectMake(20, _tableFooterView.frame.size.height - 45, _tableFooterView.frame.size.width - 20 * 2, 45);
    _logoutButton.backgroundColor = GColor(251, 100, 129);
    _logoutButton.layer.cornerRadius = 5.0;
    _logoutButton.layer.masksToBounds = YES;
    [_logoutButton setTitle:@"退出当前登录" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(clickLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_logoutButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        //头像
        return 80;
    }else{
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"UserInfoCell";
    UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //重新布局视图
    [cell layoutCellWithRow:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[User sharedUser] anonymous])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showRegisterViewController];
        
        return nil;
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            //头像
            PhotoSelectView *photoSelectView = [[[PhotoSelectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)] autorelease];
            photoSelectView.backgroundColor = [UIColor clearColor];
            photoSelectView.delegate = self;
            [photoSelectView show];
        }
            break;
        case 1:
        {
            //昵称
            NicknameViewController *nicknameVC = [[[NicknameViewController alloc] init] autorelease];
            [self.navigationController pushViewController:nicknameVC animated:YES];
        }
            break;
        case 2:
        {
            //性别
            GenderViewController *genderVC = [[[GenderViewController alloc] init] autorelease];
            [self.navigationController pushViewController:genderVC animated:YES];
        }
            break;
        case 3:
        {
            //手机号
            
        }
            break;
        case 4:
        {
            //修改密码
            ModifyPasswordViewController *modifyPasswordVC = [[[ModifyPasswordViewController alloc] init] autorelease];
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    return nil;
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
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.view hideToastActivity];
    [self.view makeToastActivity];
    
    [LPUtility uploadImageToQiniuWithImage:image
                                   imageId:0
                                      type:3
                                    userId:[[User sharedUser] userId]
                                      note:@"nothing"
                                      name:[NSString stringWithFormat:@"i%@_%i_%i.png", [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"], (int)[[NSDate date] timeIntervalSince1970], arc4random()]
                                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                      
                                      if(resp && [resp objectForKey:@"data"])
                                      {
                                          [User modifyUserInfoWithUserId:[[User sharedUser] userId]
                                                                  iconId:[[[resp objectForKey:@"data"] objectForKey:@"id"] integerValue]
                                                                userName:nil
                                                             oldPassword:nil
                                                                password:nil
                                                                  gender:nil
                                                                 success:^(NSArray *array) {
                                                                     
                                                                     [self.view hideToastActivity];
                                                                     
                                                                     if([array count] > 0)
                                                                     {
                                                                         [LPUtility archiveData:array IntoCache:@"LoginUser"];
                                                                     }
                                                                     //刷新头像
                                                                     [_tableView reloadData];
                                                                     
                                                                 } failure:^(NSError *error) {
                                                                     
                                                                     [self.view hideToastActivity];
                                                                     
                                                                 }];
                                      }
                                      else
                                      {
                                          [self.view hideToastActivity];
                                      }

                                  }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
