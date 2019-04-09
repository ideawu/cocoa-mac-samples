/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Query data source for the outline view.
 */

#import "CFQueryHardwareDataSource.h"
#import "CGDisplaysDataSource.h"
#import "GLUQueryDataSource.h"
#import "QueryDataSource.h"

@implementation QueryDataSource
{
@private
    NSMutableArray*  _data;
    NSMutableSet*    mpParent;
    NSMutableSet*    mpChildern;
}

- (void) _addRenderers
{
    GLUQueryDataSource* pSource = [GLUQueryDataSource query];
    
    if(pSource)
    {
        [_data addObject:pSource.dictionary];
        
        [mpParent   unionSet:pSource.parent];
        [mpChildern unionSet:pSource.childern];
    } // if
} // _addRenderers

- (void) _addHardware
{
    CFQueryHardwareDataSource* pSource = [CFQueryHardwareDataSource query];
    
    if(pSource)
    {
        [_data addObject:pSource.dictionary];
        
        [mpParent   unionSet:pSource.parent];
        [mpChildern unionSet:pSource.childern];
    } // if
} // _addHardware

- (void) _addDisplays
{
    CGDisplaysDataSource* pSource = [CGDisplaysDataSource query];
    
    if(pSource)
    {
        [_data addObject:pSource.dictionary];
        
        [mpParent   unionSet:pSource.parent];
        [mpChildern unionSet:pSource.childern];
    } // if
} // _addHardware

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        _data = [NSMutableArray new];
        
        if(_data)
        {
            mpParent   = [NSMutableSet new];
            mpChildern = [NSMutableSet new];
            
            [self _addHardware];
            [self _addDisplays];
            [self _addRenderers];
        } // if
    } // if
    
    return self;
} // init

+ (instancetype) query
{
	return [[[QueryDataSource allocWithZone:[self zone]] init] autorelease];
} // query

- (void) dealloc
{
    if(mpParent)
    {
        [mpParent release];
        
        mpParent = nil;
    } // if
    
    if(mpChildern)
    {
        [mpChildern release];
        
        mpChildern = nil;
    } // if
    
    if(_data)
    {
        [_data release];
        
        _data = nil;
    } // if
    
    [super dealloc];
} // dealloc

- (NSMutableArray *) data
{
    return _data;
} // data

- (BOOL) isChild:(NSString *)string
{
    BOOL bSuccess = string != nil;
    
    if(bSuccess)
    {
        bSuccess = [mpChildern containsObject:string];
    } // if
    
    return bSuccess;
} // isChild

- (BOOL) isParent:(NSString *)string
{
    BOOL bSuccess = string != nil;
    
    if(bSuccess)
    {
        bSuccess = [mpParent containsObject:string];
    } // if
    
    return bSuccess;
} // isParent

@end
