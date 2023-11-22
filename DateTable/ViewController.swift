import UIKit

class ViewController: UITableViewController {
    let datesShared = SingletonDatesArray.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Date Table"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRightGesture.direction = .right
        tableView.addGestureRecognizer(swipeRightGesture)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func addTapped() {
        datesShared.addDate(date: Date.now)
        saveDatesData()
        
        fetchData { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .left)
        }
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        let location = gestureRecognizer.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: location) {
            datesShared.delDate(index: indexPath.row)
            saveDatesData()
            
            fetchData { [weak self] in
                self?.tableView.deleteRows(at: [indexPath], with: .right)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesShared.allDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as? DateCell else { fatalError("Could not load custom cell.") }
            
        cell.dateLabel.text = datesShared.allDates[indexPath.row].name
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
//            self?.datesShared.delDate(index: indexPath.row)
//            self?.saveDatesData()
//            
//            self?.fetchData {
//                self?.tableView.deleteRows(at: [indexPath], with: .right)
//            }
//        }
//        return [delAction]
//    }
    
    func fetchData(completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let datesDataToLoad = defaults.object(forKey: "dates") as? Data {
            do {
                datesShared.allDates = try jsonDecoder.decode([DateModel].self, from: datesDataToLoad)
            } catch {
                print("Failed to load dates data.")
            }
        }
        
        completion()
    }
    
    func saveDatesData() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedDatesData = try? jsonEncoder.encode(datesShared.allDates) {
            defaults.setValue(savedDatesData, forKey: "dates")
        }
    }
}

