//
//  TweetDetailViewController.h
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/07/26.
//
//

#import <UIKit/UIKit.h>
#import "JMImageCache.h"


@interface TweetDetailViewController : UIViewController{
    NSDictionary *array;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (strong,nonatomic) NSDictionary *array;

@end
