//
//  BirthdayGiftDetailItem.h
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface BirthdayGiftDetailItem : UIViewController
{
    sqlite3 *db;
}


@property(retain,nonatomic) IBOutlet UILabel *lblTitle;
@property(retain,nonatomic) IBOutlet UIImageView *imgPhoto;
@property(retain,nonatomic) IBOutlet UILabel *lblDetail;
@property(retain,nonatomic) IBOutlet UILabel *lblPrice;
@property(retain,nonatomic) IBOutlet UIButton *btnBuy;

@end
