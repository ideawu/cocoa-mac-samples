/*
     File: MyApplication.m 
 Abstract: The sample's NSApplication subclass for overriding reportException. 
  Version: 1.1 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2013 Apple Inc. All Rights Reserved. 
  
 */

#import "MyApplication.h"
#import "MyExceptionAlertController.h"

@implementation MyApplication

static void CrashMyApplication() {
    *(char *)0x08 = 1;
}

- (NSAttributedString *)_formattedExceptionBacktrace:(NSArray *)backtrace {
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    for (__strong NSString *s in backtrace) {
        s = [s stringByAppendingString:@"\n"];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:s];
        [result appendAttributedString:attrS];
    }
    [result addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Monaco" size:10] range:NSMakeRange(0, result.length)];
    return result;    
}

- (void)reportException:(NSException *)exception {
    
    // NSApplication simply logs the exception to the console. We want to let the user know
    // when it happens in order to possibly prevent subsequent random crashes that are difficult to debug
    //
    @try {
        @autoreleasepool {
        // Create a string based on the exception
            NSString *exceptionMessage = [NSString stringWithFormat:@"%@\nReason: %@\nUser Info: %@", [exception name], [exception reason], [exception userInfo]];
            // Always log to console for history
            NSLog(@"Exception raised:\n%@", exceptionMessage);
            NSLog(@"Backtrace: %@", [exception callStackSymbols]);
            
            MyExceptionAlertController *alertController = [[MyExceptionAlertController alloc] init];
            alertController.exceptionMessage = exceptionMessage;
            alertController.exceptionBacktrace = [self _formattedExceptionBacktrace:[exception callStackSymbols]];

            NSInteger result = [alertController runModal];
            if (result == MyModalResultCrash) {
                CrashMyApplication();
            }
        
        }
    } @catch (NSException *e) {
        // Suppress any exceptions raised in the handling
    }    
}

@end
