//
//  TwitTableViewCell.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitTableViewCell.h"

@interface TwitTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation TwitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithTwit:(TwitTwit*)twit{
    self.userNameLabel.text = twit.user.name;
    self.twitTextLabel.text = twit.text;
}

@end
