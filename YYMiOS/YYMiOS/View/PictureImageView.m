//
//  PictureImageView.m
//  Secretary
//
//  Created by Lide on 14/12/17.
//
//

#import "PictureImageView.h"

@implementation PictureImageView

@synthesize asset = _asset;
@synthesize imageURL = _imageURL;

@synthesize imageView = _imageView;

#pragma mark - private

- (void)centerScrollViewContents {
    CGSize boundsSize = _scrollView.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _imageView.frame = contentsFrame;
}

#pragma mark - super

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
        
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
        tapTwice.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:tapTwice];
        [tapTwice release];
        
        _indicatior = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatior.center = self.center;
        [self addSubview:_indicatior];
    }
    
    return self;
}

- (void)dealloc
{
    LP_SAFE_RELEASE(_asset);
    
    LP_VIEW_RELEASE(_scrollView);
    LP_VIEW_RELEASE(_imageView);
    
    [super dealloc];
}

- (void)setAsset:(ALAsset *)asset
{
    if(_asset != nil)
    {
        LP_SAFE_RELEASE(_asset);
    }
    _asset = [asset retain];
    
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _imageView.image = nil;
    
    if(_imageView != nil)
    {
        LP_VIEW_RELEASE(_imageView);
    }
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
    
    if(_imageView.image.size.width / _imageView.image.size.height > 320 / _scrollView.frame.size.height)
    {
        _scrollView.contentSize = CGSizeMake(_imageView.image.size.width / _imageView.image.size.height * _scrollView.frame.size.height, _scrollView.frame.size.height);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _imageView.image.size.height / _imageView.image.size.width * _scrollView.frame.size.width);
    }
    _imageView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
    tapTwice.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:tapTwice];
    [tapTwice release];
    
    _scrollView.minimumZoomScale = MIN(_scrollView.frame.size.width / _scrollView.contentSize.width, _scrollView.frame.size.height / _scrollView.contentSize.height);
    _scrollView.maximumZoomScale = MAX(_imageView.image.size.width / [[UIScreen mainScreen] bounds].size.width / 2 * 1.2, _scrollView.minimumZoomScale * 1.5);
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
}

- (void)setImageURL:(NSString *)imageURL
{
    if(_imageURL != nil)
    {
        LP_SAFE_RELEASE(_imageURL);
    }
    _imageURL = [imageURL retain];
    
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _imageView.image = nil;
    
    [_indicatior startAnimating];
    
    [_imageView setImageWithURL:[NSURL URLWithString:imageURL]
               placeholderImage:nil
                        success:^(UIImage *image) {
                            
                            [_indicatior stopAnimating];
                            
                            if(_imageView != nil)
                            {
                                LP_VIEW_RELEASE(_imageView);
                            }
                            _imageView = [[UIImageView alloc] initWithImage:image];
                            
                            if(_imageView.image.size.width / _imageView.image.size.height > 320 / _scrollView.frame.size.height)
                            {
                                _scrollView.contentSize = CGSizeMake(_imageView.image.size.width / _imageView.image.size.height * _scrollView.frame.size.height, _scrollView.frame.size.height);
                            }
                            else
                            {
                                _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _imageView.image.size.height / _imageView.image.size.width * _scrollView.frame.size.width);
                            }
                            _imageView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
                            _imageView.backgroundColor = [UIColor clearColor];
                            _imageView.contentMode = UIViewContentModeScaleAspectFill;
                            _imageView.layer.masksToBounds = YES;
                            _imageView.userInteractionEnabled = YES;
                            [_scrollView addSubview:_imageView];
                            
                            UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
                            tapTwice.numberOfTapsRequired = 2;
                            [_imageView addGestureRecognizer:tapTwice];
                            [tapTwice release];
                            
                            _scrollView.minimumZoomScale = MIN(_scrollView.frame.size.width / _scrollView.contentSize.width, _scrollView.frame.size.height / _scrollView.contentSize.height);
                            _scrollView.maximumZoomScale = MAX(_imageView.image.size.width / [[UIScreen mainScreen] bounds].size.width / 2 * 1.2, _scrollView.minimumZoomScale * 1.5);
                            _scrollView.zoomScale = _scrollView.minimumZoomScale;
                            
                        } failure:^(NSError *error) {
                            
                            [_indicatior stopAnimating];
                            
                        }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark - UIGestureRecognizer

- (void)tapTwice:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(_scrollView.zoomScale < _scrollView.maximumZoomScale)
        {
            [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
        }
        else
        {
            [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
        }
    }
}

@end
