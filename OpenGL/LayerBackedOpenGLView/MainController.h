

#import <Cocoa/Cocoa.h>

@class CIFilter;
@class MyOpenGLView;

@interface MainController : NSResponder
{
    // Model
    BOOL layerBacked;
    CIFilter *filter;
    BOOL isRotating;
    NSTimer *rotationTimer;
    CFAbsoluteTime timeBefore;

    // Views
    IBOutlet MyOpenGLView *openGLView;
    IBOutlet NSBox *controlBox;
}

- (BOOL)isFiltered;
- (void)setFiltered:(BOOL)flag;

@end
