//View описания выбранной персоны
import UIKit

class PersonViewController: UIViewController {
    
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
        stackView.addArrangedSubview(saveButton)
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
               
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func saveData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateOfBirthDate = datePicker.date
        let dateOfBirthString = dateFormatter.string(from: dateOfBirthDate)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context  = appDelegate.persistentContainer.viewContext
        
        let newEnity = PersonsEntity(context: context)
        
        newEnity.firstNameModel =  firstNameTextField.text!
        newEnity.secondNameModel =  secondNameTextField.text!
        newEnity.dateOfBirthModel =  dateOfBirthString
        newEnity.countryModel =  countryTextField.text!
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохраения: \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
}
