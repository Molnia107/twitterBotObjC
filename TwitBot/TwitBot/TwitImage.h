//
//  TwitImage.h
//  TwitBot
//
//  Created by Admin on 5/28/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitTwit.h"
#import <UIKit/UIKit.h>

@interface TwitImage : NSObject

+ (instancetype)sharedInstance;
- (void)downloadImageForTwit:(TwitTwit*)twit withUrl:(NSURL*)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, TwitTwit *twit))completionBlock;

@end
