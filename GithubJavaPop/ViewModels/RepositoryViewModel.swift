
import Foundation

protocol RepositoryViewModelDelegate: class {
  func repositoriesRequestSuccess(_ repositoriesViewModel: [RepositoryViewModel])
  func repositoriesRequestError(_ statusCode: Int, _ response: Any?, _ error: Error?)
}

class RepositoryViewModel {
  
  weak var delegate: RepositoryViewModelDelegate?
  fileprivate var repository: Repository!
  
  convenience init(_ repository: Repository) {
    self.init()
    self.repository = repository
  }
  
  var name: String {
    return self.repository.name
  }
  
  var description: String {
    return self.repository.description
  }
  
  var forks: String {
    return String(self.repository.forks)
  }
  
  var favorites: String {
    return String(self.repository.favorites)
  }
  
  var ownerNick: String {
    return self.repository.ownerNick
  }
  
  var ownerAvatarUrl: URL {
    return URL(string: self.repository.ownerAvatarUrl)!
  }
  
  func getRepositories(_ page: Int) {
    
    RepositoryApi.getRepositories(page, success: { repositories in
      
      var repositoriesViewModel = [RepositoryViewModel]()
      
      for repository in repositories {
        let repositoryViewModel = RepositoryViewModel(repository)
        repositoriesViewModel.append(repositoryViewModel)
      }
      
      self.delegate?.repositoriesRequestSuccess(repositoriesViewModel)
      

    }) { (statusCode, response, error) in
      
      self.delegate?.repositoriesRequestError(statusCode, response, error)
      
    }
    
  }
  
}
