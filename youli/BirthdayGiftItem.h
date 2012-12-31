//
//  BirthdayGiftControllerItem.h
//  gift
//
//  Created by ufida on 12-12-10.
//  Copyright (c) 2012年 ufida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirthdayGiftItem : UIView
{
    UIImageView *imgBackground;
    UIImageView *imgGiftPhoto;
    UILabel *lblMoneySymbol;
    UILabel *lblGiftPrice;
    UILabel *lblGiftTitle;
}

@property(nonatomic,retain) NSMutableArray *items;
@property(retain,nonatomic) NSMutableArray *photoURLItems;
@property(retain,nonatomic) UIViewController *RootViewController;

-(id)initWithUrl:(NSString *)PhotoURL GiftTitle:(NSString *)GiftTitle;


@end
