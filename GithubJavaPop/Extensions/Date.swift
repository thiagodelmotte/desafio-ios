
import Foundation

extension Date {
  
  func convertToStringUsingFormat(format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  func convertToLongString() -> String {
    return convertToStringUsingFormat(format: "EE, d LLL yyyy, HH:mm")
  }
  
  func convertToString() -> String {
    return convertToStringUsingFormat(format: "yyyy-MM-dd")
  }
  
  func dateFromString(_ dateString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter.date(from: dateString)!
  }
  
}
