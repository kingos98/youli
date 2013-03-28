//
//  SettingCell.h
//  youli
//
//  Created by ufida on 13-3-19.
//
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"

@interface SettingCell : UITableViewCell

@property(nonatomic,strong)SettingModel *settingModel;

@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UIImageView *imgArrow;
@property(nonatomic,strong)UIButton *btnCleanCache;

- (id)initCell:(NSString *)reuseIdentifier;


@end
