//
//  BirthdayGiftDetailItem.h
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface BirthdayGiftDetailItem : UIView
{
    sqlite3 *db;
}

@property(retain,nonatomic)UILabel *lblTitle;
@property(retain,nonatomic)UIImageView *imgPhoto;
@property(retain,nonatomic)UILabel *lblDetail;
@property(retain,nonatomic)UILabel *lblPrice;
@property(retain,nonatomic)UIButton *btnBuy;

@end
