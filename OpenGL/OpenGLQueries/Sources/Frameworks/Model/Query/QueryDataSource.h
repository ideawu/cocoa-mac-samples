/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Query data source for the outline view.
 */

#import <Foundation/Foundation.h>

@interface QueryDataSource : NSObject

@property (nonatomic, readonly) NSMutableArray* data;

+ (instancetype) query;

- (BOOL) isChild:(NSString *)string;
- (BOOL) isParent:(NSString *)string;

@end
