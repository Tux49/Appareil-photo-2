//
//  CustomImageView.swift
//  Appareil photo 2
//
//  Created by Thierry Huu on 25/10/2018.
//  Copyright © 2018 Thierry Huu. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    func montrerImage(_ image: UIImage?) {
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        self.image = image
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cacherImage)))
    }

    @objc func cacherImage() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = .clear
            self.frame.size = CGSize(width: 0, height: 0)
        }) { (success) in
            self.removeFromSuperview()
        }
    }
}
