import UIKit

extension UIImage {
    func createSelectionIndicator(color:UIColor,size:CGSize,lineHeight:CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let innerRect = CGRect(x: (size.width/2) - lineHeight / 2, y: ((size.height / 2) - lineHeight / 2) - 5, width: lineHeight, height: lineHeight)
        let path = UIBezierPath(roundedRect: innerRect, cornerRadius: lineHeight / 2)
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
