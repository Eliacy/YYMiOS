//
//  DealEditViewController.m
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DealEditViewController.h"
#import "POISelectViewController.h"
#import "UserAtListViewController.h"
#import "PhotoSelectView.h"
#import "PicturePreviewViewController.h"

#define kScrollViewImageViewTag 86351

@interface DealEditViewController () <POISelectViewControllerDelegate, UserAtListViewControllerDelegate, UITextViewDelegate, PhotoSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PicturePreviewViewControllerDelegate>

@end

@implementation DealEditViewController

@synthesize delegate = _delegate;
@synthesize deal = _deal;

#pragma mark - private

- (void)clickBackButton:(id)sender
{
    [super clickBackButton:sender];
    
    if(_deal.site != nil)
    {
        NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
        
        for(Deal *deal in draftArray)
        {
            if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
            {
                [draftArray removeObject:deal];
                break;
            }
        }
        
        [draftArray insertObject:_deal atIndex:0];
        [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
    }
}

- (void)clickDeleteButton:(id)sender
{
    if(_deal.site != nil)
    {
        NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
        
        for(Deal *deal in draftArray)
        {
            if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
            {
                [draftArray removeObject:deal];
                break;
            }
        }
        
        [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPublishButton:(id)sender
{
    if(_deal.site == nil || [_deal.site.siteName isEqualToString:@""] || [_deal.content isEqualToString:@""])
    {
        [self.view hideToast];
        [self.view makeToast:@"发送内容不完整" duration:1.5 position:@"center"];
        
        return;
    }
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    NSMutableString *imageString = [NSMutableString stringWithCapacity:0];
    for(NSInteger i = 0; i < [_deal.imageArray count]; i++)
    {
        if(i == [_deal.imageArray count] - 1)
        {
            [imageString appendFormat:@"%i", [[_deal.imageArray objectAtIndex:i] imageId]];
        }
        else
        {
            [imageString appendFormat:@"%i ", [[_deal.imageArray objectAtIndex:i] imageId]];
        }
    }
    
    [Deal createDealDetailWithPublished:0
                                 userId:[[User sharedUser] userId]
                                 atList:@""
                                   star:0
                                content:_deal.content
                                 images:imageString
                               keywords:@""
                                  total:0
                               currency:@""
                                 siteId:_deal.site.siteId
                                success:^(NSArray *array) {
                                    
                                    _isLoading = NO;
                                    
                                    NSMutableArray *draftArray = [NSMutableArray arrayWithArray:[LPUtility unarchiveDataFromCache:@"draft_list"]];
                                    
                                    for(Deal *deal in draftArray)
                                    {
                                        if(deal.dealKey && [deal.dealKey isEqualToString:_deal.dealKey])
                                        {
                                            [draftArray removeObject:deal];
                                            break;
                                        }
                                    }
                                    
                                    [LPUtility archiveData:draftArray IntoCache:@"draft_list"];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                } failure:^(NSError *error) {
                                    
                                    _isLoading = NO;
                                    
                                }];
}

- (void)clickAddPhotoButton:(id)sender
{
    PhotoSelectView *photoSelectView = [[[PhotoSelectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)] autorelease];
    photoSelectView.backgroundColor = [UIColor clearColor];
    photoSelectView.delegate = self;
    [photoSelectView show];
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
    
    _titleLabel.text = @"编辑评论";
    
    _deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _deleteButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _deleteButton.backgroundColor = [UIColor clearColor];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_deleteButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 200)];
    _tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _tableFooterView;
    
    UIView *tapView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableFooterView.frame.size.width, _tableFooterView.frame.size.height)] autorelease];
    tapView.backgroundColor = [UIColor clearColor];
    [_tableFooterView addSubview:tapView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [tapView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, _tableFooterView.frame.size.width - 15 * 2, 70)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.delegate = self;
    [_tableFooterView addSubview:_textView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _textView.frame.origin.y + _textView.frame.size.height + 10, _tableFooterView.frame.size.width, 60)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_tableFooterView addSubview:_scrollView];
    
    _addPhotoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _addPhotoButton.frame = CGRectMake(15, 0, 60, 60);
    _addPhotoButton.backgroundColor = [UIColor clearColor];
    [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
    [_addPhotoButton addTarget:self action:@selector(clickAddPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addPhotoButton];
    
    _publishButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _publishButton.frame = CGRectMake(40, _tableFooterView.frame.size.height - 40, _tableFooterView.frame.size.width - 40 * 2, 40);
    _publishButton.backgroundColor = [UIColor redColor];
    [_publishButton setTitle:@"发布评论" forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(clickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_publishButton];
    
    if(self.deal == nil)
    {
        self.deal = [[Deal alloc] init];
        self.deal.dealKey = [NSString stringWithFormat:@"%i_%i", (int)[[NSDate date] timeIntervalSince1970], arc4random()];
        self.deal.imageArray = [NSArray array];
    }
    
    [self refreshData];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshData
{
    _textView.text = _deal.content;
    if(_deal.imageArray == nil)
    {
        _deal.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self refreshImageScrollView];
}

- (void)refreshImageScrollView
{
    for(UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat offsetX = 0;
    CGFloat width = _deal.imageArray.count * 75 + 15 + 15 + 60;
    _scrollView.contentSize = CGSizeMake(width, _scrollView.frame.size.height);
    
    for(NSInteger i = 0; i < _deal.imageArray.count; i++)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15 + 75 * i, 0, 60, 60)] autorelease];
        imageView.backgroundColor = [UIColor whiteColor];
        [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[_deal.imageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(120, 120)]]];
        
        imageView.tag = kScrollViewImageViewTag + i;
        
        UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:oneFingerTap];
        [oneFingerTap release];
        
        imageView.userInteractionEnabled = YES;
        
        [_scrollView addSubview:imageView];
        
        offsetX = imageView.frame.origin.x + imageView.frame.size.width;
    }
    
    _addPhotoButton.frame = CGRectMake(offsetX + 15, 0, _addPhotoButton.frame.size.width, _addPhotoButton.frame.size.height);
    [_scrollView addSubview:_addPhotoButton];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealEditViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealEditViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            if(_deal.site.siteName && ![_deal.site.siteName isEqualToString:@""])
            {
                cell.textLabel.text = _deal.site.siteName;
            }
            else
            {
                cell.textLabel.text = @"选择店铺";
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"我要@TA";
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
    switch (indexPath.row) {
        case 0:
        {
            POISelectViewController *poiSelectVC = [[[POISelectViewController alloc] init] autorelease];
            poiSelectVC.delegate = self;
            [self.navigationController pushViewController:poiSelectVC animated:YES];
        }
            break;
        case 1:
        {
            UserAtListViewController *userAtListVC = [[[UserAtListViewController alloc] init] autorelease];
            userAtListVC.delegate = self;
            userAtListVC.selectArray = [NSMutableArray arrayWithArray:_deal.atList];
            [self.navigationController pushViewController:userAtListVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - POISelectViewControllerDelegate

- (void)poiSelectViewControllerDidSelectPOI:(POI *)poi
{
    if(_deal.site == nil)
    {
        _deal.site = [[Site alloc] init];
    }
    
    _deal.site.siteId = poi.poiId;
    _deal.site.siteName = poi.name;
    
    [_tableView reloadData];
}

#pragma mark - UserAtListViewControllerDelegate

- (void)userAtListViewControllerDidClickConfirmButton:(UserAtListViewController *)userAtListVC
{

}

#pragma mark - UIGestureRecognizer

- (void)tapView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if([_textView isFirstResponder])
        {
            [_textView resignFirstResponder];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _deal.content = textView.text;
}

#pragma mark - PhotoSelectViewDelegate

- (void)photoSelectViewDidClickCameraButton:(PhotoSelectView *)photoSelectView
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
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
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.view hideToastActivity];
    [self.view makeToastActivity];
    
    [LPUtility uploadImageToQiniuWithImage:image
                                   imageId:0
                                      type:3
                                    userId:[[User sharedUser] userId]
                                      note:@"nothing"
                                      name:[NSString stringWithFormat:@"i%@_%i_%i.png", [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"], (int)[[NSDate date] timeIntervalSince1970], arc4random()]
                                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                      
                                      [self.view hideToastActivity];
                                      
                                      if(resp && [resp objectForKey:@"data"])
                                      {
                                          LPImage *image = [[[LPImage alloc] init] autorelease];
                                          image.imageId = [[[resp objectForKey:@"data"] objectForKey:@"id"] integerValue];
                                          image.imageURL = [[resp objectForKey:@"data"] objectForKey:@"url"];
                                          
                                          NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_deal.imageArray];
                                          [mutableArray insertObject:image atIndex:0];
                                          _deal.imageArray = mutableArray;
                                          
                                          [self refreshImageScrollView];
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

#pragma mark - UIGestureRecognizer

- (void)tapImageView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        PicturePreviewViewController *pictureVC = [[[PicturePreviewViewController alloc] init] autorelease];
        pictureVC.index = gestureRecognizer.view.tag - kScrollViewImageViewTag;
        pictureVC.pictureArray = [NSMutableArray arrayWithArray:_deal.imageArray];
        pictureVC.delegate = self;
        [self presentViewController:pictureVC animated:YES completion:NULL];
    }
}

#pragma mark - PicturePreviewViewControllerDelegate

- (void)picturePreviewViewControllerDidDeleteImage:(PicturePreviewViewController *)picturePreviewVC
{
    _deal.imageArray = picturePreviewVC.pictureArray;
    
    [self refreshImageScrollView];
}

@end
