/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 OpenGL Query View application delegate.
 */

#import "AppDelegate.h"

@implementation AppDelegate
{
@private
    IBOutlet NSOutlineView* mpOutlineView;
    
    id<NSOutlineViewDataSource>  _dataSource;
    id<NSOutlineViewDelegate>    _delegate;
    
    OutlineViewController*  mpOutlineViewController;
}

- (id) init
{
    self = [super init];
    
    if(self)
    {
        mpOutlineViewController = [OutlineViewController new];

        if(mpOutlineViewController)
        {
            _dataSource = mpOutlineViewController;
            _delegate   = mpOutlineViewController;
        } // if
    } // if
    
    return self;
} // init

- (void) dealloc
{
    [super dealloc];
    
    if(mpOutlineViewController)
    {
        [mpOutlineViewController release];
    } // if
} // dealloc

- (void) awakeFromNib
{
    mpOutlineView.dataSource = _dataSource;
    mpOutlineView.delegate   = _delegate;
} // awakeFromNib

- (IBAction) print:(id)sender
{
    NSPrintInfo *pSharedInfo = [NSPrintInfo sharedPrintInfo];
    
    if(pSharedInfo)
    {
        NSMutableDictionary *pSharedDict = [pSharedInfo dictionary];
        
        if(pSharedDict)
        {
            NSMutableDictionary *pPrintInfoDict = [NSMutableDictionary dictionaryWithDictionary:pSharedDict];
            
            if(pPrintInfoDict)
            {
                NSPrintInfo *pPrintInfo = [[NSPrintInfo alloc] initWithDictionary:pPrintInfoDict];
                
                if(pPrintInfo)
                {
                    [pPrintInfo setTopMargin:0.0];
                    [pPrintInfo setBottomMargin:0.0];
                    [pPrintInfo setLeftMargin:0.0];
                    [pPrintInfo setRightMargin:0.0];
                    [pPrintInfo setHorizontalPagination:NSFitPagination];
                    [pPrintInfo setVerticalPagination:NSAutoPagination];
                    [pPrintInfo setVerticallyCentered:YES];
                    
                    NSPrintOperation *pPrintOp = [NSPrintOperation printOperationWithView:mpOutlineView
                                                                                printInfo:pPrintInfo];
                    
                    if(pPrintOp)
                    {
                        [pPrintOp setShowsPrintPanel:YES];
                        [pPrintOp setCanSpawnSeparateThread:YES];
                        
                        [pPrintOp runOperation];
                    } // if
                    
                    [pPrintInfo release];
                } // if
            } // if
        } // if
    } // if
} // print

@end
