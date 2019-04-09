#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface Texture : NSObject {
	
	GLuint texId;
	GLuint pboId;
	GLubyte	*data;
    GLsizei width, height;
}

- (id) initWithPath:(NSString*)path;
- (GLuint) textureName;

@end
