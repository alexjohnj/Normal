//
//  CIImage+Effects.swift
//  Normal
//
//  Created by Alex Jackson on 2017-05-07.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import CoreImage

extension CIImage {
    func applyingClampedGaussianBlur(withSigma sigma: Double) -> CIImage {
        let preClampExtent = self.extent
        return self
            .clampedToExtent()
            .applyingGaussianBlur(sigma: sigma)
            .cropped(to: preClampExtent)
    }
}
