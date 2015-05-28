//
//  TwitSearchResult.h
//  TwitBot
//
//  Created by Admin on 5/27/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitSearchResult : NSObject

-(id)initWithDictionary:(NSDictionary*) dictionary;
-(void)appendSearchResult:(TwitSearchResult*) searchResult;

@property (strong, nonatomic) NSArray *twitsArray;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSNumber *minTwitId;

@end
