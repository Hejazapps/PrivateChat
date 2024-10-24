 

import UIKit

class PaddingLabel: UILabel {
    enum MessageType {
        case received
        case sent
        
        var maskedCorners: CACornerMask {
            return switch self {
            case .received:
                [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
                
            case .sent:
                [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
        }
    }
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
 
    override var intrinsicContentSize: CGSize {
        numberOfLines = 0
        var s = super.intrinsicContentSize
        s.height = s.height + topInset + bottomInset
        s.width = s.width + leftInset + rightInset
        return s
    }
    
    override func drawText(in rect:CGRect) {
        let r = rect.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
        super.drawText(in: r)
    }
    
    override func textRect(
        forBounds bounds:CGRect,
        limitedToNumberOfLines n:Int
    ) -> CGRect {
        
        let b = bounds
        let tr = b.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: n)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }
    
    func makeChatBubble(cornerRadius: CGFloat, messageType: MessageType) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = messageType.maskedCorners
        layer.masksToBounds = true
    }
}

