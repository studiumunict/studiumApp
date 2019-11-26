//
//  ConfirmView.swift
//  Studium
//
//  Created by Simone Scionti on 26/11/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
enum CButtonType {
    case top
    case bottom
    case left
    case right
    case center
    case alone
    case centerTopRounded
}
class ConfirmView {
    static var obj : ConfirmView!
    
    static func getUniqueIstance()->ConfirmView{
        if obj == nil{
            obj = ConfirmView()
        }
        return obj
    }
    private init(){}
    
    public func updateView( confirmView : inout UIView ,titleLabel : UILabel, descLabel : UILabel? = nil ,buttons: [UIButton], dataToAttach : Any? = nil, animated :Bool){
        for sv in confirmView.subviews{
            UIView.animate(withDuration: 0.3, animations: {
                sv.alpha = 0.0
            }) { (flag) in
                sv.removeFromSuperview()
            }
        }
        addTitleLabel(toView: confirmView, titleLabel: titleLabel, animated: true)
        if let dl = descLabel {
            addDescriptionLabel(toView: confirmView, descLabel: dl, animated: true)
        }
        if let data = dataToAttach {
            attachData(toView: confirmView, data: data)
        }
        addButtons(toView: confirmView, buttons: buttons, animated: true)
    }
    
    private func addTitleLabel(toView: UIView, titleLabel:UILabel, animated: Bool){
        titleLabel.frame = CGRect(x: 10, y: 20, width: toView.frame.size.width - 20, height: 20)
        toView.addSubview(titleLabel)
        if animated{
            titleLabel.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                titleLabel.alpha = 1.0
            }
        }
    }
    private func addDescriptionLabel(toView: UIView, descLabel:UILabel, animated: Bool){
        descLabel.frame = CGRect(x: 10 , y: 45, width: toView.frame.size.width - 20, height: 20)
        toView.addSubview(descLabel)
        if animated{
            descLabel.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                descLabel.alpha = 1.0
            }
        }
    }
    
    private func attachData(toView :UIView , data: Any){
        toView.accessibilityElements = [Any]()
        toView.accessibilityElements?.append(data)
    }
    
    private func addButtons(toView: UIView, buttons : [UIButton], animated: Bool){
        for btn in buttons{
            let btnPos = btn.accessibilityElements?[0] as! CButtonType
            switch btnPos{
                case .left: btn.frame = CGRect(x: toView.frame.size.width/2 - 100 + 0.5 , y: 100, width: 100, height: 40)
                case .right: btn.frame = CGRect(x: toView.frame.size.width/2 - 0.5, y: 100 , width: 100, height: 40)
                case .alone:
                    btn.frame = CGRect(x: 0, y: 100 , width: 200, height: 40)
                    btn.center.x = toView.center.x - 20
                case .top:btn.center = CGPoint(x: toView.center.x, y: toView.center.y * 1.6 - (38*2))
                case .bottom: btn.center = CGPoint(x: toView.center.x, y: toView.center.y * 1.6)
                case .center: btn.center = CGPoint(x: toView.center.x, y: toView.center.y * 1.6 - 38)
                case .centerTopRounded: btn.center = CGPoint(x: toView.center.x, y: toView.center.y * 1.6 - 38)
            }
            toView.addSubview(btn)
            btn.setNeedsDisplay()
            if animated{
                btn.alpha = 0.0
                UIView.animate(withDuration: 0.3) {
                    btn.alpha = 1.0
                }
            }
        }
    }
    
    public func getView(titleLabel : UILabel, descLabel : UILabel? = nil ,buttons: [UIButton], dataToAttach : Any? = nil)-> UIView{
        let screenWidth = UIScreen.main.bounds.size.width
        let newFrame = CGRect(x: 0, y: 0, width: screenWidth * 0.9, height: 180)
        let view = UIView.init(frame: newFrame)
        view.backgroundColor = UIColor.primaryBackground
        view.layer.borderColor = UIColor.secondaryBackground.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5.0
        view.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        view.alpha = 0.0
        addTitleLabel(toView: view, titleLabel: titleLabel, animated: false)
        if let dl = descLabel {
            addDescriptionLabel(toView: view, descLabel: dl, animated: false)
        }
        if let data = dataToAttach {
            attachData(toView: view, data: data)
        }
        addButtons(toView: view, buttons: buttons, animated: false)
        return view
    }
    
    private func getButtonFrame(position: CButtonType) ->CGRect{
        let screenWidth = UIScreen.main.bounds.size.width
        let viewFrame = CGRect(x: 0, y: 0, width: screenWidth * 0.9, height: 180)
        switch position{
            case .top : return CGRect(x: 0, y:0 , width: viewFrame.size.width * 0.8, height: 40)
            case .bottom: return CGRect(x: 0, y:0 , width: viewFrame.size.width * 0.8, height: 40)
            case .center: return CGRect(x: 0, y:0 , width: viewFrame.size.width * 0.8 - 2, height: 40)
            case .centerTopRounded: return CGRect(x: 0, y:0 , width: viewFrame.size.width * 0.8, height: 40)
            default: return CGRect(x: 0, y:0 , width: 100, height: 40)
        }
    }
    
    public func getButton(position: CButtonType, dataToAttach: Any? = nil, title: String, selector: Selector, target: Any)->UIButton{
        let frame = getButtonFrame(position: position)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.lightWhite
        button.setTitleColor(UIColor.textBlueColor, for: .normal)
        button.accessibilityElements = [Any]()
        button.accessibilityElements?.append(position)
        if let data = dataToAttach {
            button.accessibilityElements?.append(data)
        }
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 9)
        button.layer.cornerRadius = 5.0
        button.contentMode = .redraw
        switch position {
            case .left:
                button.setTitleColor(UIColor.textRedColor, for: .normal)
                button.layer.addBorder(edge: .right, color: #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 1), thickness: 0.5)
                SSCustomLayers.getUniqueIstance().roundLeftRadius(radius: 5.0, view: button)
            case .right: SSCustomLayers.getUniqueIstance().roundRightRadius(radius: 5.0, view: button)
            case .alone:
                button.layer.cornerRadius = 5.0
                button.layer.borderWidth = 1.5
                button.layer.borderColor = UIColor.secondaryBackground.cgColor
            case .top: SSCustomLayers.getUniqueIstance().roundTopRadius(radius: 5.0, view: button)
            case .bottom:
                button.setTitleColor(UIColor.textRedColor, for: .normal)
                SSCustomLayers.getUniqueIstance().roundBottomRadius(radius: 5.0, view: button)
            case .center:
                button.layer.cornerRadius = 0.0
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.secondaryBackground.cgColor
             case .centerTopRounded: SSCustomLayers.getUniqueIstance().roundTopRadius(radius: 5.0, view: button)
        }
        return button
    }
    public func getTitleLabel(text: String)->UILabel{
        let screenWidth = UIScreen.main.bounds.size.width
        let viewFrame = CGRect(x: 0, y: 0, width: screenWidth * 0.9, height: 180)
        let label = UILabel.init(frame: CGRect(x: 10, y: 20, width: viewFrame.size.width - 20, height: 20))
        label.text = text
        label.textColor = UIColor.lightWhite
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }
    public func getDescriptionLabel(text:String)->UILabel{
        let screenWidth = UIScreen.main.bounds.size.width
        let viewFrame = CGRect(x: 0, y: 0, width: screenWidth * 0.9, height: 180)
        let label = UILabel.init(frame: CGRect(x: 10 , y: 45, width: viewFrame.size.width - 20, height: 20))
        label.text = text
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }

}
