//
//  IZValueSelectorView.h
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IZValueSelectorView;

@protocol IZValueSelectorViewDelegate <NSObject>
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index;
@end

@protocol IZValueSelectorViewDataSource <NSObject>
- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector;
@end

@interface IZValueSelectorView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDataSource> dataSource;
@property (nonatomic,strong) NSArray *values;
@property (nonatomic,assign) BOOL shouldBeTransparent;
@property (nonatomic,assign) BOOL horizontalScrolling;
@property (nonatomic,assign) BOOL debugEnabled;

- (void)reloadData;

@end
