//
//  YouliDelegate.h
//  youli
//
//  Created by ufida on 12-12-19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YouliDelegate <NSObject>
-(void)sendGiftTypeTitle:(NSString *) GiftTypeTitle IsFromIndexPage:(BOOL) isFromIndexPage;
-(void)sendGiftTagTitle:(NSString *) TagTitle;
-(void)changeGiftListByType:(int) GiftType;
@end

