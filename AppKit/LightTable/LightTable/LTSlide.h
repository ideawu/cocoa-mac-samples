/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  This is the completion of the slide entity from our Core Data model. We needed to create a class in order for our entity to return CGRect data. We accomplish this by using the methods in "Core Data Programming Guide: Non-Standard Persistent Attributes" 
*/

@import Cocoa;
@import CoreData;

@interface LTSlide : NSManagedObject {
   
}

@property(assign, nonatomic) CGRect frame;
@property(assign, nonatomic) CGRect photoFrame;

@end
