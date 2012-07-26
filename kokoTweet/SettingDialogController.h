//
//  SettingDialogController.h
//  kokoTweetSetting
//
//  Created by zuzu on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QuickDialogController.h"

@interface SettingDialogController : QuickDialogController{
    __strong id delegate;
}
+ (QRootElement *)createDetailsForm:(NSMutableArray *)accountNameArray;
-(void) modalViewWillClose;
@property (nonatomic,retain) id delegate;

@end
