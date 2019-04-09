/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Mediator class to acquire properties usable for desktop gui for all active displays.
 */

#ifndef _CORE_GRAPHICS_DISPLAY_LIST_H_
#define _CORE_GRAPHICS_DISPLAY_LIST_H_

#import <unordered_map>

#import <Cocoa/Cocoa.h>

#import "CGDisplayModes.h"

#ifdef __cplusplus

namespace CG
{
    namespace Display
    {
        typedef std::unordered_map<uint32_t, Modes>  DisplayTable;
        
        class List
        {
        public:
            List(const uint32_t& nDisplayCount);
            
            virtual ~List();
            
            static List *create();
            
            const uint32_t*     displays() const;
            const uint32_t&     count()    const;
            const DisplayTable& table()    const;
            
            const Modes modes(const uint32_t& nDisplayID) const;

        private:
            uint32_t*      mpDisplays;
            uint32_t       mnCount;
            DisplayTable   m_Table;
        }; // List
    } // Display
} // CG

#endif

#endif

