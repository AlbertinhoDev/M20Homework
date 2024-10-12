//View описания выбранной персоны
import UIKit
import CoreData

class PersonViewController: UIViewController {
    
    weak var delegate: DataUpdateDelegate?
    
    var firstName = ""
    var secondName = ""
    var dateOfBirth = ""
    var country = ""
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(secondNameTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(countryTextField)
        stackView.addArrangedSubview(updateButton)
        return stackView
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let name = UITextField()
        name.text = firstName
        name.textColor = .black
        return name
    }()
    
    private lazy var secondNameTextField: UITextField = {
        let name = UITextField()
        name.text = secondName
        name.textColor = .black
        return name
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if dateOfBirth != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateOfBirthDate = dateFormatter.date(from: dateOfBirth)
            picker.date = dateOfBirthDate!
        }
        picker.datePickerMode = .date
        return picker
    }()
    
    private lazy var countryTextField: UITextField = {
        let country = UITextField()
        country.text = self.country
        country.textColor = .black
        return country
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        return button
    }()
    
    private lazy var changeName = secondNameTextField.text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        updateButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func updateData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateOfBirthDate = datePicker.date
        let dateOfBirthString = dateFormatter.string(from: dateOfBirthDate)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context  = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PersonsEntity> = PersonsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "secondNameModel == %@", changeName!)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let personToUpdate = results.first {
                personToUpdate.firstNameModel = firstNameTextField.text!
                personToUpdate.secondNameModel = secondNameTextField.text!
                personToUpdate.dateOfBirthModel = dateOfBirthString
                personToUpdate.countryModel = countryTextField.text!
                try context.save()
                delegate?.didUpdateData()
            } else {
                print("Персонаж с фамилией \(changeName) не найден")
            }
          } catch {
              print("Ошибка при обновлении данных: \(error)")
          }

        navigationController?.popViewController(animated: true)
    }
}
