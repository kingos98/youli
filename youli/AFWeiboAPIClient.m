//
//  AFWeiboAPIClient.m
//  youli
//
//  Created by sjun on 3/6/13.
//
//

#import "AFWeiboAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFWeiboAPIBaseURLString = @"https://open.weibo.cn/2/";

@implementation AFWeiboAPIClient

+ (AFWeiboAPIClient *)getInstance{
    static AFWeiboAPIClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AFWeiboAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFWeiboAPIBaseURLString]];
    });
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
