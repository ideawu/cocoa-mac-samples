/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class for generating a mutable attributed string from a c-string and the associated properties.
 */

#import <Cocoa/Cocoa.h>

@interface Text : NSObject

// Input string
@property (nonatomic, readonly) NSString* string;

// String length
@property (nonatomic, readonly)  NSUInteger length;

// Output attributed string with set properties.
@property (nonatomic, readonly)  NSMutableAttributedString* text;

// Paragraph spacing, where the default value is set to 1.0
@property (nonatomic, readwrite) CGFloat paragraphSpacing;

// Line spacing, where the default value is set to 1.0
@property (nonatomic, readwrite) CGFloat lineSpacing;

// Line break mode where the default is set to break the line by word wrapping
@property (nonatomic, readwrite) NSLineBreakMode lineBreakMode;

// Line justification, where the default is assumed to be a left justified line
@property (nonatomic, readwrite) NSTextAlignment alignment;

// Font size, where the default size is set to 12.0 pt.
@property (nonatomic, readwrite) CGFloat fontSize;

// Font name, where the default is set to be Helvetica
@property (nonatomic, readwrite, retain) NSString* fontName;

// String range, such that the defsult is set to be the string length.
@property (nonatomic, readwrite) NSRange range;

// Foreground color range where the default is set to  be the string length.
@property (nonatomic, readwrite) NSRange colorRange;

// Foreground color, where the default color is set to be black
@property (nonatomic, readwrite, retain) NSColor* color;

// Create a new attributed text object with a valid string
- (instancetype) initWithString:(NSString *)string;

// Create a new attributed text object with a valid c-string
- (instancetype) initWithCString:(const char *)string;

// Instance of the attributed text object with a valid string
+ (instancetype) textWithString:(NSString *)string;

// Instance of the attributed text object with a valid c-string
+ (instancetype) textWithCString:(const char *)string;

@end
