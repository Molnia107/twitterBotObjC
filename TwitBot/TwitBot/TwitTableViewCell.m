//
//  TwitTableViewCell.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitTableViewCell.h"
#import "TwitImage.h"

@interface TwitTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong, nonatomic) TwitTwit *twit;
@end

@implementation TwitTableViewCell

- (void)awakeFromNib {
    CALayer * layer = self.userImageView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithTwit:(TwitTwit*)twit{
    self.twit = twit;
    self.userNameLabel.text = twit.user.name;
    self.twitTextLabel.text = twit.text;
    NSURL *url = [[NSURL alloc]initWithString:twit.user.imageUrl];
    TwitImage *twitIamge = [TwitImage sharedInstance];
    [twitIamge downloadImageForTwit:twit withUrl:url completionBlock:^(BOOL succeeded, UIImage *image, TwitTwit *twit) {
        if(succeeded && twit == self.twit){
            self.userImageView.image = image;
        }
    }];
}



@end
