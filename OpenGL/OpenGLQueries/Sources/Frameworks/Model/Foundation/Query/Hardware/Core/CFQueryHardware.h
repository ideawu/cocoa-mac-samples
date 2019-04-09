/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class for querying hardware features.
 */

#ifndef _CORE_FOUNDATION_QUERY_HARDWARE_H_
#define _CORE_FOUNDATION_QUERY_HARDWARE_H_

#import <string>
#import <cmath>

#ifdef __cplusplus

namespace CF
{
    namespace Query
    {
        namespace Frequency
        {
            extern double_t kHertz;
            extern double_t kKiloHertz;
            extern double_t kMegaHertz;
            extern double_t kGigaHetrz;
        };
        
        class Hardware
        {
        public:
            Hardware(const double_t& frequency = Frequency::kGigaHetrz);
            
            virtual ~Hardware();
            
            Hardware(const Hardware& hw);
            
            Hardware& operator=(const Hardware& hw);
                        
            const size_t&      cores()  const;
            const size_t&      memory() const;
            const double_t&    cpu()    const;
            const std::string& model()  const;
            
        private:
            std::string  m_Model;
            double_t     mnCPU;
            double_t     mnFreq;
            size_t       mnCores;
            size_t       mnSize;
        }; // Hardware
    } // Query
} // CF

#endif

#endif
