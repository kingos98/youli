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

@protocol BirthdayGiftDetailDelegate <NSObject>
-(void)showGiftInWebview:(NSString *)webaddress;
@end

@interface BirthdayGiftDetailController : BaseController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, BirthdayGiftDetailControllerDelegate,BirthdayGiftDetailDelegate>

-(void)sendGiftID:(NSInteger)GiftID;
@end
