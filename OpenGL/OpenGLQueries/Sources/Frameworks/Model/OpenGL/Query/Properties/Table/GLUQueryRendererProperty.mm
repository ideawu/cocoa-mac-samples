/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A utility class for converting a subset of properties into their string equivalent.
 */

#import "GLUQueryRendererPropertyNames.h"
#import "GLUQueryRendererProperty.h"

static const size_t kPadSpace = 10;

GLU::Query::RendererProperty::RendererProperty()
{
    GLuint i;
    
    for(i = 0; i < kProperteyCount; ++i)
    {
        mnLength = std::max(mnLength, kPropertyNames[i].length());
        
        m_Names.emplace(GLuint(kProperty[i]), kPropertyNames[i]);
    } // for
    
    mnLength += kPadSpace;
} // Constructor

GLU::Query::RendererProperty::~RendererProperty()
{
    if(!m_Names.empty())
    {
        for(auto& name:m_Names)
        {
            if(!name.second.empty())
            {
                name.second.clear();
            } // if
        } // for
        
        m_Names.clear();
    } // if
} // Destructor

GLstring GLU::Query::RendererProperty::find(const GLuint& nProperty)
{
    GLstring value;
    
    GLpropertynames::const_iterator pIter = m_Names.find(nProperty);
    
    if(pIter != m_Names.end())
    {
        value = pIter->second;
    } // if
    
    return value;
} // find

GLstring GLU::Query::RendererProperty::find(const CGLRendererProperty& nProperty)
{
    return find(GLuint(nProperty));
} // find

GLstring GLU::Query::RendererProperty::operator [](const GLuint& nProperty)
{
    return find(nProperty);
} // operator []

GLstring GLU::Query::RendererProperty::operator [](const CGLRendererProperty& nProperty)
{
    return find(nProperty);
} // operator []

size_t GLU::Query::RendererProperty::length()
{
    return mnLength;
} // length

size_t GLU::Query::RendererProperty::length(const CGLRendererProperty& nProperty)
{
    GLstring value = find(nProperty);
    
    return value.length();
} // length

