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
#import "Function.h"
#import "User.h"
#import "Constant.h"

@interface UserInfoViewController () <PhotoSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation UserInfoViewController
{
    //用户信息
    User *user;
}

#pragma mark - private

- (void)clickLogoutButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"login_flag"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchLoginViewController];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        user = [User sharedUser];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"个人信息";
    //列表主视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
    // Do any additional setup after loading the view.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoViewControllerIndetifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserInfoViewControllerIndetifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //统一标准
    int fontSize = 16;
    int leftX = 10;
    int rightX = 60;
    //内容
    #define cellTextArray @[@"头像",@"昵称",@"性别",@"手机号码",@"修改密码"]
    
    switch (indexPath.row) {
        case 0:
        {
            [cell addSubview:[Function createLabelWithFrame:CGRectMake(leftX, (80-20)/2, 40, 20) FontSize:fontSize Text:[cellTextArray objectAtIndex:indexPath.row]]];
            //头像
            UIImageView *userIconImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-rightX-60, (80-60)/2, 60, 60)] autorelease];
            userIconImageView.backgroundColor = [UIColor clearColor];
            userIconImageView.layer.cornerRadius = 30.0;
            userIconImageView.layer.masksToBounds = YES;
            userIconImageView.contentMode = UIViewContentModeScaleAspectFill;
            [userIconImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:user.userIcon.imageURL imageSize:CGSizeMake(120, 120)]]];
            [cell addSubview:userIconImageView];
            
        }
            break;
        case 1:
        {
            [cell addSubview:[Function createLabelWithFrame:CGRectMake(leftX, (45-20)/2, 40, 20) FontSize:fontSize Text:[cellTextArray objectAtIndex:indexPath.row]]];
            //昵称
            UILabel *userNameLabel = [Function createLabelWithFrame:CGRectMake(cell.frame.size.width-rightX-200, (cell.frame.size.height-20)/2, 200, 20) FontSize:fontSize Text:user.userName];
            userNameLabel.textAlignment = NSTextAlignmentRight;
            userNameLabel.textColor = GColor(112, 112, 112);
            [cell addSubview:userNameLabel];
        }
            break;
        case 2:
        {
            [cell addSubview:[Function createLabelWithFrame:CGRectMake(leftX, (45-20)/2, 40, 20) FontSize:fontSize Text:[cellTextArray objectAtIndex:indexPath.row]]];
            //性别
            UILabel *userGenderLabel = [Function createLabelWithFrame:CGRectMake(cell.frame.size.width-rightX-200, (cell.frame.size.height-20)/2, 200, 20) FontSize:fontSize Text:user.gender];
            userGenderLabel.textAlignment = NSTextAlignmentRight;
            userGenderLabel.textColor = GColor(112, 112, 112);
            [cell addSubview:userGenderLabel];
        }
            break;
        case 3:
        {
            [cell addSubview:[Function createLabelWithFrame:CGRectMake(leftX, (45-20)/2, 80, 20) FontSize:fontSize Text:[cellTextArray objectAtIndex:indexPath.row]]];
            //手机号码
            UILabel *userMobileLabel = [Function createLabelWithFrame:CGRectMake(cell.frame.size.width-rightX-200, (cell.frame.size.height-20)/2, 200, 20) FontSize:fontSize Text:user.mobile];
            userMobileLabel.textAlignment = NSTextAlignmentRight;
            userMobileLabel.textColor = GColor(112, 112, 112);
            [cell addSubview:userMobileLabel];
        }
            break;
        case 4:
        {
            //修改密码
            [cell addSubview:[Function createLabelWithFrame:CGRectMake(leftX, (45-20)/2, 80, 20) FontSize:fontSize Text:[cellTextArray objectAtIndex:indexPath.row]]];
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            PhotoSelectView *photoSelectView = [[[PhotoSelectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)] autorelease];
            photoSelectView.backgroundColor = [UIColor clearColor];
            photoSelectView.delegate = self;
            [photoSelectView show];
        }
            break;
        case 1:
        {
            NicknameViewController *nicknameVC = [[[NicknameViewController alloc] init] autorelease];
            [self.navigationController pushViewController:nicknameVC animated:YES];
        }
            break;
        case 2:
        {
            GenderViewController *genderVC = [[[GenderViewController alloc] init] autorelease];
            [self.navigationController pushViewController:genderVC animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            ModifyPasswordViewController *modifyPasswordVC = [[[ModifyPasswordViewController alloc] init] autorelease];
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

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
                                                                password:nil
                                                                  gender:nil
                                                                 success:^(NSArray *array) {
                                                                     
                                                                     [self.view hideToastActivity];
                                                                     
                                                                     if([array count] > 0)
                                                                     {
                                                                         [LPUtility archiveData:array IntoCache:@"LoginUser"];
                                                                     }
                                                                     
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
