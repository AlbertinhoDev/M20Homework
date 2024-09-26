//View добавления новой персоны
import UIKit
import CoreData

class AddPersonViewController: UIViewController, NSFetchedResultsControllerDelegate {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.addArrangedSubview(firstNameLabel)
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(secondNameLabel)
        stackView.addArrangedSubview(secondNameTextField)
        stackView.addArrangedSubview(dateOfBirthLabel)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(countryTextField)
        stackView.addArrangedSubview(saveButton)
        return stackView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let name = UILabel()
        name.text = "First name:"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var secondNameLabel: UILabel = {
        let name = UILabel()
        name.text = "Second name:"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
        let name = UILabel()
        name.text = "Date of birth:"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var countryLabel: UILabel = {
        let name = UILabel()
        name.text = "Country:"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var firstNameTextField = UITextField()
    private lazy var secondNameTextField = UITextField()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    private lazy var countryTextField = UITextField()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.isHidden = true
        return button
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        countryTextField.delegate = self
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        firstNameTextField.borderStyle = .roundedRect
        secondNameTextField.borderStyle = .roundedRect
        countryTextField.borderStyle = .roundedRect
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        secondNameTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        countryTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    @objc func saveData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateOfBirthDate = datePicker.date
        let dateOfBirthString = dateFormatter.string(from: dateOfBirthDate)
        
        let newEnity = PersonsEntity(context: context)
        
        newEnity.firstName =  firstNameTextField.text!
        newEnity.secondName =  secondNameTextField.text!
        newEnity.dateOfBirth =  dateOfBirthString
        newEnity.country =  countryTextField.text!
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохраения: \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddPersonViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextField()
    }
    
    private func checkTextField() {
        if (firstNameTextField.text != "") && (secondNameTextField.text != "") && (countryTextField.text != "") {
            saveButton.isHidden = false
        } else {
            saveButton.isHidden = true
        }
    }
}
