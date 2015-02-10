//
//  TipsViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TipsViewController.h"
#import "POI.h"
#import "ArticlePOIView.h"
#import "ShopViewController.h"
#import "TitleExpandKit.h"

@interface TipsViewController () <ArticlePOIViewDelegate, TitleExpandKitDelegate>

@end

@implementation TipsViewController

@synthesize tip = _tip;

- (void)clickMoreButton:(id)sender
{
    if(_expandKit == nil)
    {
        _expandKit = [[[TitleExpandKit alloc] init] retain];
    }
    [_expandKit setItemArray:_tipArray];
    [_expandKit setDelegate:self];
    [_expandKit setAlign:YYMExpandAlignRight];
    [_expandKit show];
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _tipArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _moreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _moreButton.frame = CGRectMake(_headerView.frame.size.width - 10 - 40, 2, 40, 40);
    _moreButton.backgroundColor = [UIColor clearColor];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
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
    
    [Tip getTipsListWithTipsId:0
                         brief:1
                        cityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                       success:^(NSArray *array) {
                           
                           if([_tipArray count] > 1)
                           {
                               [_moreButton removeFromSuperview];
                           }
                           
                           if([array count] > 0)
                           {
                               if([array count] > 1)
                               {
                                   [_headerView addSubview:_moreButton];
                               }
                               
                               [_tipArray removeAllObjects];
                               [_tipArray addObjectsFromArray:array];
                               
                               _titleLabel.text = [[array objectAtIndex:0] title];
                               
                               [Tip getTipsListWithTipsId:[[array objectAtIndex:0] tipId]
                                                    brief:0
                                                   cityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                                                  success:^(NSArray *array) {
                                                      
                                                      if([array count] > 0)
                                                      {
                                                          self.tip = [array objectAtIndex:0];
                                                      }
                                                      
                                                  } failure:^(NSError *error) {
                                                      
                                                  }];
                           }
                           
                       } failure:^(NSError *error) {
                           
                       }];
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

- (void)setTip:(Tip *)tip
{
    if(_tip != nil)
    {
        LP_SAFE_RELEASE(_tip);
    }
    _tip = [tip retain];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    NSDictionary *dictionary = [_tip.contentArray objectAtIndex:indexPath.row];
    switch ([[dictionary objectForKey:@"type"] integerValue])
    {
        case 1:
        {
            CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                      font:[UIFont systemFontOfSize:12.0f]
                                                      size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
            height += size.height + 15;
        }
            break;
        case 2:
        {
            CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                      font:[UIFont systemFontOfSize:14.0f]
                                                      size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
            height += size.height + 15;
        }
            break;
        case 3:
        {
            height += 165 + 15;
        }
            break;
        case 4:
        {
            height += 88;
        }
            break;
        case 5:
        {
            height += 1;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tip && _tip.contentArray && [_tip.contentArray count] > 0)
    {
        return [_tip.contentArray count];
    }
    else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArticleViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dictionary = [_tip.contentArray objectAtIndex:indexPath.row];
    switch ([[dictionary objectForKey:@"type"] integerValue])
    {
        case 1:
        {
            CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                      font:[UIFont systemFontOfSize:12.0f]
                                                      size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, size.height)] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.numberOfLines = 0;
            label.text = [dictionary objectForKey:@"content"];
            [cell.contentView addSubview:label];
        }
            break;
        case 2:
        {
            CGSize size = [LPUtility getTextHeightWithText:[dictionary objectForKey:@"content"]
                                                      font:[UIFont systemFontOfSize:14.0f]
                                                      size:CGSizeMake(_tableView.frame.size.width - 15 * 2, 2000)];
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, size.height)] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [dictionary objectForKey:@"content"];
            [cell.contentView addSubview:label];
        }
            break;
        case 3:
        {
            LPImage *image = [[LPImage alloc] initWithAttribute:[dictionary objectForKey:@"content"]];
            
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, _tableView.frame.size.width - 15 * 2, 165)] autorelease];
            [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:image.imageURL imageSize:CGSizeMake((_tableView.frame.size.width - 15 * 2) * 2, 165 * 2)]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
            break;
        case 4:
        {
            dictionary = [dictionary objectForKey:@"content"];
            if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
            {
                POI *poi = [[[POI alloc] initWithAttribute:dictionary] autorelease];
                ArticlePOIView *articlePOIView = [[[ArticlePOIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 88)] autorelease];
                articlePOIView.delegate = self;
                [cell.contentView addSubview:articlePOIView];
                [articlePOIView setPoi:poi];
                
                if(poi.keywordArray && [poi.keywordArray isKindOfClass:[NSArray class]] && [poi.keywordArray count] > 0)
                {
                    articlePOIView.keywordImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)indexPath.row % 6 + 1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
                }
                else
                {
                    articlePOIView.keywordImageView.image = nil;
                }
                
                UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5)] autorelease];
                view.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:view];
            }
        }
            break;
        case 5:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5)] autorelease];
            view.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:view];
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
    return nil;
}

#pragma mark - ArticlePOIViewDelegate

- (void)articlePOIViewDidTap:(ArticlePOIView *)articlePOIView
{
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    shopVC.poiId = articlePOIView.poi.poiId;
    [self.navigationController pushViewController:shopVC animated:YES];
}

//- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer
//{
//    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
//    {
//        if(_expandKit == nil)
//        {
//            _expandKit = [[[TitleExpandKit alloc] init] retain];
//        }
//        [_expandKit setItemArray:_tipArray];
//        [_expandKit setDelegate:self];
//        [_expandKit setAlign:YYMExpandAlignRight];
//        [_expandKit show];
//    }
//}

#pragma mark - TitleExpandKitDelegate

- (void)titleExpandKitDidSelectWithIndex:(NSIndexPath *)indexPath
{
    _titleLabel.text = [[_tipArray objectAtIndex:indexPath.row] title];
    
    [Tip getTipsListWithTipsId:[[_tipArray objectAtIndex:indexPath.row] tipId]
                         brief:0
                        cityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                       success:^(NSArray *array) {
                           
                           if([array count] > 0)
                           {
                               self.tip = [array objectAtIndex:0];
                           }
                           
                       } failure:^(NSError *error) {
                           
                       }];
}

@end
