import Foundation
import CoreData


extension PersonsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonsEntity> {
        return NSFetchRequest<PersonsEntity>(entityName: "PersonsEntity")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var secondName: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var country: String?

}

extension PersonsEntity : Identifiable {

}
