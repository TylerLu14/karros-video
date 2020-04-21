//
//  CommentsView.swift
//  karros-video
//
//  Created by Hoang Lu on 4/21/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import UIKit

class CommentsView: UIView {
    
    var comments: [Review] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
    }

}
