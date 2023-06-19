//
//  RoundView.swift
//  DemoRoundMenu
//
//  Created by Navroz Huda on 15/06/23.
//


import UIKit
import Foundation

struct MenuItem{
    var name:String
    var imageName:String
}
protocol RoundMenuDelegate: AnyObject {
    func menuClicked(menuItem:MenuItem)
}
@IBDesignable class RoundView:UIView{
   
    weak var delegate:RoundMenuDelegate?
    var color = UIColor.clear
    var borderColour = UIColor.white
    var borderWidth : CGFloat = 1
    var menuList = [MenuItem]()
    var buttonSize:CGFloat = 20.0
    private var deltaAngle:CGFloat = 0
    
    @IBOutlet weak var contentView: UIView!{
        didSet {
            contentView.backgroundColor = .clear
            }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: RoundView.self), owner: self, options: nil)
        contentView.fixInView(self)
    }
    func setupUI(){
        contentView.layer.cornerRadius = (contentView.frame.size.width > contentView.frame.size.height) ? contentView.frame.height / 2 : contentView.frame.width / 2
        if menuList.isEmpty {return}
        let sliceAngle = 360 / menuList.count
        for (i,menuItem) in menuList.enumerated(){
            setButtons(sliceAngle:CGFloat(sliceAngle),index:i,menuItem:menuItem)
        }
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture))
        contentView.addGestureRecognizer(gestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }
    func setButtons(sliceAngle:CGFloat = 0.0,index:Int = 0,menuItem:MenuItem){
        buttonSize = (contentView.frame.size.width > contentView.frame.size.height) ? contentView.frame.height / 5 : contentView.frame.width / 5
        let degree = CGFloat(index) * sliceAngle
        let angle = CGFloat(degree) * .pi / CGFloat(180.0)
        let radius: CGFloat = (contentView.frame.size.width > contentView.frame.size.height) ? (contentView.frame.size.height / 2.0 - buttonSize/2) : (contentView.frame.size.width / 2.0 - buttonSize/2)
        let center = CGPoint(x: contentView.frame.size.width / 2.0, y: contentView.frame.size.height / 2.0)
        let endPoint = CGPoint(x: center.x + sin(angle) * radius,
                               y: center.y + cos(angle) * radius)
        let button = UIButton()
        button.frame = CGRect(x: endPoint.x - buttonSize/2, y:  endPoint.y - buttonSize/2, width: buttonSize, height: buttonSize)
        button.setImage(UIImage(named:menuItem.imageName), for: .normal)
        button.layer.cornerRadius = buttonSize/2
        button.tag = index
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
    }
    @objc func menuButtonTapped(_ button : UIButton){
        delegate?.menuClicked(menuItem: menuList[button.tag])
    }
    @objc func handleRotateGesture(_ recognizer : UIPanGestureRecognizer){
            let touchLocation = recognizer.location(in: contentView.superview)
            
            let center = contentView.center
            
            switch recognizer.state{
                
            case .began :
                self.deltaAngle = atan2(touchLocation.y - center.y, touchLocation.x - center.x) - atan2(contentView.transform.b, contentView.transform.a)
                
            case .changed:
                let angle = atan2(touchLocation.y - center.y, touchLocation.x - center.x)
                
                let angleDiff = self.deltaAngle - angle
                
                contentView.transform = CGAffineTransform(rotationAngle: -angleDiff)
                for view in contentView.subviews{
                    view.transform = CGAffineTransform(rotationAngle: angleDiff)
                }
                
            default: break
                
            }
            
    }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
