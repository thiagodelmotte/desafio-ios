
import Foundation

typealias completionRepositorySuccess = (_ repositories: [Repository]) -> Void
typealias completionRepositoryFailure = (_ statusCode: Int, _ response: Any?, _ error: Error?) -> Void

class RepositoryApi: Api {
  
  class func getRepositories(_ page: Int, success: @escaping completionRepositorySuccess, failure: @escaping completionRepositoryFailure) {
    
    let url = "\(Bundle.main.apiEntrypoint)/search/repositories?q=language:Java&sort=stars&page=\(page)"
    
    super.request(.GET, url: url, success: { (statusCode, response) in
      
      var repositories = [Repository]()
      let itemsArray = response.object["items"].array
      
      guard itemsArray != nil else {
        success([])
        return
      }
        
      let items = JSONSerializer(itemsArray!)
      
      for item in items.object {
        let json = JSONSerializer(item.1.object)
        let repository = RepositoryDecode.map(json)
        repositories.append(repository)
      }
      
      success(repositories)
      
    }) { (statusCode, response, error) in
      
      failure(statusCode, response, error)
      
    }
  }
  
}
