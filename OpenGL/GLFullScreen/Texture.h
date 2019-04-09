

#import <Cocoa/Cocoa.h>

@interface Texture : NSObject {
	
	GLuint texId;
	GLuint pboId;
	GLubyte	*data;
}

- (id) initWithPath:(NSString*)path;
- (GLuint) textureName;

@end
