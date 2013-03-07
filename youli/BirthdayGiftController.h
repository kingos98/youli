//
//  BirthdayGiftControllerNew.h
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "YouliDelegate.h"
#import "BaseController.h"
#import "sqlite3.h"
#import "BirthdayGiftDetailController.h"
#import "BirthdayGiftDetailControllerDelegate.h"
#import "CategoryTableView.h"

@interface BirthdayGiftController : BaseController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,YouliDelegate>

@property(retain,nonatomic) NSString *PhotoURL;
@property(nonatomic,retain) NSMutableArray *items;
@property(retain,nonatomic) NSMutableArray *photoURLItems;
@property(retain,nonatomic) NSArray *constellationArrary;
@property(retain,nonatomic) NSString *giftListTitle;

@property (retain, nonatomic)UIScrollView *giftScrollView;
@property (strong, nonatomic)UIScrollView *constellationScrollView;
@property (strong, nonatomic)UIView *constellationSelectView;

@property (strong, nonatomic)UIImageView *imgConstellation;
@property (strong, nonatomic)UIImageView *imgPrice;

@property (strong, nonatomic)UIButton *btnConstellation;
@property (strong, nonatomic)UIButton *btnPrice;

@property (strong, nonatomic)UILabel *lowerPrice;
@property (strong, nonatomic)UILabel *upperPrice;

@property (strong, nonatomic)UILabel *lblGiftTypeTitle;

@property (strong, nonatomic)UIButton *btnReturn;

@property (strong,nonatomic) UIActivityIndicatorView *indicator;                //菊花

@property(strong,nonatomic) BirthdayGiftDetailController *birthdayGiftDetailController;

@property (strong,nonatomic) id<BirthdayGiftDetailControllerDelegate> birthdayGiftDetailControllerDelegate;


-(void)AddPhotoInfoToDB:(NSInteger)PhotoID tmpPhotoTitle:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL
;

@end
