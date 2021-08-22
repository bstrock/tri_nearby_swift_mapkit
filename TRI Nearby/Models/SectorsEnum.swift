//
//  SectorsEnum.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/19/21.
//

import Foundation

enum SectorsEnum: String, CaseIterable {
    static var stringArray: [String] {
        // this array is used to check presence by the query filter routine
        [
             AnySector.rawValue,
             Machinery.rawValue,
             WoodProducts.rawValue,
             PrimaryMetals.rawValue,
             Petroleum.rawValue,
             FabricatedMetals.rawValue,
             ComputersandElectronicProducts.rawValue,
             Food.rawValue,
             ElectricUtilities.rawValue,
             MiscellaneousManufacturing.rawValue,
             Chemicals.rawValue,
             TransportationEquipment.rawValue,
             NonmetallicMineralProduct.rawValue,
             ElectricalEquipment.rawValue,
             PlasticsandRubber.rawValue,
             HazardousWaste.rawValue,
             Other.rawValue,
             ChemicalWholesalers.rawValue,
             PetroleumBulkTerminals.rawValue,
             Furniture.rawValue,
             Printing.rawValue,
             Paper.rawValue,
             Leather.rawValue
        ]
    }

    case AnySector = "Any Sector",
         Machinery = "Machinery",
         WoodProducts = "Wood Products",
         PrimaryMetals = "Primary Metals",
         Petroleum = "Petroleum",
         FabricatedMetals = "Fabricated Metals",
         ComputersandElectronicProducts = "Computers and Electronic Products",
         Food = "Food",
         ElectricUtilities = "Electric Utilities",
         MiscellaneousManufacturing = "Miscellaneous Manufacturing",
         Chemicals = "Chemicals",
         TransportationEquipment = "Transportation Equipment",
         NonmetallicMineralProduct = "Nonmetallic Mineral Product",
         ElectricalEquipment = "Electrical Equipment",
         PlasticsandRubber = "Plastics and Rubber",
         HazardousWaste = "Hazardous Waste",
         Other = "Other",
         ChemicalWholesalers = "Chemical Wholesalers",
         PetroleumBulkTerminals = "Petroleum Bulk Terminals",
         Furniture = "Furniture",
         Printing = "Printing",
         Paper = "Paper",
         Leather = "Leather"


}

