//
//  PPParkingDetailsView.m
//  PigParking
//
//  Created by VincentLi on 14-7-13.
//  Copyright (c) 2014年 VincentStation. All rights reserved.
//

#import "PPParkingDetailsView.h"
#import "PPMapView.h"
#import "PPHistoryDB.h"

@implementation PPParkingDetailsView

- (void)dealloc
{
    self.title = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage *im = [[UIImage imageNamed:@"parking-details-pull-view-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        iv.image = im;
        [self addSubview:iv];
        
        _chargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 11.0f, self.bounds.size.width, 14.0f)];
        _chargeLabel.font = [UIFont systemFontOfSize:14.0];
        _chargeLabel.textColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
        _chargeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_chargeLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, _chargeLabel.frame.origin.y+_chargeLabel.frame.size.height+5.0f, self.bounds.size.width, 14.0f)];
        _distanceLabel.font = [UIFont systemFontOfSize:14.0];
        _distanceLabel.textColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_distanceLabel];
        
        _parkingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, _distanceLabel.frame.origin.y+_distanceLabel.frame.size.height+5.0f, self.bounds.size.width, 14.0f)];
        _parkingCountLabel.font = [UIFont systemFontOfSize:14.0];
        _parkingCountLabel.textColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
        _parkingCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_parkingCountLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, _parkingCountLabel.frame.origin.y+_parkingCountLabel.frame.size.height+5.0f, self.bounds.size.width, 14.0f)];
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        _addressLabel.textColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
        _addressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_addressLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12.0f, 78.0f, 147.0f, 66.0f);
        [btn setImage:[UIImage imageNamed:@"idx-btn-go-here"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnGoHereClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(164.0f, 78.0f, 147.0f, 66.0f);
        [btn setImage:[UIImage imageNamed:@"idx-btn-details"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnShowDetailsClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)setChargeText:(NSString *)chargeText
{
    _chargeLabel.text = [NSString stringWithFormat:@"费用：%@", chargeText];
}

-(void)setDistanceText:(NSString *)distanceText
{
    _distanceLabel.text = [NSString stringWithFormat:@"距离：%@", distanceText];
}

- (void)setParkingCountText:(NSString *)parkingCountText
{
    _parkingCountLabel.text = [NSString stringWithFormat:@"车位：%@", parkingCountText];
}

- (void)setAddressText:(NSString *)addressText
{
    _addressLabel.text = [NSString stringWithFormat:@"地址：%@", addressText];
}

- (void)setFlag:(PPParkingTableViewCellFlag)flag
{
    if (PPParkingTableViewCellFlagNone == flag)
    {
        
    }
    else
    {
        UIImage *im = nil;
        
        switch (flag)
        {
            case PPParkingTableViewCellFlagCheap:
                im = [UIImage imageNamed:@"parking-cell-flag1"];
                break;
                
            case PPParkingTableViewCellFlagMost:
                im = [UIImage imageNamed:@"parking-cell-flag2"];
                break;
                
            case PPParkingTableViewCellFlagNearest:
                im = [UIImage imageNamed:@"parking-cell-flag3"];
                break;
                
            default:
                break;
        }
        
        if (im)
        {
            UIImageView *fv = [[UIImageView alloc] initWithImage:im];
            fv.frame = CGRectMake(self.bounds.size.width-fv.bounds.size.width-15.0f, 0.0f, fv.bounds.size.width, fv.bounds.size.height);
            [self addSubview:fv];
        }
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    _chargeLabel.text = [NSString stringWithFormat:@"费用：%@", data[@"charge"]];
    _distanceLabel.text = [NSString stringWithFormat:@"距离：%@", data[@"distance"]];
    _parkingCountLabel.text = [NSString stringWithFormat:@"车位：%@", data[@"parkingCount"]];
    _addressLabel.text = [NSString stringWithFormat:@"地址：%@", data[@"address"]];
    
    _toCoordinate = CLLocationCoordinate2DMake([data[@"lat"] floatValue], [data[@"lon"] floatValue]);
    
    self.flag = (PPParkingTableViewCellFlag)[data[@"flag"] intValue];
}

#pragma mark - 

- (void)btnGoHereClick
{
    if ([PPUser currentUser].isSaveSearchHistory)
    {
        [[PPHistoryDB db] insert:_data];
    }
    
    [PPMapView navigateFrom:_fromCoordinate to:_toCoordinate];
    
//    if (_delegate && [_delegate respondsToSelector:@selector(ppParkingDetailsViewGoHere:)])
//    {
//        [_delegate performSelector:@selector(ppParkingDetailsViewGoHere:) withObject:self];
//    }
}

- (void)btnShowDetailsClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(ppParkingDetailsViewShowDetails:)])
    {
        [_delegate performSelector:@selector(ppParkingDetailsViewShowDetails:) withObject:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
