//
//  TipsDetailViewController.m
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TipsDetailViewController.h"
#import "POI.h"
#import "ArticlePOIView.h"

@interface TipsDetailViewController () <ArticlePOIViewDelegate>

@end

@implementation TipsDetailViewController

@synthesize tipsId = _tipsId;
@synthesize tip = _tip;

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"Tips详情";
    
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
    
    [Tip getTipsListWithTipsId:_tipsId
                         brief:0
                        cityId:0
                       success:^(NSArray *array) {
                           
                           if([array count] > 0)
                           {
                               self.tip = [array objectAtIndex:0];
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
                    articlePOIView.keywordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)indexPath.row % 6 + 1]];
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

@end
