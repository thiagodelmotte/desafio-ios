
import Foundation
import UIKit

extension UINavigationController {
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    self.customizeDefault()
  }
  
  fileprivate func customizeDefault() {
    self.navigationBar.barTintColor = StyleGuide.Color.Black.value
    self.navigationBar.tintColor = StyleGuide.Color.White.value
    let font = StyleGuide.Font.Title.value
    self.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: StyleGuide.Color.White.value]
  }
  
}
