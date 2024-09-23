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
        stackView.addArrangedSubview(firstNameLabel)
        stackView.addArrangedSubview(secondNameLabel)
        stackView.addArrangedSubview(dateOfBirthLabel)
        stackView.addArrangedSubview(countryLabel)
        return stackView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let name = UILabel()
        name.text = "First name: \(firstName)"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var secondNameLabel: UILabel = {
        let name = UILabel()
        name.text = "Second name: \(secondName)"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
        let name = UILabel()
        name.text = "Date of birth: \(dateOfBirth)"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var countryLabel: UILabel = {
        let name = UILabel()
        name.text = "Country: \(country)"
        name.textColor = .black
        name.numberOfLines = 0
        return name
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
