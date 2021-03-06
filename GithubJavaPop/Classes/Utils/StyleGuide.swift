
import Foundation
import UIKit

class StyleGuide {
  
  
  // MARK: - Color
  
  enum Color {
    
    case White
    case Black
    case Red
    case Orange
    case Blue
    case Gray
    case Transparent
    
    var value: UIColor {
      switch self {
        case .White:
          return UIColor(r: 255, g: 255, b: 255, a: 1)
        case .Black:
          return UIColor(r: 52, g: 52, b: 56, a: 1)
        case .Red:
          return UIColor(r: 227, g: 117, b: 126, a: 1)
        case .Orange:
          return UIColor(r: 235, g: 164, b: 83, a: 1)
        case .Blue:
          return UIColor(r: 72, g: 138, b: 178, a: 1)
        case .Gray:
          return UIColor(r: 170, g: 170, b: 171, a: 1)
        case .Transparent:
          return UIColor.clear
      }
    }
    
  }
  
  
  // MARK: - Font
  
  enum Font {
    
    case Title
    case Description
    case Number
    case Name
    case Date
    
    var value: UIFont {
      switch self {
        case .Title:
          return UIFont(Lato: .Regular, fontSize: 20)
        case .Description:
          return UIFont(Lato: .Regular, fontSize: 15)
        case .Number:
          return UIFont(Lato: .Bold, fontSize: 17)
        case .Name:
          return UIFont(Lato: .Regular, fontSize: 15)
        case .Date:
          return UIFont(Lato: .Light, fontSize: 12)
      }
    }
    
  }
  
}
