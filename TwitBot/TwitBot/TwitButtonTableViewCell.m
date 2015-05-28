//
//  TwitButtonTableViewCell.m
//  TwitBot
//
//  Created by Admin on 5/28/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitButtonTableViewCell.h"


@interface TwitButtonTableViewCell()
@property (strong, nonatomic) IBOutlet UIButton *buttonShowMore;
- (IBAction)buttonShowMoreTouchUpInside:(id)sender;
@end

@implementation TwitButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonShowMoreTouchUpInside:(id)sender {
    if(self.showMoreDelegate){
        [self.showMoreDelegate showMoreTwits];
    }
}
@end
