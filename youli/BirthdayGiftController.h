//
//  BirthdayGiftController.h
//  gift
//
//  Created by ufida on 12-12-10.
//  Copyright (c) 2012年 ufida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirthdayGiftControllerItem.h"
#import "NMRangeSlider.h"
#import "YouliDelegate.h"
#import "BaseController.h"

@interface BirthdayGiftController : BaseController<UIScrollViewDelegate,YouliDelegate>
{
    NMRangeSlider *priceSlider;
}

@property(retain,nonatomic) NSString *PhotoURL;
@property(nonatomic,retain) NSMutableArray *items;
@property(retain,nonatomic) NSMutableArray *photoURLItems;
@property(retain,nonatomic) NSArray *constellationArrary;
@property(retain,nonatomic) NSString *giftListTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *giftScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *constellationScrollView;
@property (strong, nonatomic) IBOutlet UIView *constellationSelectView;

@property (strong, nonatomic) IBOutlet UIImageView *imgConstellation;
@property (strong, nonatomic) IBOutlet UIImageView *imgPrice;

@property (strong, nonatomic) IBOutlet UIButton *btnConstellation;
@property (strong, nonatomic) IBOutlet UIButton *btnPrice;

@property (strong, nonatomic) IBOutlet UILabel *lowerPrice;
@property (strong, nonatomic) IBOutlet UILabel *upperPrice;

@property (strong, nonatomic) IBOutlet UILabel *lblGiftTypeTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnReturn;


- (IBAction)showConstellation:(id)sender;
- (IBAction)showPrice:(id)sender;
- (IBAction)returnClick:(id)sender;

@end
