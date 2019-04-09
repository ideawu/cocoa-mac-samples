/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Query data source for the outline view.
 */

#import <Foundation/Foundation.h>

#import "CGDisplayList.h"

@interface CGDisplaysDataSource : NSObject

@property (nonatomic, readonly) NSMutableDictionary* dictionary;
@property (nonatomic, readonly) NSMutableSet*        parent;
@property (nonatomic, readonly) NSMutableSet*        childern;

+ (instancetype) query;

- (BOOL) isChild:(NSString *)string;
- (BOOL) isParent:(NSString *)string;

@end
