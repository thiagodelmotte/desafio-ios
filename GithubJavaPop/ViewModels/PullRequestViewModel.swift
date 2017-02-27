
import Foundation

protocol PullRequestViewModelDelegate: class {
  func pullRequestsRequestSuccess(_ pullRequestsViewModel: [PullRequestViewModel])
  func pullRequestsRequestError(_ statusCode: Int, _ response: Any?, _ error: Error?)
}

class PullRequestViewModel {
  
  enum prState: String {
    case open = "open"
    case closed = "closed"
  }
  
  weak var delegate: PullRequestViewModelDelegate?
  fileprivate var pullRequest: PullRequest!
  
  convenience init(_ pullRequest: PullRequest) {
    self.init()
    self.pullRequest = pullRequest
  }
  
  var title: String {
    return self.pullRequest.title
  }
  
  var body: String {
    return self.pullRequest.body
  }
  
  var date: String {
    let date = Date().dateFromString(self.pullRequest.date)
    return date.convertToLongString()
  }
  
  var url: URL {
    return URL(string: self.pullRequest.url)!
  }
  
  var state: prState {
    return prState(rawValue: self.pullRequest.state)!
  }
  
  var ownerNick: String {
    return self.pullRequest.ownerNick
  }
  
  var ownerAvatarUrl: URL {
    return URL(string: self.pullRequest.ownerAvatarUrl)!
  }
  
  func getPullRequests(_ owner: String, repository: String) {
    
    PullRequestApi.getPullRequests(owner, repository: repository, success: { pullRequests in
      
      var pullRequestsViewModel = [PullRequestViewModel]()
      
      for pullRequest in pullRequests {
        let pullRequestViewModel = PullRequestViewModel(pullRequest)
        pullRequestsViewModel.append(pullRequestViewModel)
      }
      
      self.delegate?.pullRequestsRequestSuccess(pullRequestsViewModel)
      
    }) { (statusCode, response, error) in
      
      self.delegate?.pullRequestsRequestError(statusCode, response, error)
      
    }
    
  }
  
  class func getTotalStates(_ pulls: [PullRequestViewModel]) -> (open: Int, closed: Int) {
    
    var totalOpen = 0
    var totalClosed = 0
    
    for pull in pulls {
      switch pull.state {
        case .open:
          totalOpen += 1
        case .closed:
          totalClosed += 1
      }
    }
    
    return (totalOpen, totalClosed)
    
  }
  
}
