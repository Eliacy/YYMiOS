//
//  Toast+UIView.m
//  Toast
//  Version 1.1
//
//  Copyright 2012 Charles Scalesse.
//

#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kMaxWidth                   0.8
#define kMaxHeight                  0.8

#define kHorizontalPadding          10.0
#define kVerticalPadding            10.0
#define kCornerRadius               10.0
#define kOpacity                    0.7
#define kFontSize                   16.0
#define kMaxTitleLines              999
#define kMaxMessageLines            999
#define kFadeDuration               0.2
#define kDisplayShadow              NO

#define kDefaultLength              3.0
#define kDefaultPosition            @"bottom"

#define kImageWidth                 80.0
#define kImageHeight                80.0

#define kActivityWidth              100.0
#define kActivityHeight             100.0
#define kActivityDefaultPosition    @"center"
#define kActivityTag                91325
#define kToastTag                   91326
static NSString *kDurationKey = @"CSToastDurationKey";


@interface UIView (ToastPrivate)

- (CGPoint)getPositionFor:(id)position toast:(UIView *)toast;
- (UIView *)makeViewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image isShadow:(BOOL)_isShadow;
- (UIView *)makeActivityViewForMessage:(NSString *)message;

@end


@implementation UIView (Toast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message isShadow:(BOOL)_isShadow{
    [self makeToast:message duration:kDefaultLength position:kDefaultPosition isShadow:_isShadow];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position
{
    [self makeToast:message duration:interval position:position image:nil isShadow:NO];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position isShadow:(BOOL)_isShadow{
    UIView *toast = [self makeViewForMessage:message title:nil image:nil isShadow:_isShadow];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title isShadow:(BOOL)_isShadow{
    UIView *toast = [self makeViewForMessage:message title:title image:nil isShadow:_isShadow];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image isShadow:(BOOL)_isShadow{
    UIView *toast = [self makeViewForMessage:message title:nil image:image isShadow:_isShadow];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image isShadow:(BOOL)_isShadow
{
    UIView *toast = [self makeViewForMessage:message title:title image:image isShadow:_isShadow];
    [self showToast:toast duration:interval position:position];
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:kDefaultLength position:kDefaultPosition];
}

-(void)makeMyToast:(NSString *)message position:(id)position
{
    UIView *toast = [self makeViewForMessage:message title:nil image:nil isShadow:0];
    [self showToast:toast duration:0 position:position];
}

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point
{
    /****************************************************
     *                                                  *
     * Displays a view for a given duration & position. *
     *                                                  *
     ****************************************************/
    
    CGPoint toastPoint = [self getPositionFor:point toast:toast];
    
    
    [toast setCenter:toastPoint];
    [toast setAlpha:0.0];
    [toast setTag:kToastTag];
    //[self addSubview:toast];
    
    if([[[UIApplication sharedApplication] windows] count] > 1)
    {
        [[[[UIApplication sharedApplication] windows] objectAtIndex:1] addSubview:toast];
    }
    else
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:toast];
    }
    
    
    
    
    [UIView beginAnimations:@"fade_in" context:toast];
    [UIView setAnimationDuration:kFadeDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [toast setAlpha:1.0];
    [UIView commitAnimations];
    
    
    if(interval != 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    }
    else
    {
        
    }
}
- (void)hideToast
{
    UIView *toast;
    toast = (UIView *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:kToastTag];

    
    
    if(!toast)
    {
        toast = [(UIView *)[[[UIApplication sharedApplication] windows] objectAtIndex:0] viewWithTag:kToastTag];
        
    }
    
    if(!toast)
    {
        
        
        if([[[UIApplication sharedApplication] windows] count] > 1)
        {
            toast = [(UIView *)[[[UIApplication sharedApplication] windows] objectAtIndex:1] viewWithTag:kToastTag];
        }
    }
    
    if(toast)
    {
        [UIView beginAnimations:@"fade_out" context:toast];
        [UIView setAnimationDuration:kFadeDuration];
        [UIView setAnimationDelegate:toast];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [toast setAlpha:0.0];
        [toast removeFromSuperview];
        [UIView commitAnimations];
    }
    else
    {
        
    }
}

- (void)hideToastnoAnimation
{
    UIView *toast;
    toast = (UIView *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:kToastTag];
    
    
    
    if(!toast)
    {
        toast = [(UIView *)[[[UIApplication sharedApplication] windows] objectAtIndex:0] viewWithTag:kToastTag];
        
    }
    
    if(!toast)
    {
        
        
        if([[[UIApplication sharedApplication] windows] count] > 1)
        {
            toast = [(UIView *)[[[UIApplication sharedApplication] windows] objectAtIndex:1] viewWithTag:kToastTag];
        }
    }
    
    if(toast)
    {
        [toast removeFromSuperview];
    }
    else
    {
        
    }
}
#pragma mark - Toast Activity Methods
- (void)makeToastActivity {
    
    [self makeToastActivity:kActivityDefaultPosition];
    
    
}

- (void)makeToastActivity:(id)position {
    // prevent more than one activity view
    UIView *existingToast = [self viewWithTag:kActivityTag];
    if (existingToast != nil) {
        [existingToast removeFromSuperview];
    }
    
    UIView *activityContainer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kActivityWidth, kActivityHeight)] autorelease];
    [activityContainer setCenter:[self getPositionFor:position toast:activityContainer]];
    [activityContainer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:kOpacity]];
    [activityContainer setAlpha:0.0];
    [activityContainer setTag:kActivityTag];
    [activityContainer.layer setCornerRadius:kCornerRadius];
    if (kDisplayShadow) {
        [activityContainer.layer setShadowColor:[UIColor blackColor].CGColor];
        [activityContainer.layer setShadowOpacity:0.8];
        [activityContainer.layer setShadowRadius:6.0];
        [activityContainer.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
    }
    
    UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [activityView setCenter:CGPointMake(activityContainer.bounds.size.width / 2, activityContainer.bounds.size.height / 2)];
    [activityContainer addSubview:activityView];
    [activityView startAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kFadeDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [activityContainer setAlpha:1.0];
    [UIView commitAnimations];
    
    [self addSubview:activityContainer];
}

- (void)hideToastActivity {
    UIView *existingToast = [self viewWithTag:kActivityTag];
    if (existingToast != nil) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kFadeDuration];
        [UIView setAnimationDelegate:existingToast];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [existingToast setAlpha:0.0];
        [UIView commitAnimations];
    }
}

#pragma mark - Animation Delegate Method

//- (void)animationDidStop:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
//
//    UIView *toast = (UIView *)context;
//    BFLog(@"%@,%d",context,finished);
//    // retrieve the display interval associated with the view
//    CGFloat interval = [(NSNumber *)objc_getAssociatedObject(toast, &kDurationKey) floatValue];
//
//    if([animationID isEqualToString:@"fade_in"]) {
//
//        [UIView beginAnimations:@"fade_out" context:toast];
//        [UIView setAnimationDelay:interval];
//        [UIView setAnimationDuration:kFadeDuration];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//        [toast setAlpha:0.0];
//        [UIView commitAnimations];
//
//    } else if ([animationID isEqualToString:@"fade_out"]) {
//
//        [toast removeFromSuperview];
//
//    }
//
//}


#pragma mark - Private Methods
- (CGPoint)getPositionFor:(id)point toast:(UIView *)toast {
    
    /*************************************************************************************
     *                                                                                   *
     * Converts string literals @"top", @"bottom", @"center", or any point wrapped in an *
     * NSValue object into a CGPoint                                                     *
     *                                                                                   *
     *************************************************************************************/
    
    if([point isKindOfClass:[NSString class]]) {
        
        if( [point caseInsensitiveCompare:@"top"] == NSOrderedSame ) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + kVerticalPadding);
        } else if( [point caseInsensitiveCompare:@"bottom"] == NSOrderedSame ) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - kVerticalPadding);
        } else if( [point caseInsensitiveCompare:@"center"] == NSOrderedSame ) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        } else if( [point caseInsensitiveCompare:@"bottomCenter"] == NSOrderedSame ) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2-self.bounds.size.height / 16);
        }
        
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    
    return [self getPositionFor:kDefaultPosition toast:toast];
}

- (UIView *)makeViewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image isShadow:(BOOL)_isShadow{
    
    /***********************************************************************************
     *                                                                                 *
     * Dynamically build a toast view with any combination of message, title, & image. *
     *                                                                                 *
     ***********************************************************************************/
    
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[[UIView alloc] init] autorelease];
    [wrapperView.layer setBorderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
    //[wrapperView.layer setBorderWidth:3];
    [wrapperView.layer setCornerRadius:kCornerRadius];
    if (_isShadow) {
        [wrapperView.layer setShadowColor:[UIColor blackColor].CGColor];
        [wrapperView.layer setShadowOpacity:0.8];
        [wrapperView.layer setShadowRadius:6.0];
        [wrapperView.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
    }
    
    [wrapperView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:kOpacity]];
    
    if(image != nil) {
        imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kImageWidth, kImageHeight)];
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = kHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[[UILabel alloc] init] autorelease];
        [titleLabel setNumberOfLines:kMaxTitleLines];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:kFontSize]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setOpaque:NO];
        //[titleLabel setAlpha:1.0];
        [titleLabel setText:title];
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * kMaxWidth) - imageWidth, self.bounds.size.height * kMaxHeight);
        CGSize expectedSizeTitle = [LPUtility getTextHeightWithText:title
                                                               font:titleLabel.font
                                                               size:maxSizeTitle];
        [titleLabel setFrame:CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height)];
    }
    
    if (message != nil) {
        messageLabel = [[[UILabel alloc] init] autorelease];
        [messageLabel setNumberOfLines:kMaxMessageLines];
        [messageLabel setFont:[UIFont boldSystemFontOfSize:kFontSize]];
        [messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setTextColor:[UIColor whiteColor]];
        messageLabel.opaque = NO;
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        //[messageLabel setAlpha:1.0];
        [messageLabel setText:message];
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * kMaxWidth) - imageWidth, self.bounds.size.height * kMaxHeight);
        CGSize expectedSizeMessage = [LPUtility getTextHeightWithText:message
                                                                 font:messageLabel.font
                                                                 size:maxSizeMessage];
        [messageLabel setFrame:CGRectMake(0.0, 0.0, expectedSizeMessage.width+40, expectedSizeMessage.height+30)];
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = kVerticalPadding;
        titleLeft = imageLeft + imageWidth + kHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + kHorizontalPadding;
        messageTop = titleTop + titleHeight + kVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (kHorizontalPadding * 2)), (longerLeft + longerWidth + kHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + kVerticalPadding), (imageHeight + (kVerticalPadding * 2)));
    
    [wrapperView setFrame:CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight)];
    
    if(titleLabel != nil) {
        [titleLabel setFrame:CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)];
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        [messageLabel setFrame:CGRectMake(messageLeft, messageTop, messageWidth, messageHeight)];
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end
