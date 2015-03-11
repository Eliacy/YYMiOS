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

@interface DealEditViewController () <POISelectViewControllerDelegate, UserAtListViewControllerDelegate, UITextViewDelegate, PhotoSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PicturePreviewViewControllerDelegate, RankViewDelegate, UITextFieldDelegate>

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
    
    NSMutableString *atString = [NSMutableString stringWithCapacity:0];
    for(NSInteger i = 0; i < [_deal.atList count]; i++)
    {
        if(i == [_deal.atList count] - 1)
        {
            [atString appendFormat:@"%i", [[_deal.atList objectAtIndex:i] userId]];
        }
        else
        {
            [atString appendFormat:@"%i ", [[_deal.atList objectAtIndex:i] userId]];
        }
    }
    
    [Deal createDealDetailWithPublished:0
                                 userId:[[User sharedUser] userId]
                                 atList:atString
                                   star:_deal.star
                                content:_deal.content
                                 images:imageString
                               keywords:_deal.keywordString
                                  total:_deal.total
                               currency:_deal.currency
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

- (void)clickCurrencyButton:(id)sender
{
    if([_currencyButton.titleLabel.text isEqualToString:@"美元"])
    {
        [_currencyButton setTitle:@"人民币" forState:UIControlStateNormal];
    }
    else if([_currencyButton.titleLabel.text isEqualToString:@"人民币"])
    {
        [_currencyButton setTitle:@"欧元" forState:UIControlStateNormal];
    }
    else if([_currencyButton.titleLabel.text isEqualToString:@"欧元"])
    {
        [_currencyButton setTitle:@"港币" forState:UIControlStateNormal];
    }
    else if([_currencyButton.titleLabel.text isEqualToString:@"港币"])
    {
        [_currencyButton setTitle:@"美元" forState:UIControlStateNormal];
    }
    
    _deal.currency = _currencyButton.titleLabel.text;
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
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 350)];
    _tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _tableFooterView;
    
    UIView *tapView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableFooterView.frame.size.width, _tableFooterView.frame.size.height)] autorelease];
    tapView.backgroundColor = [UIColor clearColor];
    [_tableFooterView addSubview:tapView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [tapView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, _tableFooterView.frame.size.width - 15 * 2, 15)];
    _rankLabel.backgroundColor = [UIColor clearColor];
    _rankLabel.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    _rankLabel.font = [UIFont systemFontOfSize:18.0f];
    _rankLabel.text = @"评分";
    [_tableFooterView addSubview:_rankLabel];
    
    CGSize rankSize = [LPUtility getTextHeightWithText:_rankLabel.text
                                                  font:_rankLabel.font
                                                  size:CGSizeMake(200, 100)];
    
    _rankView = [[RankView alloc] initWithFrame:CGRectMake(_rankLabel.frame.origin.x + rankSize.width + 15, _rankLabel.frame.origin.y - 1, 144, 16)];
    _rankView.delegate = self;
    [_tableFooterView addSubview:_rankView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _rankLabel.frame.origin.y + _rankLabel.frame.size.height + 15, _rankLabel.frame.size.width, _rankLabel.frame.size.height)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    _priceLabel.font = [UIFont systemFontOfSize:18.0f];
    _priceLabel.text = @"总价";
    [_tableFooterView addSubview:_priceLabel];
    
    CGSize priceSize = [LPUtility getTextHeightWithText:_priceLabel.text
                                                   font:_priceLabel.font
                                                   size:CGSizeMake(200, 100)];
    
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x + priceSize.width + 15, _priceLabel.frame.origin.y - 7, 150, 30)];
    _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
    _priceTextField.font = [UIFont systemFontOfSize:16.0f];
    _priceTextField.textColor = [UIColor blackColor];
    _priceTextField.placeholder = @"输入价格......";
    _priceTextField.delegate = self;
    _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_priceTextField addTarget:self action:@selector(priceTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tableFooterView addSubview:_priceTextField];
    
    _currencyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _currencyButton.frame = CGRectMake(_priceTextField.frame.origin.x + _priceTextField.frame.size.width + 5, _priceTextField.frame.origin.y, 50, 30);
    _currencyButton.backgroundColor = [UIColor clearColor];
    [_currencyButton setTitle:@"美元" forState:UIControlStateNormal];
    [_currencyButton setTitleColor:[UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    _currencyButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_currencyButton addTarget:self action:@selector(clickCurrencyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_currencyButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 20, _tableFooterView.frame.size.width, 60)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_tableFooterView addSubview:_scrollView];
    
    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _scrollView.frame.origin.y + _scrollView.frame.size.height + 20, _tableFooterView.frame.size.width - 15 * 2, 15)];
    _keywordLabel.backgroundColor = [UIColor clearColor];
    _keywordLabel.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    _keywordLabel.font = [UIFont systemFontOfSize:18.0f];
    _keywordLabel.text = @"关键词:";
    [_tableFooterView addSubview:_keywordLabel];
    
    CGSize keywordSize = [LPUtility getTextHeightWithText:_keywordLabel.text
                                                     font:_keywordLabel.font
                                                     size:CGSizeMake(200, 100)];
    
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_keywordLabel.frame.origin.x + keywordSize.width + 15, _keywordLabel.frame.origin.y - 7, _keywordLabel.frame.size.width - keywordSize.width - 15, 30)];
    _keywordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _keywordTextField.font = [UIFont systemFontOfSize:16.0f];
    _keywordTextField.textColor = [UIColor blackColor];
    _keywordTextField.placeholder = @"多个关键字用，隔开";
    _keywordTextField.delegate = self;
    [_keywordTextField addTarget:self action:@selector(keywordTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tableFooterView addSubview:_keywordTextField];
    
    _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, _keywordLabel.frame.origin.y + _keywordLabel.frame.size.height + 20, _tableFooterView.frame.size.width - 15 * 2, 70)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.placeholder = @"写点什么吧......";
    _textView.delegate = self;
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.masksToBounds = YES;
    [_tableFooterView addSubview:_textView];
    
    _addPhotoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _addPhotoButton.frame = CGRectMake(15, 0, 60, 60);
    _addPhotoButton.backgroundColor = [UIColor clearColor];
    [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
    [_addPhotoButton addTarget:self action:@selector(clickAddPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addPhotoButton];
    
    _publishButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _publishButton.frame = CGRectMake(20, _textView.frame.origin.y + _textView.frame.size.height + 15, _tableFooterView.frame.size.width - 20 * 2, 40);
    _publishButton.backgroundColor = GColor(251, 100, 129);
    _publishButton.layer.cornerRadius = 5.0;
    _publishButton.layer.masksToBounds = YES;
    [_publishButton setTitle:@"发布评论" forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(clickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:_publishButton];
    
    if(self.deal == nil)
    {
        self.deal = [[Deal alloc] init];
        self.deal.dealKey = [NSString stringWithFormat:@"%i_%i", (int)[[NSDate date] timeIntervalSince1970], arc4random()];
        self.deal.imageArray = [NSArray array];
        self.deal.star = 0;
        self.deal.currency = @"美元";
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
    _rankView.starCount = _deal.star;
    if(_deal.total != 0)
    {
        _priceTextField.text = [NSString stringWithFormat:@"%i", (int)_deal.total];
    }
    if(_deal.currency && ![_deal.currency isEqualToString:@""])
    {
        [_currencyButton setTitle:_deal.currency forState:UIControlStateNormal];
    }
    else
    {
        [_currencyButton setTitle:@"美元" forState:UIControlStateNormal];
    }
    _keywordTextField.text = _deal.keywordString;
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
            if(_deal.atList && [_deal.atList isKindOfClass:[NSArray class]] && [_deal.atList count] > 0)
            {
                NSMutableString *mutableString = [NSMutableString stringWithCapacity:0];
                for(NSInteger i = 0; i < [_deal.atList count]; i++)
                {
                    if(i == [_deal.atList count] - 1)
                    {
                        [mutableString appendString:[[_deal.atList objectAtIndex:i] userName]];
                    }
                    else
                    {
                        [mutableString appendFormat:@"%@,", [[_deal.atList objectAtIndex:i] userName]];
                    }
                }
                cell.textLabel.text = mutableString;
            }
            else
            {
                cell.textLabel.text = @"我要@TA";
            }
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
    _deal.atList = [NSArray arrayWithArray:userAtListVC.selectArray];
    
    [_tableView reloadData];
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
        else if([_keywordTextField isFirstResponder])
        {
            [_keywordTextField resignFirstResponder];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _deal.content = textView.text;
}

#pragma mark - UITextFieldDelegate

- (void)priceTextFieldDidChange:(id)sender
{
    _deal.total = [_priceTextField.text integerValue];
}

- (void)keywordTextFieldDidChange:(id)sender
{
    _deal.keywordString = _keywordTextField.text;
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

#pragma mark - RankViewDelegate

- (void)rankViewDidClickStarButton:(RankView *)rankView
{
    _deal.star = rankView.starCount;
}

@end
