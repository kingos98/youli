//
//  ConstellationUtils.m
//  youli
//
//  Created by sjun on 2/17/13.
//
//

#import "ConstellationUtils.h"

@implementation ConstellationUtils

NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
NSString *astroFormat = @"102123444543";

+(NSString *)getAstroWithMonth:(NSInteger)month andDay:(NSInteger)day {
    NSString *result;
    if (month < 1||month > 12||day < 1||day > 31)
    {
        return @"错误日期格式!";
    }
    
    if (month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30)
        {
            return @"错误日期格式!!!";
        }
    }
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

@end
