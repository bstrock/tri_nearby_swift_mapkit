//
//  SectorsEnum.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/19/21.
//

import Foundation

enum SectorsEnum: String, CaseIterable {
    static var stringArray: [String] {
        return [self.AnySector.rawValue, self.Machinery.rawValue, self.WoodProducts.rawValue, self.PrimaryMetals.rawValue, self.Petroleum.rawValue, self.FabricatedMetals.rawValue, self.ComputersandElectronicProducts.rawValue, self.Food.rawValue, self.ElectricUtilities.rawValue, self.MiscellaneousManufacturing.rawValue, self.Chemicals.rawValue, self.TransportationEquipment.rawValue, self.NonmetallicMineralProduct.rawValue, self.ElectricalEquipment.rawValue, self.PlasticsandRubber.rawValue, self.HazardousWaste.rawValue, self.Other.rawValue, self.ChemicalWholesalers.rawValue, self.PetroleumBulkTerminals.rawValue, self.Furniture.rawValue, self.Printing.rawValue, self.Paper.rawValue, self.Leather.rawValue]
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
         MiscellaneousManufacturing = "MiscellaneousManufacturing",
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

