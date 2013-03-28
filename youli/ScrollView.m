//
//  ScrollView.m
//  youli
//
//  Created by ufida on 13-3-25.
//
//

#import "ScrollView.h"


@implementation ScrollView

@synthesize scrollDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.scrollEnabled = YES;
		self.userInteractionEnabled = YES;
		self.alwaysBounceVertical = YES;
		self.backgroundColor = [UIColor clearColor];
		super.delegate = self;
		//NO 发送滚动的通知 但是就算手指移动 scroll也不会动了 YES 发送通知 scroo可以移动
		//[self setCanCancelContentTouches:YES];
		//[self setBounces:NO];
		// NO 立即通知touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
		//[self setDelaysContentTouches:NO];
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
	[scrollDelegate scrollTouchBegin:touches withEvent:event inContentView:view];
    //NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
    //返回yes 是不滚动 scroll 返回no 是滚动scroll
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
	
	[scrollDelegate scrollTouchEnd:view];
    //NSLog(@"用户点击的视图 %@",view);
	
    //NO scroll不可以滚动 YES scroll可以滚动
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[scrollDelegate scrollTouchEnded:touches withEvent:event];
}

#pragma mark UIScrollViewDelegate methods
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	
}

#pragma mark UIScrollViewDelegate end;

@end

