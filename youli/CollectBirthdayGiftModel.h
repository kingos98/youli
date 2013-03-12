//
//  CollectBirthdayGiftModel.h
//  youli
//
//  Created by ufida on 13-3-11.
//
//

#import <Foundation/Foundation.h>

@interface CollectBirthdayGiftModel : NSObject

@property NSInteger giftid;
@property NSInteger gifttype;


+(CollectBirthdayGiftModel *)getInstance;
+(Boolean)checkIsCollect:(NSInteger)GiftID;
+(void)operGiftToCollection:(Boolean)IsAdd GiftID:(NSInteger)GiftID;
@end
