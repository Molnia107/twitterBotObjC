//
//  TwitSearchResult.m
//  TwitBot
//
//  Created by Admin on 5/27/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitSearchResult.h"
#import "TwitTwit.h"

@implementation TwitSearchResult

-(id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.minTwitId = 0;
        NSArray *twitsJsonArray = [dictionary objectForKey:@"statuses"];
        self.tag = [[dictionary objectForKey:@"search_metadata"] objectForKey:@"query"];
        if(twitsJsonArray){
            NSMutableArray *array = [NSMutableArray new];
            for(NSDictionary *twitDictionary in twitsJsonArray){
                TwitTwit *twit = [[TwitTwit alloc]initWithDictionary:twitDictionary];
                if(twit){
                    [array addObject:twit];
                    self.minTwitId = twit.twitId;
                }
            }
            self.twitsArray = [array copy];
        }

    }
    return self;
}

-(void)appendSearchResult:(TwitSearchResult*) searchResult{
    if(searchResult.twitsArray.count > 1 && [self.minTwitId compare: searchResult.minTwitId] == NSOrderedDescending){
        self.minTwitId = searchResult.minTwitId;
        NSRange range = NSMakeRange(1, (searchResult.twitsArray.count -1));
        NSArray *arrayToAppend = [searchResult.twitsArray subarrayWithRange:range];
        self.twitsArray = [self.twitsArray arrayByAddingObjectsFromArray:arrayToAppend];
    }
}

@end
