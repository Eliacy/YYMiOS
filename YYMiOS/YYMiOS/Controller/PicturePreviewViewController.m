//
//  PicturePreviewViewController.m
//  Secretary
//
//  Created by Lide on 14/12/17.
//
//

#import "PicturePreviewViewController.h"
#import "PictureImageView.h"

#define kPictureImageViewTag    76251

@interface PicturePreviewViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation PicturePreviewViewController

@synthesize index = _index;
@synthesize pictureArray = _pictureArray;

#pragma mark - private

- (void)clickCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickDeleteButton:(id)sender
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [_pictureArray removeObjectAtIndex:_index];
        if(_delegate && [_delegate respondsToSelector:@selector(picturePreviewViewControllerDidDeleteImage:)])
        {
            [_delegate picturePreviewViewControllerDidDeleteImage:self];
        }
        
        if([_pictureArray count] == 0)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            return;
        }
        
        if(_index > [_pictureArray count] - 1)
        {
            _index = [_pictureArray count] - 1;
        }
        [self refreshScrollView];
    }
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    
    LP_SAFE_RELEASE(_pictureArray);
    
    LP_VIEW_RELEASE(_closeButton);
    LP_VIEW_RELEASE(_deleteButton);
    
    LP_VIEW_RELEASE(_scrollView);
    
    if(_leftBrowserView != nil)
    {
        LP_VIEW_RELEASE(_leftBrowserView);
    }
    if(_middleBrowserView != nil)
    {
        LP_VIEW_RELEASE(_middleBrowserView);
    }
    if(_rightBrowserView != nil)
    {
        LP_VIEW_RELEASE(_rightBrowserView);
    }
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    _backButton.hidden = YES;
    
    _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _closeButton.frame = CGRectMake(2, 2, 40, 40);
    _closeButton.backgroundColor = [UIColor clearColor];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"btn_preview_close.png"] forState:UIControlStateNormal];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"btn_preview_close_highlighted.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_closeButton];
    
    _deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _deleteButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _deleteButton.backgroundColor = [UIColor clearColor];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_preview_delete.png"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_preview_delete_highlighted.png"] forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_deleteButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTap:)];
    oneFingerTap.delegate = self;
    [_scrollView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    [self refreshScrollView];
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

- (void)setPictureArray:(NSMutableArray *)pictureArray
{
    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:pictureArray];
}

- (void)setBrowserViewImage
{
    if(_middleBrowserView == nil)
    {
        _middleBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    if(_leftBrowserView == nil)
    {
        _leftBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    if(_rightBrowserView == nil)
    {
        _rightBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    
    _middleBrowserView.frame = CGRectMake(_scrollView.frame.size.width * _index, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_middleBrowserView];
    _middleBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index] imageURL] imageSize:CGSizeMake(_middleBrowserView.frame.size.width * 2, _middleBrowserView.frame.size.height * 2)];
    _leftBrowserView.frame = CGRectMake(_scrollView.frame.size.width * (_index - 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_leftBrowserView];
    _rightBrowserView.frame = CGRectMake(_scrollView.frame.size.width * (_index + 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_rightBrowserView];
    
    if(_index == 0)
    {
        _leftBrowserView.hidden = YES;
    }
    else
    {
        _leftBrowserView.hidden = NO;
        _leftBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index - 1] imageURL] imageSize:CGSizeMake(_leftBrowserView.frame.size.width * 2, _leftBrowserView.frame.size.height * 2)];
    }
    
    if(_index == [_pictureArray count] - 1)
    {
        _rightBrowserView.hidden = YES;
    }
    else
    {
        _rightBrowserView.hidden = NO;
        _rightBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index + 1] imageURL] imageSize:CGSizeMake(_rightBrowserView.frame.size.width * 2, _rightBrowserView.frame.size.height * 2)];
    }
}

- (void)refreshScrollView
{
    _scrollView.contentSize = CGSizeMake([_pictureArray count] * _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _index, 0)];
    _titleLabel.text = [NSString stringWithFormat:@"%i/%i", _index + 1, [_pictureArray count]];
    
    [self setBrowserViewImage];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    _titleLabel.text = [NSString stringWithFormat:@"%i/%i", index + 1, [_pictureArray count]];
    
    if(_index != index)
    {
        _index = index;
        
        [self setBrowserViewImage];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIImageView class]])
    {
        NSArray *gestureRecognizers = touch.gestureRecognizers;
        
        for(UIGestureRecognizer *aGestureRecognizer in gestureRecognizers)
        {
            if([aGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [(UITapGestureRecognizer *)aGestureRecognizer numberOfTapsRequired] == 2)
            {
                [gestureRecognizer requireGestureRecognizerToFail:aGestureRecognizer];
            }
        }
    }
    
    return YES;
}

- (void)oneFingerTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(CGAffineTransformEqualToTransform(_adjustView.transform, CGAffineTransformIdentity))
        {
            [UIView animateWithDuration:0.35 animations:^{
                _adjustView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -_adjustView.frame.size.height);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.35 animations:^{
                _adjustView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

@end
