
#import "MainController.h"
#import "MyOpenGLView.h"
#import "Scene.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGL/OpenGL.h>

@interface MainController (RotationMethods)
- (BOOL)isRotating;
- (void)startRotation;
- (void)stopRotation;
- (void)toggleRotation;

- (void)startRotationTimer;
- (void)stopRotationTimer;
- (void)rotationTimerFired:(NSTimer *)timer;
@end

@implementation MainController

- (void) awakeFromNib {
    // Make the OpenGL View layer-backed.
    [openGLView setWantsLayer:YES];
	
    // Show the control box.
    [self toggleControlBox];
	
    // Start the Earth rotating.
    [self startRotation];
}

- (void)toggleControlBox {
    if ([controlBox superview] != openGLView) {
        // Determine desired start and end positions for animating the controlBox into view.
        NSRect bounds = [openGLView bounds];
        NSPoint endOrigin = NSMakePoint(0.5 * (NSWidth(bounds) - NSWidth([controlBox frame])), 24.0);
        NSPoint startOrigin = NSMakePoint(endOrigin.x, -NSHeight([controlBox frame]));

        // Position the controlBox outside the openGLView's bounds, and make it initially fully transparent.
		[openGLView addSubview:controlBox];
        [controlBox setFrameOrigin:startOrigin];
        [controlBox setAlphaValue:0.0];

        // Now animate the controlBox into view and simultaneously fade it in.
        [NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setCompletionHandler:^{
			NSLog(@"");
		}];
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[controlBox animator] setAlphaValue:1.0];
        [[controlBox animator] setFrameOrigin:endOrigin];
        [NSAnimationContext endGrouping];
    }
    else { //if ([controlBox superview] == openGLView)
        // Remove the controlBox from the view tree.
        [controlBox removeFromSuperview];
    }
}

#pragma mark *** Property Accessors ***

- (BOOL)isFiltered {
    return filter != nil;
}

- (void)setFiltered:(BOOL)flag {
    if (flag != [self isFiltered]) {
        if (flag) {
            // Instantiate a Core Image "Glass Distortion" filter.
            filter = [CIFilter filterWithName:@"CIGlassDistortion"];
            [filter setDefaults];
            CIImage *glassImage = [CIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"smoothtexture"]]];
            [filter setValue:glassImage forKey:@"inputTexture"];

            // Apply the glass distortion to filter the openGLView content that's rendered behind the controlBox.
            [[controlBox animator] setBackgroundFilters:[NSArray arrayWithObject:filter]];
        } else {
            // Remove the filter and discard our pointer to it.
            [[controlBox animator] setBackgroundFilters:nil];
            filter = nil;
        }
    }
}

#pragma mark *** Event Handling ***

- (void)keyDown:(NSEvent *)event {
    Scene *scene = [openGLView scene];
    unichar c = [[event charactersIgnoringModifiers] characterAtIndex:0];
    switch (c) {

        // [space] toggles rotation of the globe.
        case 32:
            [self toggleRotation];
            break;

        // [W] toggles wireframe rendering
        case 'w':
        case 'W':
            [scene toggleWireframe];
            [openGLView setNeedsDisplay:YES];
            break;
        
        // [C] toggle displaying the control box
        case 'c':
        case 'C':
            [self toggleControlBox];
            break;

        default:
            break;
    }
}

// Holding the mouse button and dragging the mouse changes the "roll" angle (y-axis) and the direction from which sunlight is coming (x-axis).
- (void)mouseDown:(NSEvent *)theEvent {
    Scene *scene = [openGLView scene];
    BOOL wasAnimating = [self isRotating];
    BOOL dragging = YES;
    NSPoint windowPoint;
    NSPoint lastWindowPoint = [theEvent locationInWindow];
    float dx, dy;

    if (wasAnimating) {
        [self stopRotation];
    }
    while (dragging) {
        theEvent = [[openGLView window] nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask];
        windowPoint = [theEvent locationInWindow];
        switch ([theEvent type]) {
            case NSLeftMouseUp:
                dragging = NO;
                break;

            case NSLeftMouseDragged:
                dx = windowPoint.x - lastWindowPoint.x;
                dy = windowPoint.y - lastWindowPoint.y;
                [scene setSunAngle:[scene sunAngle] - 1.0 * dx];
                [scene setRollAngle:[scene rollAngle] - 0.5 * dy];
                lastWindowPoint = windowPoint;

                // Render a frame.
                [openGLView setNeedsDisplay:YES];
                break;

            default:
                break;
        }
    }
    if (wasAnimating) {
        [self startRotation];
        timeBefore = CFAbsoluteTimeGetCurrent();
    }
}

@end

@implementation MainController (RotationMethods)

- (BOOL)isRotating {
    return isRotating;
}

- (void)startRotation {
    if (!isRotating) {
        isRotating = YES;
        [self startRotationTimer];
    }
}

- (void)stopRotation {
    if (isRotating) {
        if (rotationTimer != nil) {
            [self stopRotationTimer];
        }
        isRotating = NO;
    }
}

- (void)toggleRotation {
    if ([self isRotating]) {
        [self stopRotation];
    } else {
        [self startRotation];
    }
}

- (void)startRotationTimer {
    if (rotationTimer == nil) {
        rotationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector:@selector(rotationTimerFired:) userInfo:nil repeats:YES] retain];
    }
}

- (void)stopRotationTimer {
    if (rotationTimer != nil) {
        [rotationTimer invalidate];
        [rotationTimer release];
        rotationTimer = nil;
    }
}

- (void)rotationTimerFired:(NSTimer *)timer {
    Scene *scene = [openGLView scene];
    [scene advanceTimeBy:0.017];
    [openGLView setNeedsDisplay:YES];
}

@end
