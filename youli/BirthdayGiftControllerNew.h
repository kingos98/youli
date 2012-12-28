//
//  BirthdayGiftControllerNew.h
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import "BirthdayGiftControllerItem.h"
#import "NMRangeSlider.h"
#import "YouliDelegate.h"
#import "BaseController.h"
#import "sqlite3.h"
#import "DatabaseOper.h"
@interface BirthdayGiftControllerNew : BaseController<UIScrollViewDelegate,YouliDelegate>
{
    NMRangeSlider *priceSlider;
    DatabaseOper *databaseOper;
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

@property (strong,nonatomic) UIActivityIndicatorView *indicator;                //菊花

@property sqlite3 *db;

-(void)AddPhotoInfoToDB:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL;

@end
