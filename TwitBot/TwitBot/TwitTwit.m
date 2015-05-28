//
//  TwitTwit.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitTwit.h"
#import "TwitUser.h"

@implementation TwitTwit

-(id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.text = [dictionary valueForKey:@"text"];
        NSDictionary *userDictionary = [dictionary valueForKey:@"user"];
        TwitUser *user = [[TwitUser alloc] initWithDictionary:userDictionary];
        
        self.twitId = [dictionary valueForKey:@"id"];
        
        NSString *dateString =[dictionary valueForKey:@"created_at"];
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        [dateFormater setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
        self.twitDate = [dateFormater dateFromString:dateString];
       
        self.user = user;
    }
    return self;
}

@end
