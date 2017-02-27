
import UIKit

class RepositoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepositoryViewModelDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  fileprivate var currentPage = 0
  fileprivate var isLoading = true
  fileprivate var isConnectionErrorShowed = false
  fileprivate var repositoriesViewModel = [RepositoryViewModel]()
  fileprivate var repositoryVM: RepositoryViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
    self.configureTableView()
    self.customizeInterface()
    self.getRepositories()
  }
  
  fileprivate func configure() {
    self.repositoryVM = RepositoryViewModel()
    self.repositoryVM.delegate = self
  }
  
  fileprivate func customizeInterface() {
    self.navigationItem.title = NSLocalizedString("repositoryNavTitle", comment: "")
    self.navigationItem.backBarButtonItem = UIBarButtonItem().clear()
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  fileprivate func configureTableView() {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 120
    
    let nib = UINib(nibName: "RepositoryCell", bundle: Bundle.main)
    self.tableView.register(nib, forCellReuseIdentifier: "repoCell")
    
  }
  
  fileprivate func getRepositories() {
    self.isLoading = true
    self.repositoryVM.getRepositories(self.currentPage + 1)
  }
  
  
  // MARK: - RepositoryViewModelDelegate
  
  func repositoriesRequestSuccess(_ repositoriesViewModel: [RepositoryViewModel]) {
    
    guard repositoriesViewModel.count > 0 else {
      self.isLoading = false
      self.isConnectionErrorShowed = false
      self.spinner.stopAnimating()
      return
    }
    
    self.repositoriesViewModel += repositoriesViewModel
    self.tableView.reloadData()
    self.currentPage += 1
    self.isLoading = false
    self.isConnectionErrorShowed = false
    self.spinner.stopAnimating()
    
  }
  
  func repositoriesRequestError(_ statusCode: Int, _ response: Any?, _ error: Error?) {
    
    if statusCode == Api.statusCodes.disconnected.rawValue && !self.isConnectionErrorShowed {
      Alert.connectionError()
      self.isConnectionErrorShowed = true
    }
    
    self.isLoading = false
    self.spinner.stopAnimating()
    
  }
  
  
  // MARK: - UITableView Delegates
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repositoriesViewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let repository = self.repositoriesViewModel[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepositoryCell
    cell.nameLabel.text = repository.name
    cell.descriptionLabel.text = repository.description
    cell.forksLabel.text = repository.forks
    cell.favoritesLabel.text = repository.favorites
    cell.ownerNameLabel.text = repository.ownerNick
    cell.ownerAvatarImageView.load(url: repository.ownerAvatarUrl)
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row >= (self.repositoriesViewModel.count - 10) && !self.isLoading {
      self.getRepositories()
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let pullViewController = mainStoryboard.instantiateViewController(withIdentifier: "pullRequestVC") as! PullRequestListViewController
    let repositorySelected = self.repositoriesViewModel[indexPath.row]
    pullViewController.repositoryName = repositorySelected.name
    pullViewController.repositoryOwner = repositorySelected.ownerNick
    self.navigationController?.pushViewController(pullViewController, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
}
