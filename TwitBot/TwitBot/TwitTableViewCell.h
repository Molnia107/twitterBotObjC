//
//  TwitTableViewCell.h
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitTwit.h"

@interface TwitTableViewCell : UITableViewCell

- (void)updateWithTwit:(TwitTwit*)twit;

@end
