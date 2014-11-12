//
//  ShopDetailView.m
//  YYMiOS
//
//  Created by Lide on 14/11/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopDetailView.h"

@implementation ShopDetailView

@synthesize poiDetail = _poiDetail;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setPoiDetail:(POIDetail *)poiDetail
{
    if(_poiDetail != nil)
    {
        LP_SAFE_RELEASE(_poiDetail);
    }
    _poiDetail = [poiDetail retain];
    
    CGFloat height = [ShopDetailView getShopDetailViewHeightWithPOIDetail:poiDetail];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if(_poiDetail.categoryArray && [_poiDetail.categoryArray count] > 0)
            {
                return 20;
            }
        }
            break;
        case 1:
        {
            if(_poiDetail.environment && ![_poiDetail.environment isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        case 2:
        {
            if(_poiDetail.paymentArray && [_poiDetail.paymentArray count] > 0)
            {
                return 20;
            }
        }
            break;
        case 3:
        {
            if(_poiDetail.menu && ![_poiDetail.menu isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        case 4:
        {
            if(_poiDetail.ticket && ![_poiDetail.ticket isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        case 5:
        {
            if(_poiDetail.booking && ![_poiDetail.booking isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        case 6:
        {
            if(_poiDetail.businessHours && ![_poiDetail.businessHours isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        case 7:
        {
            if(_poiDetail.phone && ![_poiDetail.phone isEqualToString:@""])
            {
                return 20;
            }
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailViewIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopDetailViewIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            if(_poiDetail.categoryArray && [_poiDetail.categoryArray count] > 0)
            {
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)] autorelease];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                [cell.contentView addSubview:label];
                
                NSMutableString *string = [NSMutableString stringWithCapacity:0];
                for(NSInteger i = 0; i < [_poiDetail.categoryArray count]; i++)
                {
                    if(i == [_poiDetail.categoryArray count] - 1)
                    {
                        [string appendString:[_poiDetail.categoryArray objectAtIndex:i]];
                    }
                    else
                    {
                        [string appendFormat:@"%@｜", [_poiDetail.categoryArray objectAtIndex:i]];
                    }
                }
                label.text = string;
            }
        }
            break;
        case 1:
        {
            if(_poiDetail.environment && ![_poiDetail.environment isEqualToString:@""])
            {
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)] autorelease];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = [NSString stringWithFormat:@"环境：%@", _poiDetail.environment];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 2:
        {
            if(_poiDetail.paymentArray && [_poiDetail.paymentArray count] > 0)
            {
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)] autorelease];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = @"付款方式：";
                [cell.contentView addSubview:label];
                
                CGSize size = [LPUtility getTextHeightWithText:label.text
                                                          font:label.font
                                                          size:CGSizeMake(200, 200)];
                
                for(NSInteger i = 0; i < [_poiDetail.paymentArray count]; i++)
                {
                    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(size.width + i * 20, 5, 16, 11)] autorelease];
                    imageView.backgroundColor = [UIColor clearColor];
                    if([[_poiDetail.paymentArray objectAtIndex:i] isEqualToString:@"Visa"])
                    {
                        imageView.image = [UIImage imageNamed:@"icon_visa.png"];
                    }
                    else if([[_poiDetail.paymentArray objectAtIndex:i] isEqualToString:@"Master"])
                    {
                        imageView.image = [UIImage imageNamed:@"icon_mastercard.png"];
                    }
                    else
                    {
                        imageView.image = [UIImage imageNamed:@"icon_bank.png"];
                    }
                    [cell.contentView addSubview:imageView];
                }
            }
        }
            break;
        case 3:
        {
            if(_poiDetail.menu && ![_poiDetail.menu isEqualToString:@""])
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = [NSString stringWithFormat:@"中文菜单：%@", _poiDetail.menu];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 4:
        {
            if(_poiDetail.ticket && ![_poiDetail.ticket isEqualToString:@""])
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = [NSString stringWithFormat:@"门票：%@", _poiDetail.ticket];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 5:
        {
            if(_poiDetail.booking && ![_poiDetail.booking isEqualToString:@""])
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = [NSString stringWithFormat:@"提前预定：%@", _poiDetail.booking];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 6:
        {
            if(_poiDetail.businessHours && ![_poiDetail.businessHours isEqualToString:@""])
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.text = [NSString stringWithFormat:@"营业时间：%@", _poiDetail.businessHours];
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 7:
        {
            if(_poiDetail.phone && ![_poiDetail.phone isEqualToString:@""])
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:13.0f];
                [cell.contentView addSubview:label];
                
                NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话号码：%@", _poiDetail.phone]] autorelease];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:2.0 / 255.0 green:102.0 / 255.0 blue:237.0 / 255.0 alpha:1.0] range:NSMakeRange(string.length - _poiDetail.phone.length, _poiDetail.phone.length)];
                
                label.attributedText = string;
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
    return nil;
}

#pragma mark - public

+ (CGFloat)getShopDetailViewHeightWithPOIDetail:(POIDetail *)poiDetail
{
    CGFloat height = 0;
    
    if(poiDetail.categoryArray && [poiDetail.categoryArray count] > 0)
    {
        height += 20;
    }
    if(poiDetail.environment && ![poiDetail.environment isEqualToString:@""])
    {
        height += 20;
    }
    if(poiDetail.paymentArray && [poiDetail.paymentArray count] > 0)
    {
        height += 20;
    }
    if(poiDetail.menu && ![poiDetail.menu isEqualToString:@""])
    {
        height += 20;
    }
    if(poiDetail.ticket && ![poiDetail.ticket isEqualToString:@""])
    {
        height += 20;
    }
    if(poiDetail.booking && ![poiDetail.booking isEqualToString:@""])
    {
        height += 20;
    }
    if(poiDetail.businessHours && ![poiDetail.businessHours isEqualToString:@""])
    {
        height += 20;
    }
    if(poiDetail.phone && ![poiDetail.phone isEqualToString:@""])
    {
        height += 20;
    }
    
    return height;
}

@end
