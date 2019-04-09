/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Constants for property names.
 */

#ifndef _OPENGL_UTILITIES_QUERY_RENDERER_PROPERTY_NAMES_H_
#define _OPENGL_UTILITIES_QUERY_RENDERER_PROPERTY_NAMES_H_

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#import "GLContainers.h"

#ifdef __cplusplus

namespace GLU
{
    namespace Query
    {
        static const GLuint kProperteyCount = 9;
        
        static const CGLRendererProperty kProperty[kProperteyCount] =
        {
            kCGLRPMajorGLVersion,
            kCGLRPOnline,
            kCGLRPVideoMemoryMegabytes,
            kCGLRPTextureMemoryMegabytes,
            kCGLRPSampleAlpha,
            kCGLRPMaxAuxBuffers,
            kCGLRPMaxSamples,
            kCGLRPMaxSampleBuffers,
            kCGLRPAcceleratedCompute
        };
        
        static const GLstring kPropertyNames[kProperteyCount] =
        {
            "Major GL Version",
            "Renderer Online",
            "Video Memory (MB)",
            "Texture Memory (MB)",
            "Sample Alpha",
            "Max Aux Buffers",
            "Max Samples",
            "Max Sample Buffers",
            "Accelerated Compute"
        };
    } // Query
} // GLU

#endif

#endif
