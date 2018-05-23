//
//  CLInputswift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CLInputCell: UITableViewCell{
    
    var textFieldLabel = UILabel()
    var textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.selectionStyle = .none
        
        //Setup TextField Label
        textFieldLabel.textColor = .darkGray
        textFieldLabel.font = UIFont.systemFont(ofSize: 14)
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldLabel)
        
        //Setup TextField
        textField.textColor = .darkGray
        textField.font = UIFont.boldSystemFont(ofSize: 26)
        textField.tintColor = CLColor.primary
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["textFieldLabel": textFieldLabel, "textField": textField] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textFieldLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textFieldLabel(20)][textField]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
