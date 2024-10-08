//Основной View в виде таблицы и основная работа приложения
import UIKit
import CoreData

class ViewController: UITableViewController {
    //MARK: - UserDefaults
    enum TypeSort {
        static var sortType = true
    }
    //MARK: - CoreData
    private let persistentContainer = NSPersistentContainer(name: "Model")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<PersonsEntity> = {
        let fetchRequest = PersonsEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "secondName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    //MARK: - Main

    let cellFirstNameAndSecondName = "cellFirstNameAndSecondName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: cellFirstNameAndSecondName)
        setupView()
        
//        clearCoreData()
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Persons"
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10
        let add = UIBarButtonItem(title: "Add +", style: .plain, target: self, action: #selector(addPerson))
        let titleItem = changeSort()
        let filter =  UIBarButtonItem(title: titleItem, style: .plain, target: self, action: #selector(filterNames))
        navigationItem.rightBarButtonItems = [add, space, filter]
    }
    
    private func changeSort() -> String {
        var title = ""
        if TypeSort.sortType == true {
            title = "Filter \u{2191}"
        }else {
            title = "Filter \u{2193}"
        }
        return title
    }
    
    @objc private func filterNames() {
        TypeSort.sortType = !TypeSort.sortType
        setupNavigationController()
    }
    
    @objc private func addPerson() {
        let addPersonViewController = AddPersonViewController()
        navigationController?.pushViewController(addPersonViewController, animated: true)
    }
    
    private func clearCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonsEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Ошибка при очистке данных: \(error)")
        }
    }
    
    //MARK: - TableView setting
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellFirstNameAndSecondName, for: indexPath) as! PersonTableViewCell
        
        cell.firstNameSecondNameLabel.text = (person.firstName ?? "") + " " + (person.secondName ?? "")
        return cell

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = fetchedResultsController.object(at: indexPath)
            persistentContainer.viewContext.delete(person)
            try? persistentContainer.viewContext.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personViewController = PersonViewController()
        let person = fetchedResultsController.object(at: indexPath)
        personViewController.firstName = person.firstName ?? ""
        personViewController.secondName = person.secondName ?? ""
        personViewController.dateOfBirth = person.dateOfBirth ?? ""
        personViewController.country = person.country ?? ""
        
        self.navigationController?.pushViewController(personViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CoreData setting
extension ViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
//                let person = fetchedResultsController.object(at: indexPath)
//                let cell = tableView.cellForRow(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
//                let cell = PersonTableViewCell()
//                cell.firstNameSecondNameLabel.text = person.firstName! + " " + person.secondName!
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

//MARK: - Cell setting
class PersonTableViewCell: UITableViewCell {
    let firstNameSecondNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(firstNameSecondNameLabel)

        NSLayoutConstraint.activate([
            firstNameSecondNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstNameSecondNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstNameSecondNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
