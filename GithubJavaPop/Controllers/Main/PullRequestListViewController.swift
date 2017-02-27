
import UIKit

class PullRequestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PullRequestViewModelDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var prStatusLabel: UILabel!
  @IBOutlet weak var prStatusHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  fileprivate var pullRequestsViewModel = [PullRequestViewModel]()
  fileprivate var pullRequestVM: PullRequestViewModel!
  var repositoryName: String!
  var repositoryOwner: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
    self.configureTableView()
    self.customizeInterface()
    self.getPullRequests()
  }
  
  fileprivate func configure() {
    self.pullRequestVM = PullRequestViewModel()
    self.pullRequestVM.delegate = self
  }
  
  fileprivate func customizeInterface() {
    self.navigationItem.title = self.repositoryName
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = StyleGuide.Color.Gray.value
  }
  
  fileprivate func configureTableView() {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 152
    
    let nib = UINib(nibName: "PullRequestCell", bundle: Bundle.main)
    self.tableView.register(nib, forCellReuseIdentifier: "prCell")
    
  }
  
  fileprivate func getPullRequests() {
    self.pullRequestVM.getPullRequests(self.repositoryOwner, repository: self.repositoryName)
  }
  
  fileprivate func setTotalState() {
    self.prStatusLabel.attributedText = self.getTotalState()
    self.animateTotalState()
  }
  
  fileprivate func getTotalState() -> NSAttributedString {
  
    let totalState = PullRequestViewModel.getTotalStates(self.pullRequestsViewModel)
    let totalOpenCharacters = String(describing: totalState.open).characters.count + 8

    let attributes = [[
      "attributes": [
        NSFontAttributeName: StyleGuide.Font.Number.value,
        NSForegroundColorAttributeName: StyleGuide.Color.Orange.value
      ],
      "location": 0,
      "length": totalOpenCharacters
    ],[
      "attributes": [
        NSFontAttributeName: StyleGuide.Font.Number.value,
        NSForegroundColorAttributeName: StyleGuide.Color.Black.value
      ],
      "location": totalOpenCharacters,
      "length": 0
    ]]

    return "\(totalState.open) opened / \(totalState.closed) closed".attributedWithRange(attributes)
    
  }
  
  fileprivate func animateTotalState() {
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.prStatusHeightConstraint.constant = 50
      self.view.layoutIfNeeded()
    }) { finished in
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
        self.prStatusHeightConstraint.constant = 45
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
    
  }
  
  
  // MARK: - PullRequestViewModelDelegate
  
  func pullRequestsRequestSuccess(_ pullRequestsViewModel: [PullRequestViewModel]) {
    self.pullRequestsViewModel = pullRequestsViewModel
    self.setTotalState()
    self.tableView.reloadData()
    self.spinner.stopAnimating()
  }
  
  func pullRequestsRequestError(_ statusCode: Int, _ response: Any?, _ error: Error?) {
    Alert.connectionError()
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  
  // MARK: - UITableView Delegates
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.pullRequestsViewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let pullRequest = self.pullRequestsViewModel[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "prCell", for: indexPath) as! PullRequestCell
    cell.titleLabel.text = pullRequest.title
    cell.bodyLabel.text = pullRequest.body
    cell.ownerNameLabel.text = pullRequest.ownerNick
    cell.dateLabel.text = pullRequest.date
    cell.ownerAvatarImageView.load(url: pullRequest.ownerAvatarUrl)
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let pullRequest = self.pullRequestsViewModel[indexPath.row]
    SafariHelper().openUrl(pullRequest.url, viewController: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
