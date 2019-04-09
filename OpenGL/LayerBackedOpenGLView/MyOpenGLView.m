

#import "MyOpenGLView.h"
#import "Scene.h"

@implementation MyOpenGLView

- initWithFrame:(NSRect)frameRect {
    NSOpenGLPixelFormatAttribute attrs[] = {

        // Specifying "NoRecovery" gives us a context that cannot fall back to the software renderer.  This makes the View-based context a compatible with the layer-backed context, enabling us to use the "shareContext" feature to share textures, display lists, and other OpenGL objects between the two.
        NSOpenGLPFANoRecovery, // Enable automatic use of OpenGL "share" contexts.

        NSOpenGLPFAColorSize, 24,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFADepthSize, 16,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAccelerated,
        0
    };
    // Create our pixel format.
    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    if (self) {
        scene = [[Scene alloc] init];
    }
    [pixelFormat release];
	[self setWantsBestResolutionOpenGLSurface:YES];
    return self;
}

- (void)dealloc {
    [scene release];
    [super dealloc];
}

- (Scene *)scene {
    return scene;
}

- (float)cameraDistance {
    return [scene cameraDistance];
}

- (void)setCameraDistance:(float)newCameraDistance {
    [scene setCameraDistance:newCameraDistance];
    [self setNeedsDisplay:YES];
}

- (float)rollAngle {
    return [scene rollAngle];
}

- (void)setRollAngle:(float)newRollAngle {
    [scene setRollAngle:newRollAngle];
    [self setNeedsDisplay:YES];
}

- (float)sunAngle {
    return [scene sunAngle];
}

- (void)setSunAngle:(float)newSunAngle {
    [scene setSunAngle:newSunAngle];
    [self setNeedsDisplay:YES];
}

- (BOOL)wireframe {
    return [scene wireframe];
}

- (void)setWireframe:(BOOL)flag {
    [scene setWireframe:flag];
    [self setNeedsDisplay:YES];
}

// AppKit automatically invokes the NSOpenGLView's -prepareOpenGL once when a new NSOpenGLContext becomes current.
- (void)prepareOpenGL {
    [scene prepareOpenGL];
}

- (void)drawRect:(NSRect)aRect {
    // Clear the framebuffer.
    glClearColor( 0.0, 0.0, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

    // Delegate to our scene object for the remainder of the frame rendering.
    [scene render];
    [[self openGLContext] flushBuffer];
}

- (void)reshape {
    // Delegate to our scene object to update for a change in the view size.
//	NSRect pixelBounds = [self convertRectToBase:[self bounds]];
	NSRect pixelBounds = [self convertRectToBacking:[self bounds]];
	NSLog(@"%f", pixelBounds.size.width);
    [scene setViewportRect:NSMakeRect(0, 0, pixelBounds.size.width, pixelBounds.size.height)];
}

- (BOOL)acceptsFirstResponder {
    // We want this view to be able to receive key events.
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    // Delegate to our controller object for handling key events.
    [controller keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent {
    // Delegate to our controller object for handling mouse events.
    [controller mouseDown:theEvent];
}

@end
