//
//  AssignBirthdayController.h
//  youli
//
//  Created by ufida on 13-2-4.
//
//

#import <UIKit/UIKit.h>
#import "YouliDelegate.h"
#import "FMDatabaseOper.h"
#import "BirthdayGiftController.h"
#import "BirthdayGiftDetailControllerDelegate.h"

@interface AssignBirthdayController : UIViewController<UIScrollViewDelegate,YouliDelegate>
{
    NMRangeSlider *priceSlider;
    FMDatabaseOper *fmdataOper;
}

@property(retain,nonatomic) NSString *PhotoURL;
@property(nonatomic,retain) NSMutableArray *items;
@property(retain,nonatomic) NSMutableArray *photoURLItems;
@property(retain,nonatomic) NSString *giftListTitle;
@property (retain, nonatomic)UIScrollView *giftScrollView;
@property(retain,nonatomic)UIImageView *imgPrice;

@property (strong, nonatomic)UILabel *lowerPrice;
@property (strong, nonatomic)UILabel *upperPrice;

@property (strong, nonatomic)UILabel *lblGiftTypeTitle;

@property (strong, nonatomic)UIButton *btnReturn;

@property (strong,nonatomic) UIActivityIndicatorView *indicator;                //菊花

@property(strong,nonatomic) BirthdayGiftDetailController *birthdayGiftDetailController;

@property (strong,nonatomic) id<BirthdayGiftDetailControllerDelegate> birthdayGiftDetailControllerDelegate;

@end
