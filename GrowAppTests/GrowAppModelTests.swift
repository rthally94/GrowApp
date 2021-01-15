//
//  GrowAppTests.swift
//  GrowAppTests
//
//  Created by Ryan Thally on 1/15/21.
//

import XCTest
@testable import GrowApp

class GrowAppModelTests: XCTestCase {
    func test_initialState_whenModelIsInitialized_withNoData_getAllPlantsIsEmpty() {
        let sut = GrowAppModel.preview
        XCTAssertTrue(sut.getPlants().isEmpty)
    }
    
    func test_initialState_whenModelIsInitialized_andOnePlantIsAdded_theNewPlantIsAdded() {
        let sut = GrowAppModel.preview
        
        let newPlant = Plant()
        sut.addPlant(newPlant)
        
        XCTAssertEqual(newPlant, sut.getPlants()[0])
    }
    
    func test_whenPlantsIsEmpty_andAPlantIsDeleted_NoErrorOccurs() {
        let sut = GrowAppModel.preview
        XCTAssertTrue(sut.getPlants().isEmpty)
        
        sut.deletePlant(Plant())
    }
    
    func test_whenPlantsHasOnePlant_andAPlantIsDeleted_PlantIsRemoved() {
        let sut = GrowAppModel.preview
        let testPlant = Plant()
        sut.addPlant(testPlant)
        
        XCTAssertEqual(sut.getPlants().count, 1)
        
        sut.deletePlant(testPlant)
        
        XCTAssertTrue(sut.getPlants().isEmpty)
    }
}
