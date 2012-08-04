//
//  CellviewController.m
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/08/04.
//
//

#import "CellviewController.h"

@implementation CellviewController
@synthesize icon_image;
@synthesize date_str;
@synthesize PostText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
