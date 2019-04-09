/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Mediator utility class for querying all OpenGL renderers
 */

#ifndef _OPENGL_UTILITIES_QUERY_DEVICES_H_
#define _OPENGL_UTILITIES_QUERY_DEVICES_H_

#import "GLUQueryDevice.h"

#ifdef __cplusplus

namespace GLU
{
    namespace Query
    {
        typedef std::unordered_map<GLint, Device> DeviceTable;
        
        class Devices
        {
        public:
            Devices(CGLContextObj pContext);
            
            virtual ~Devices();
            
            static Devices *create();
            static Devices *create(const CGLPixelFormatAttribute * const pAttributes);

            const GLint& count()     const;
            const GLint* renderers() const;
            
            const bool match(const GLint& nID, GLstring& rKey)   const;
            const bool match(const GLint& nID, GLstrings& rKeys) const;

            GLfeatures features(const GLint& nID);
            GLstring   renderer(const GLint& nID);
            GLstring   vendor(const GLint& nID);
            GLstring   version(const GLint& nID);
            
        private:
            GLint        mnCount;
            DeviceTable  m_Table;
            GLrenderids  m_Renderers;
        }; // Devices
    } // Query
} // GLU

#endif

#endif

