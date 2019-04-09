/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 OpenGL container type definitions.
 */

#ifndef _OPENGL_CONTAINERS_H_
#define _OPENGL_CONTAINERS_H_

#import <ostream>
#import <regex>
#import <sstream>
#import <string>
#import <unordered_map>
#import <unordered_set>
#import <vector>

#import <OpenGL/OpenGL.h>

#ifdef __cplusplus

typedef std::string                                         GLstring;
typedef std::ostream                                        GLostream;
typedef std::ostringstream                                  GLosstringstream;
typedef std::regex                                          GLregex;
typedef std::vector<GLint>                                  GLrenderids;
typedef std::vector<GLstring>                               GLstrings;
typedef std::unordered_map<GLstring, GLstring>              GLfeatures;
typedef std::unordered_map<GLuint, GLint>                   GLproperties;
typedef std::unordered_map<GLint, GLproperties>             GLrenderers;
typedef std::unordered_map<CGDirectDisplayID, GLrenderers>  GLdisplays;
typedef std::unordered_map<GLuint, GLstring>                GLpropertynames;
typedef std::unordered_set<GLstring>                        GLstringset;

#endif

#endif
