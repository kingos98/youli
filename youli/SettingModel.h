//
//  SettingModel.h
//  youli
//
//  Created by ufida on 13-3-19.
//
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSArray *keyItems;
@property(nonatomic,strong) NSString *menuGroup;
@property(nonatomic,strong) NSString *menuName;

- (void)loadData;
@end
