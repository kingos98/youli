//
//  BirthdayGiftDetailControllerDelegate.h
//  youli
//
//  Created by ufida on 12-12-31.
//
//

#import <Foundation/Foundation.h>

@protocol BirthdayGiftDetailControllerDelegate <NSObject>
//-(void)showGiftListByGiftType:(NSInteger) GiftType;
-(void)showGiftListByGiftType:(NSInteger)GiftType IsFromIndexPage:(bool) isFromIndex;
-(void)sendGiftID:(NSInteger) GiftID IsFromIndexPage:(bool) isFromIndex;
@end
