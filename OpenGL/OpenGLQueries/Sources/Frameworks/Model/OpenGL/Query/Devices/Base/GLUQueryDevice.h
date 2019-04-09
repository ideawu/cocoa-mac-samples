/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class for querying OpenGL device information.
 */

#ifndef _OPENGL_UTILITIES_QUERY_DEVICE_H_
#define _OPENGL_UTILITIES_QUERY_DEVICE_H_

#import "GLContainers.h"

#ifdef __cplusplus

namespace GLU
{
    namespace Query
    {
        class Device
        {
        public:
            Device(CGLContextObj pContext, const GLint& nScreen = 0);
            
            virtual ~Device();
            
            const bool match(GLstring& rKey)   const;
            const bool match(GLstrings& rKeys) const;

            bool find(const GLstring& rFeature);
            
            const bool&        noError()  const;
            const GLfeatures&  features() const;
            const GLstring&    renderer() const;
            const GLstring&    vendor()   const;
            const GLstring&    version()  const;
            
        private:
            bool        mbNoError;
            GLint       mnEntries;
            GLfeatures  m_Features;
            GLstring    m_DeviceInfo[3];
        }; // Device
    } // Query
} // GLU

#endif

#endif

