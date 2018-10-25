//
//  BoutonArrondi.swift
//  Appareil photo 2
//
//  Created by Thierry Huu on 25/10/2018.
//  Copyright © 2018 Thierry Huu. All rights reserved.
//

import UIKit

class BoutonArrondi: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 10
    }
}
