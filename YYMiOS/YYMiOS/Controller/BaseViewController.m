//
//  BaseViewController.m
//  Secretary
//
//  Created by lide on 14-7-30.
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - private

- (void)clickBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _isLoading = NO;
    }
    
    return self;
}

- (void)dealloc
{
    LP_VIEW_RELEASE(_adjustView);
    LP_VIEW_RELEASE(_headerView);
    LP_VIEW_RELEASE(_titleLabel);
    LP_VIEW_RELEASE(_backButton);
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
    
    _adjustView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64 - self.view.frame.origin.y)];
    _adjustView.backgroundColor = [UIColor colorWithRed:249.0 / 255.0 green:100.0 / 255.0 blue:128.0 / 255.0 alpha:1.0];
    [self.view addSubview:_adjustView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height - 44, _adjustView.frame.size.width, 44)];
    _headerView.backgroundColor = [UIColor clearColor];
    [_adjustView addSubview:_headerView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, _headerView.frame.size.width - 75 * 2, _headerView.frame.size.height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    _titleLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_titleLabel];
    _titleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *titleLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleLabel:)];
    [_titleLabel addGestureRecognizer:titleLabelTap];
    [titleLabelTap release];

    _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backButton.frame = CGRectMake(2, 2, 40, 40);
    _backButton.backgroundColor = [UIColor clearColor];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlighted.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_backButton];
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
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view bringSubviewToFront:_adjustView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark - UIGestureRecognizer

- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer
{

}

@end
