/*
    File: ClientOpenGLView.m
Abstract: 
This class implements the client specific subclass of NSOpenGLView. 
It handles the client side rendering, which calls into the GLUT-based
BluePony rendering code, substituting the contents of an IOSurface from
the server application instead of the OpenGL logo.

It also shows how to bind IOSurface objects to OpenGL textures.

 Version: 1.2

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

Copyright (C) 2014 Apple Inc. All Rights Reserved.

*/

#import "ClientOpenGLView.h"
#import "ClientController.h"

#include "shaderUtil.h"
#include "fileUtil.h"

#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <OpenGL/CGLIOSurface.h>
#import <GLKit/GLKit.h>

// shader info
enum {
    PROGRAM_TEXTURE_RECT,
    NUM_PROGRAMS
};

enum {
    UNIFORM_MVP,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
};

enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXCOORD,
    NUM_ATTRIBS
};

typedef struct {
    char *vert, *frag;
    GLint uniform[NUM_UNIFORMS];
    GLuint id;
} programInfo_t;

programInfo_t program[NUM_PROGRAMS] = {
    { "texture.vsh",    "textureRect.fsh"   },  // PROGRAM_TEXTURE_RECT
};


@interface ClientOpenGLView()
{
    GLuint quadVAOId, quadVBOId;
    BOOL quadInit;
}
@end

@implementation ClientOpenGLView

- (instancetype)initWithFrame:(NSRect)frame
{
	NSOpenGLPixelFormat *pix_fmt;
	
	NSOpenGLPixelFormatAttribute attribs[] =
	{
		NSOpenGLPFAAllowOfflineRenderers,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAColorSize, 32,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAMultisample, 1,
		NSOpenGLPFASampleBuffers, 1,
		NSOpenGLPFASamples, 4,
		NSOpenGLPFANoRecovery,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core, // Core Profile is the future
		0
	};
	
	pix_fmt = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
	if(!pix_fmt)
	{
		// Try again without multisample
		NSOpenGLPixelFormatAttribute attribs_no_multisample[] =
		{
			NSOpenGLPFAAllowOfflineRenderers,
			NSOpenGLPFAAccelerated,
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFAColorSize, 32,
			NSOpenGLPFADepthSize, 24,
			NSOpenGLPFANoRecovery,
            NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core, // Core Profile is the future
			0
		};

		pix_fmt = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs_no_multisample];
		if(!pix_fmt)
			[NSApp terminate:nil];
	}
	
	self = [super initWithFrame:frame pixelFormat:pix_fmt];
	[pix_fmt release];
	
	[[self openGLContext] makeCurrentContext];

	return self;
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glGenVertexArrays(1, &quadVAOId);
    glGenBuffers(1, &quadVBOId);
    
    glBindVertexArray(quadVAOId);
    
    [self setupShaders];
    
    glBindVertexArray(0);
}

- (void)update
{
	// Override to do nothing.
}

- (NSArray *)rendererNames
{
	NSMutableArray *rendererNames;
	GLint i, numScreens;
	
	rendererNames = [[NSMutableArray alloc] init];
	
	numScreens = [[self pixelFormat] numberOfVirtualScreens];
	for(i = 0; i < numScreens; i++)
	{
		[[self openGLContext] setCurrentVirtualScreen:i];
		[rendererNames addObject:@((const char *)glGetString(GL_RENDERER))];
	}
	
	return [rendererNames autorelease];
}

- (void)setRendererIndex:(uint32_t)index
{
	[[self openGLContext] setCurrentVirtualScreen:index];
}

// Create an IOSurface backed texture
- (GLuint)setupIOSurfaceTexture:(IOSurfaceRef)ioSurfaceBuffer
{
	GLuint name;
	CGLContextObj cgl_ctx = (CGLContextObj)[[self openGLContext] CGLContextObj];
	
	glGenTextures(1, &name);
	
	glBindTexture(GL_TEXTURE_RECTANGLE, name);
    // At the moment, CGLTexImageIOSurface2D requires the GL_TEXTURE_RECTANGLE target
	CGLTexImageIOSurface2D(cgl_ctx, GL_TEXTURE_RECTANGLE, GL_RGBA, 512, 512, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV,
					ioSurfaceBuffer, 0);
	glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);	
	
	return name;
}

- (BOOL)isOpaque
{
	return YES;
}

// Render a quad with the the IOSurface backed texture
- (void)renderTextureFromIOSurfaceWithWidth:(GLsizei)logoWidth height:(GLsizei)logoHeight
{
    GLfloat quad[] = {
        //x, y            s, t
        -1.0f, -1.0f,     0.0f, 0.0f,
         1.0f, -1.0f,     logoWidth, 0.0f,
        -1.0f,  1.0f,     0.0f, logoHeight,
         1.0f,  1.0f,     logoWidth, logoHeight
    };
    
    if (!quadInit) {
        glBindVertexArray(quadVAOId);
        glBindBuffer(GL_ARRAY_BUFFER, quadVBOId);
        glBufferData(GL_ARRAY_BUFFER, sizeof(quad), quad, GL_STATIC_DRAW);
        // positions
        glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), NULL);
        // texture coordinates
        glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), (const GLvoid*)(2*sizeof(GLfloat)));
        
        quadInit = YES;
    }
    
    glUseProgram(program[PROGRAM_TEXTURE_RECT].id);
    
    // projection matrix
    GLfloat aspectRatio = self.bounds.size.width / self.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakeFrustum(-aspectRatio, aspectRatio, -1, 1, 2, 100);
    // modelView matrix
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(0, 0, -9.0);
    modelView = GLKMatrix4Scale(modelView, 2.5, 2.5, 2.5);
    modelView = GLKMatrix4Rotate(modelView, 30.0 * M_PI / 180.0, 0.0, 1.0, 0.0);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, modelView);
    glUniformMatrix4fv(program[PROGRAM_TEXTURE_RECT].uniform[UNIFORM_MVP], 1, GL_FALSE, mvp.m);
    
    glUniform1i(program[PROGRAM_TEXTURE_RECT].uniform[UNIFORM_TEXTURE], 0);
    
    glBindTexture(GL_TEXTURE_RECTANGLE, [(ClientController *)[NSApp delegate] currentTextureName]);
    glEnable(GL_TEXTURE_RECTANGLE);
    
    glBindVertexArray(quadVAOId);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glEnableVertexAttribArray(ATTRIB_TEXCOORD);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(ATTRIB_VERTEX);
    glDisableVertexAttribArray(ATTRIB_TEXCOORD);
    glDisable(GL_TEXTURE_RECTANGLE);
}

- (void)drawRect:(NSRect)theRect
{
    glViewport(0, 0, (GLint)self.bounds.size.width, (GLint)self.bounds.size.height);
    
    glClearColor(0.5f, 0.8f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    // Client draws with current IO surface contents as logo texture
    [self renderTextureFromIOSurfaceWithWidth:512 height:512];
	
	[[self openGLContext] flushBuffer];
}

- (void)setupShaders
{
    for (int i = 0; i < NUM_PROGRAMS; i++)
    {
        char *vsrc = readFile(pathForResource(program[i].vert));
        char *fsrc = readFile(pathForResource(program[i].frag));
        GLsizei attribCt = 0;
        GLchar *attribUsed[NUM_ATTRIBS];
        GLint attrib[NUM_ATTRIBS];
        GLchar *attribName[NUM_ATTRIBS] = {
            "inVertex", "inTexCoord",
        };
        const GLchar *uniformName[NUM_UNIFORMS] = {
            "MVP", "tex",
        };
        
        // auto-assign known attribs
        for (int j = 0; j < NUM_ATTRIBS; j++)
        {
            if (strstr(vsrc, attribName[j]))
            {
                attrib[attribCt] = j;
                attribUsed[attribCt++] = attribName[j];
            }
        }
        
        glueCreateProgram(vsrc, fsrc,
                          attribCt, (const GLchar **)&attribUsed[0], attrib,
                          NUM_UNIFORMS, &uniformName[0], program[i].uniform,
                          &program[i].id);
        free(vsrc);
        free(fsrc);
    }
}

@end
