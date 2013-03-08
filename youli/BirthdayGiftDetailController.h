//
//  BirthdayGiftDetail.h
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "BirthdayGiftDetailControllerDelegate.h"

@interface BirthdayGiftDetailController : BaseController<UIScrollViewDelegate,BirthdayGiftDetailControllerDelegate>
{
   
}

-(id)initwithGiftID:(NSInteger)GiftID;

@property(retain,nonatomic) UIScrollView *giftDetailScrollView;
@property(retain,nonatomic) UIButton *btnReturn;
@property(retain,nonatomic) UIButton *btnShare;
@property (strong, nonatomic)UILabel *lblGiftTypeTitle;

@end
