//
//  CellviewController.h
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/08/04.
//
//

#import <UIKit/UIKit.h>

@interface CellviewController : UITableViewCell{
    IBOutlet UILabel* TextLabel;
}
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *date_str;
@property (weak, nonatomic) IBOutlet UILabel *PostText;


@end
