//
//  RateDataModel+CoreDataProperties.swift
//  DollarRate
//
//  Created by Кирилл Тила on 25.06.2021.
//
//

import Foundation
import CoreData


extension RateDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RateDataModel> {
        return NSFetchRequest<RateDataModel>(entityName: "RateDataModel")
    }

    @NSManaged public var value: String
    @NSManaged public var date: String

}

extension RateDataModel : Identifiable {

}
