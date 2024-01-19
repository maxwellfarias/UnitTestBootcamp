//
//  NewMockDataService_Tests.swift
//  UnitTestBootcamp_Tests
//
//  Created by Maxwell Santos Farias on 17/01/24.
//

import XCTest
@testable import UnitTestBootcamp
import Combine

final class NewMockDataService_Tests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func test_NewMockDataService_init_doesSetValuesCorrectly() {
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]
        
        let dataService: NewMockDataService = NewMockDataService(items: items)
        let dataService2: NewMockDataService = NewMockDataService(items: items2)
        let dataService3: NewMockDataService = NewMockDataService(items: items3)
        
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items, items3)
    }
    
    func test_NewMockDataService_donwloadItemWithEscaping_doesReturnValues() {
        let dataService: NewMockDataService = NewMockDataService(items: nil)
        
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_donwloadItemWithCombine_doesReturnValues() {
        let dataService: NewMockDataService = NewMockDataService(items: nil)
        
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch(completion) {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                
            }
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_donwloadItemWithCombine_doesFail() {
        let dataService: NewMockDataService = NewMockDataService(items: [])
        
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does throw URLError.badServerResponse")
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch(completion) {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    
                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                
            }
            .store(in: &cancellables)
        
        wait(for: [expectation, expectation2], timeout: 5)
    }
}
