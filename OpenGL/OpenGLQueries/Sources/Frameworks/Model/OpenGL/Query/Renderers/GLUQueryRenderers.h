/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Query class for OpenGL renderers.
 */

#ifndef _OPENGL_UTILITIES_QUERY_RENDERERS_H_
#define _OPENGL_UTILITIES_QUERY_RENDERERS_H_

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#import "GLContainers.h"

#ifdef __cplusplus

namespace GLU
{
    namespace Query
    {
        class Renderers
        {
        public:
            // Create an object for multiple displays
            Renderers(const GLuint& nDisplayMask);
            
            // Destructor
            virtual ~Renderers();
            
            // Get renderers
            const GLrenderers& renderers() const;
            
            // Get a description string representing all the key-value pairs
            // in the hash table
            GLstring& description();
            
            // Create an instance of this object for all renderers
            static Renderers *create();
            
            // Print all the key-value pairs
            friend GLostream& operator<<(GLostream &rOutput, Renderers &rRenderers);
            
        private:
            GLrenderers  m_Renderers;
            GLstring     m_Description;
        }; // Displays
    } // Query
} // GLU

#endif

#endif
