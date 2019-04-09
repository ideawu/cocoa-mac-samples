

#import "Scene.h"
#import "Texture.h"
#import <OpenGL/glu.h>

static double dtor( double degrees ) {
    return degrees * M_PI / 180.0;
}

@implementation Scene

- init {
    self = [super init];
    if (self) {
        textureName = 0;
        animationPhase = 0.0;
        cameraDistance = 0.8;
        rollAngle = 0.0;
        sunAngle = 135.0;
        wireframe = NO;
    }
    return self;
}

- (void)dealloc {
    [texture release];
    [super dealloc];
}

- (float)cameraDistance {
    return cameraDistance;
}

- (void)setCameraDistance:(float)newCameraDistance {
    cameraDistance = newCameraDistance;
}

- (float)rollAngle {
    return rollAngle;
}

- (void)setRollAngle:(float)newRollAngle {
    rollAngle = newRollAngle;
}

- (float)sunAngle {
    return sunAngle;
}

- (void)setSunAngle:(float)newSunAngle {
    sunAngle = newSunAngle;
}

- (void)advanceTimeBy:(float)seconds {
    float phaseDelta = seconds - floor(seconds);
    float newAnimationPhase = animationPhase + 0.015625 * phaseDelta;
    newAnimationPhase = newAnimationPhase - floor(newAnimationPhase);
    [self setAnimationPhase:newAnimationPhase];
}

- (void)setAnimationPhase:(float)newAnimationPhase {
    animationPhase = newAnimationPhase;
}

- (BOOL)wireframe {
    return wireframe;
}

- (void)setWireframe:(BOOL)flag {
    wireframe = flag;
}

- (void)toggleWireframe {
    wireframe = !wireframe;
}

- (void)setViewportRect:(NSRect)viewport {
    glViewport( viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height );

    glMatrixMode( GL_PROJECTION );
    glLoadIdentity();
    gluPerspective( 30, viewport.size.width / viewport.size.height, 0.5, 1000.0 );

    glMatrixMode( GL_MODELVIEW );
    glLoadIdentity();
}

- (void)prepareOpenGL {
    // Upload the texture.    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Earth" ofType:@"jpg"];
    texture = [[Texture alloc] initWithPath:path];
    textureName = [texture textureName];
}

// This method renders our scene.  We could optimize it in any of several ways, including factoring out the repeated OpenGL initialization calls and either hanging onto the GLU quadric object or creating a Vertex Buffer Object that draws the Earth, but the details of how it's implemented aren't important here.  This code serves merely to give us some OpenGL content to look at.
- (void)render {
    static GLfloat lightDirection[] = { -0.7071, 0.0, 0.7071, 0.0 };
    static GLfloat radius = 0.25;
    static GLfloat materialAmbient[4] = { 0.0, 0.0, 0.0, 0.0 };
    static GLfloat materialDiffuse[4] = { 1.0, 1.0, 1.0, 1.0 };
    GLUquadric *quadric = NULL;

    // Set up rendering state.
    glEnable( GL_DEPTH_TEST );
    glEnable( GL_CULL_FACE );
    glEnable( GL_LIGHTING );
    glEnable( GL_LIGHT0 );

    // Set up texturing parameters.
    glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
    glEnable( GL_TEXTURE_2D );
    glBindTexture( GL_TEXTURE_2D, textureName );

    glPushMatrix();
    
        // Set up our single directional light (the Sun!).
        lightDirection[0] = cos(dtor(sunAngle));
        lightDirection[2] = sin(dtor(sunAngle));
        glLightfv( GL_LIGHT0, GL_POSITION, lightDirection );

        // Back the camera off a bit.
        glTranslatef( 0.0, 0.0, -cameraDistance );
        
        // Draw the Earth!
        quadric = gluNewQuadric();
        if (wireframe) {
            gluQuadricDrawStyle( quadric, GLU_LINE );
        }
        gluQuadricTexture( quadric, GL_TRUE );
        glMaterialfv( GL_FRONT, GL_AMBIENT, materialAmbient );
        glMaterialfv( GL_FRONT, GL_DIFFUSE, materialDiffuse );
        glRotatef( rollAngle, 1.0, 0.0, 0.0 );
        glRotatef( -23.45, 0.0, 0.0, 1.0 ); // Earth's axial tilt is 23.45 degrees from the plane of the ecliptic.
        glRotatef( animationPhase * 360.0, 0.0, 1.0, 0.0 );
        glRotatef( 90.0, 1.0, 0.0, 0.0 );
        gluSphere( quadric, radius, 48, 24 );
        gluDeleteQuadric(quadric);
        quadric = NULL;

    glPopMatrix();
    
    // Flush out any unfinished rendering before swapping.
    glFinish();
}

@end
