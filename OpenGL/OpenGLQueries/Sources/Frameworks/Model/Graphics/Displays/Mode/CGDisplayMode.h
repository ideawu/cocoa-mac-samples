/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class to acquire cg display mode properties.
 */

#ifndef _CORE_GRAPHICS_DISPLAY_MODE_H_
#define _CORE_GRAPHICS_DISPLAY_MODE_H_

#import <string>

#import <Cocoa/Cocoa.h>

#ifdef __cplusplus

namespace CG
{
    namespace Display
    {
        struct Size
        {
            size_t width;
            size_t height;
        }; // Size
        
        class Mode
        {
        public:
            Mode(const CGDisplayModeRef pDisplayMode = nullptr);
            
            Mode(const Mode& rMode);
            
            virtual ~Mode();
            
            Mode& operator=(const Mode& rMode);
    
            const bool& isUsable() const;
            
            const Size& points()  const;
            const Size& pixels() const;
            
            const uint32_t& flags()  const;
            const uint32_t& handle() const;
                        
        private:
            bool         mbIsUsable;
            Size         m_Points;
            Size         m_Pixels;
            uint32_t     mnFlags;
            uint32_t     mnHandle;
        }; // Mode
    } // Display
} // CG

#endif

#endif

