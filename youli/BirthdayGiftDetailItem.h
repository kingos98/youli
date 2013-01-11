//
//  BirthdayGiftDetailItem.h
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseOper.h"

@interface BirthdayGiftDetailItem : UIView
{
    DatabaseOper *dataOper;
    
    UIImageView *imgBg;
    UILabel *lblTitle;
    UIImageView *imgPhoto;
    UILabel *lblDetail;
    UILabel *lblMoneySymbol;
    UILabel *lblPrice;
    UIButton *btnCollect;        //收藏
    UIButton *btnBuy;
}

@property(retain,nonatomic)NSString *taobaoURL;
@property(retain,nonatomic)NSArray *arrGiftDetail;

-(id)initWithPhotoID:(NSInteger)GiftID;
-(id)initWithGiftInfo:(NSString *)GiftID GiftTitle:(NSString *)GiftTitle GiftDetail:(NSString *)GiftDetail ImageURL:(NSString *)ImageURL TaobaoURL:(NSString *)TaobaoURL Price:(NSString *) Price;

@end
