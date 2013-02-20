//
//  YouliConfig.m
//  youli
//
//  Created by ufida on 13-2-19.
//
//

#import "YouliConfig.h"

static NSInteger ScreenWidth;
static NSInteger ScreenHeight;

@implementation YouliConfig

+(void)setScreenWidthHeight:(NSInteger) iWidth:(NSInteger) iHeight
{
    ScreenWidth=iWidth;
    ScreenHeight=iHeight;
}

+(NSInteger)getScreenWidth
{
    return ScreenWidth;
}

+(NSInteger)getScreenHeight
{
    return ScreenHeight;
}
@end
