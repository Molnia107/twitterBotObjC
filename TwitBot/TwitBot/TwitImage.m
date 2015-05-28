//
//  TwitImage.m
//  TwitBot
//
//  Created by Admin on 5/28/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitImage.h"

@implementation TwitImage

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)downloadImageForTwit:(TwitTwit*)twit withUrl:(NSURL*)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, TwitTwit *twit))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
           if (error){
               completionBlock(NO,nil,twit);
           }
           else{
               UIImage *image = [[UIImage alloc] initWithData:data];
               completionBlock(YES,image,twit);
           }
       }];
}

@end
