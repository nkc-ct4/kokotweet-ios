//
//  TweetTableViewCell.h
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/07/27.
//
//

#import <UIKit/UIKit.h>
#import "JMImageCache.h"

@interface TweetTableViewCell : UITableViewCell<JMImageCacheDelegate>
@property (weak, nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
