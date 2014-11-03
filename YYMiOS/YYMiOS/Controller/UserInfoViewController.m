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

@interface UserInfoViewController () <PhotoSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation UserInfoViewController

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
    
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"个人信息";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _tableFooterView;
    
    _logoutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _logoutButton.frame = CGRectMake(20, _tableFooterView.frame.size.height - 45, _tableFooterView.frame.size.width - 20 * 2, 45);
    _logoutButton.backgroundColor = [UIColor grayColor];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoViewControllerIndetifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserInfoViewControllerIndetifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"头像";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"昵称";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"性别";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"手机号码";
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"修改密码";
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
//    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
