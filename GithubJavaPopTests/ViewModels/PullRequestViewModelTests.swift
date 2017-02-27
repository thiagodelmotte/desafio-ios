
import XCTest

class PullRequestViewModelTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testPullRequestViewModel() {
    
    let arenaPR = PullRequest("feature/video", body: "video framework changed", date: "2017-02-03T01:35:00Z", url: "http://arena.im/pr-video", state: "open", ownerNick: "arena.im", ownerAvatarUrl: "http://arena.im/av.png")
    
    let prViewModel = PullRequestViewModel(arenaPR)
    
    XCTAssertEqual("feature/video", prViewModel.title)
    XCTAssertEqual("video framework changed", prViewModel.body)
    XCTAssertEqual(URL(string: "http://arena.im/pr-video"), prViewModel.url)
    XCTAssertEqual(PullRequestViewModel.prState.open, prViewModel.state)
    XCTAssertEqual("arena.im", prViewModel.ownerNick)
    XCTAssertEqual(URL(string: "http://arena.im/av.png"), prViewModel.ownerAvatarUrl)
    XCTAssertNotEqual("2017-02-03T01:35:00Z", prViewModel.date)
    
  }
  
  func testTotalStates() {
    
    let arenaPR1 = PullRequest("feature/video", body: "video framework changed", date: "2017-02-03T01:35:00Z", url: "http://arena.im/pr-video", state: "open", ownerNick: "arena.im", ownerAvatarUrl: "http://arena.im/av.png")
    
    let prViewModel1 = PullRequestViewModel(arenaPR1)
    
    let arenaPR2 = PullRequest("feature/image", body: "image framework changed", date: "2017-01-03T01:35:00Z", url: "http://arena.im/pr-image", state: "closed", ownerNick: "arena.im", ownerAvatarUrl: "http://arena.im/av.png")
    
    let prViewModel2 = PullRequestViewModel(arenaPR2)
    
    let total = PullRequestViewModel.getTotalStates([prViewModel1, prViewModel2])
    let totalOpenTest = 1
    let totalClosedTest = 1
    let totalOpenTestError = 2
    let totalClosedTestError = 4
    
    XCTAssertEqual(totalOpenTest, total.open)
    XCTAssertEqual(totalClosedTest, total.closed)
    XCTAssertNotEqual(totalOpenTestError, total.open)
    XCTAssertNotEqual(totalClosedTestError, total.closed)
    
  }
  
}
