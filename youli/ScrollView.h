//
//  ScrollView.h
//  youli
//
//  Created by ufida on 13-3-25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ScrollDelegate <NSObject>
-(void) scrollTouchBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view;
-(void) scrollTouchEnd:(UIView *)view;
-(void) scrollTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface ScrollView : UIScrollView<UIScrollViewDelegate> {
	id<ScrollDelegate> scrollDelegate;
}
@property (nonatomic,strong) id<ScrollDelegate> scrollDelegate;
@end