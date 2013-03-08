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

@interface BirthdayGiftDetailController : BaseController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, BirthdayGiftDetailControllerDelegate>

-(void)sendGiftID:(NSInteger)GiftID;
@end
