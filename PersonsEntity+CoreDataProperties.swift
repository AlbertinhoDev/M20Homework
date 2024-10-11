import Foundation
import CoreData


extension PersonsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonsEntity> {
        return NSFetchRequest<PersonsEntity>(entityName: "PersonsEntity")
    }

    @NSManaged public var countryModel: String?
    @NSManaged public var dateOfBirthModel: String?
    @NSManaged public var firstNameModel: String?
    @NSManaged public var secondNameModel: String?

}

extension PersonsEntity : Identifiable {

}

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
