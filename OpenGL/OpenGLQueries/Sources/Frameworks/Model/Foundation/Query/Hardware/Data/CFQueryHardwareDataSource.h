/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Query data source for hardware property queries.
 */

#import <Foundation/Foundation.h>

#import "CFQueryHardware.h"

@interface CFQueryHardwareDataSource : NSObject

@property (nonatomic, readonly) NSMutableDictionary*  dictionary;
@property (nonatomic, readonly) NSMutableSet*         parent;
@property (nonatomic, readonly) NSMutableSet*         childern;

+ (instancetype) query;

- (BOOL) isChild:(NSString *)string;
- (BOOL) isParent:(NSString *)string;

@end
