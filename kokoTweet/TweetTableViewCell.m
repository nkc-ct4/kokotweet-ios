//
//  TweetTableViewCell.m
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/07/27.
//
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell
@synthesize imageURL = _imageURL;
@synthesize imageView = _imageView;

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

- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSString *)url {
	NSLog(@"didDownloadImage for URL = %@", url);
    
	if([url isEqualToString:self.imageURL]) {
		self.imageView.image = i;
        
		[self setNeedsLayout];
	}
}


@end
