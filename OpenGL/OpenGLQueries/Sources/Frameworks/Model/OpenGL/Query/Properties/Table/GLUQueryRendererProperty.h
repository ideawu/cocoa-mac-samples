/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A utility class for converting a subset of properties into their string equivalent.
 */

#ifndef _OPENGL_UTILITIES_QUERY_RENDERER_PROPERTY_H_
#define _OPENGL_UTILITIES_QUERY_RENDERER_PROPERTY_H_

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#import "GLContainers.h"

#ifdef __cplusplus

namespace GLU
{
    namespace Query
    {
        class RendererProperty
        {
        public:
            RendererProperty();
            
            virtual ~RendererProperty();
            
            GLstring operator[](const GLuint& nProperty);
            GLstring operator[](const CGLRendererProperty& nProperty);
            
            size_t length();
            size_t length(const CGLRendererProperty& nProperty);
           
            GLstring find(const GLuint& nProperty);
            GLstring find(const CGLRendererProperty& nProperty);
            
        private:
            size_t          mnLength;
            GLpropertynames m_Names;
        }; // RendererProperty
    } // Query
} // GLU

#endif

#endif
