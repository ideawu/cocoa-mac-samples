

#import <Cocoa/Cocoa.h>

@class Scene;

@interface MyOpenGLView : NSOpenGLView
{
    // Model
    Scene *scene;

    // Controller
    IBOutlet NSResponder *controller;
}
- (Scene *)scene;

- (float)cameraDistance;
- (void)setCameraDistance:(float)newCameraDistance;

- (float)rollAngle;
- (void)setRollAngle:(float)newRollAngle;

- (float)sunAngle;
- (void)setSunAngle:(float)newSunAngle;
@end
