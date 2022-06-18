//
//  EmptyView.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.06.2022.
//

import UIKit

class EmptyView: UIView {

    static var emptyViewObj = EmptyView()
    
    static func viewSetup(_ text: String, _ imageName: String) {
        emptyViewObj.nameLbl.text = text
        emptyViewObj.imageView.image = UIImage(named: imageName)
    }
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
