//Основной View в виде таблицы и основная работа приложения
import UIKit
import CoreData


class ViewController: UITableViewController {
    //MARK: - UserDefaults
    enum Keys {
        static var sortType = "sortType"
    }
    
    let defaults = UserDefaults.standard
    
    var sortBy: Bool?
    
    //MARK: - CoreData
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
    private lazy var fetchedResultsController: NSFetchedResultsController<PersonsEntity> = {
        
        let fetchRequest = PersonsEntity.fetchRequest()
        sortBy = UserDefaults.standard.bool(forKey: Keys.sortType)
        print(sortBy)
        let sortDescriptor = NSSortDescriptor(key: "secondNameModel", ascending: sortBy!)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    //MARK: - Main

    let cellFirstNameAndSecondName = "cellFirstNameAndSecondName"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: cellFirstNameAndSecondName)

//        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
//            if let error = error {
//                print("Unable to Load Persistent Store")
//                print("\(error), \(error.localizedDescription)")
//            } else {
//                do {
//                    try self.fetchedResultsController.performFetch()
//                } catch {
//                    print(error)
//                }
//            }
//        }
        
        
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
        let sort =  UIBarButtonItem(title: titleItem, style: .plain, target: self, action: #selector(sortNames))
        navigationItem.rightBarButtonItems = [add, space, sort]
    }
    
    private func changeSort() -> String {
        var title = ""
        sortBy = UserDefaults.standard.bool(forKey: Keys.sortType)
        if sortBy == true {
            title = "Sort \u{2191}"
            sortData(true)
        }else {
            title = "Sort \u{2193}"
            sortData(false)
        }
        return title
    }
    
    @objc private func sortNames() {
        sortBy = !sortBy!
        defaults.set(sortBy, forKey: "sortType")
        print("saved UearDefaults as \(defaults.bool(forKey: "sortType"))")
        setupNavigationController()
    }
    
    @objc private func sortData(_ sort: Bool) {
        let sortDescriptor = NSSortDescriptor(key: "firstNameModel", ascending: sort)
        fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Ошибка при сортировке: \(error.localizedDescription)")
        }
    }
    
    @objc private func addPerson() {
        let addPersonViewController = AddPersonViewController()
        addPersonViewController.id = Int16((fetchedResultsController.fetchedObjects?.count ?? 0) + 1)
        print("Create \(addPersonViewController.id)")
        navigationController?.pushViewController(addPersonViewController, animated: true)
    }
    
//    private func clearCoreData() {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonsEntity")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("Ошибка при очистке данных: \(error)")
//        }
//    }
        
    
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
        
        cell.firstNameLabel.text = "\(person.firstNameModel!) \(person.secondNameModel!)"
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
        personViewController.firstName = person.firstNameModel ?? ""
        personViewController.secondName = person.secondNameModel ?? ""
        personViewController.dateOfBirth = person.dateOfBirthModel ?? ""
        personViewController.country = person.countryModel ?? ""
        personViewController.idChange = person.idModel
        
        print("Will change \(personViewController.idChange!)")
        
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
                let recipes = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                //cell!.textLabel?.text = recipes.firstNameModel
            }
//        case .move:
//            if let indexPath = indexPath {
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//            if let newIndexPath = newIndexPath {
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
                    break
                }
    }
}

// MARK: - Additional Methods
//extension ViewController: PersonViewControllerDelegate {
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//        // Попытка перезагрузить данные каждый раз, когда экран появляется
//        do {
//            try fetchedResultsController.performFetch()
//            tableView.reloadData()
//            didUpdateData()
//            print("Данные успешно загружены: \(fetchedResultsController.fetchedObjects?.count ?? 0) записей")
//        } catch {
//            print("Ошибка загрузки данных: \(error.localizedDescription)")
//        }
//    }
//    
//    func didUpdateData() {
//        print("Reload table")
//    }
//    
//    
//}

//MARK: - Cell setting
class PersonTableViewCell: UITableViewCell {
    let firstNameLabel: UILabel = {
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
        addSubview(firstNameLabel)

        NSLayoutConstraint.activate([
            firstNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
