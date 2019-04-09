
#import "MouseIgnoringBox.h"

@implementation MouseIgnoringBox

// Override -mouseDown:, -mouseDragged:, and -mouseUp: to consume left mouse button events instead of passing them up the responder chain, since otherwise clicking and dragging in the box area manipulates the globe, which feels a little weird.
- (void)mouseDown:(NSEvent *)theEvent {
}

- (void)mouseDragged:(NSEvent *)theEvent {
}

- (void)mouseUp:(NSEvent *)theEvent {
}

@end
