//
//  BirthdayGift.h
//  youli
//
//  Created by ufida on 13-3-11.
//
//

#import <Foundation/Foundation.h>

@interface BirthdayGiftModel : NSObject

@property NSInteger giftid;
@property NSInteger gifttype;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *imageurl;
@property (nonatomic,strong) NSString *taobaourl;
@property NSInteger price;

+ (BirthdayGiftModel *)getInstance;
-(void)AddPhotoInfoToDB:(NSInteger)PhotoID tmpPhotoTitle:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL Price:(NSInteger)GiftPrice TaobaoUrl:(NSString *)TaobaoUrl IsFromIndexPage:(bool) isFromIndex;
- (BirthdayGiftModel *)getGiftDetail:(NSInteger) GiftID IsFromIndexPage:(bool) isFromIndex;
- (void)cleanGiftList:(bool) isFromIndex;
- (NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType IsFromIndexPage:(bool) isFromIndex;
- (NSInteger)getSelectedGiftIndex:(NSInteger)GiftID IsFromIndexPage:(bool) isFromIndex;

@end
