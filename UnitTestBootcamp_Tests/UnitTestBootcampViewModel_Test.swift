//
//  UnitTestBootcampViewModel_Test.swift
//  UnitTestBootcamp_Tests
//
//  Created by Maxwell Santos Farias on 15/01/24.
//
import Combine
import XCTest
//@testable import is used to access the UnitTestBootcamp bundle
@testable import UnitTestBootcamp

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//test_[struct or class]_[variable or function]_[expected result]

//Testing Structure: Given, When, Then

final class UnitTestBootcampViewModel_Test: XCTestCase {
    var viewModel: UnitTestBootcampViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestBootcampViewModel(isPremium: Bool.random())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func test_UnitTestBootcampViewModel_isPremium_shouldBeTrue() {
        //        Given
        let userIsPremium: Bool = true
        
        //        When
        let vm = UnitTestBootcampViewModel(isPremium: userIsPremium)
        
        //        Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestBootcampViewModel_isPremium_shouldBeFalse() {
        //        Given
        let userIsPremium: Bool = false
        
        //        When
        let vm = UnitTestBootcampViewModel(isPremium: userIsPremium)
        
        //        Then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestBootcampViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            //        Given
            let userIsPremium: Bool = Bool.random()
            
            //        When
            let vm = UnitTestBootcampViewModel(isPremium: userIsPremium)
            
            //        Then
            XCTAssertEqual(userIsPremium, vm.isPremium)
        }
    }
    
    func test_UnitTestBootcampViewModel_dataArray_shouldBeEmpty() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestBootcampViewModel_dataArray_shouldAddItems() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let item: String = "hello"
        
        vm.addItem(item: item)
        
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray[0], item)
        XCTAssertEqual(vm.dataArray.count, 1)
    }
    
    func test_UnitTestBootcampViewModel_dataArray_shouldNotAddBlankString() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let loopCount = Int.random(in: 0..<20)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        XCTAssertEqual(vm.dataArray.count, loopCount)
    }
    
    func test_UnitTestBootcampViewModel_dataArray_shouldNotAddBlankString2() {
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        let loopCount = Int.random(in: 0..<20)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        XCTAssertEqual(vm.dataArray.count, loopCount)
    }
    
    func test_UnitTestBootcampViewModel_selectedItem_shouldStartAsNil() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestBootcampViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let item = UUID().uuidString
        
        vm.addItem(item: item)
        vm.selectItem(item: UUID().uuidString)
        
        
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestBootcampViewModel_selectedItem_shouldBeSelected() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let item = UUID().uuidString
        
        vm.addItem(item: item)
        vm.selectItem(item: item)
        
        XCTAssertEqual(vm.selectedItem, item)
    }
    
    func test_UnitTestBootcampViewModel_selectedItem_shouldBeSelected_stress() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let loopCount: Int = Int.random(in: 1..<50)
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
        }
        let randomItem: String = vm.dataArray.randomElement() ?? ""
        vm.selectItem(item: randomItem)
        
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_UnitTestBootcampViewModel_saveItem_shouldThrowError_itemNotFound() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let loopCount: Int = Int.random(in: 1..<50)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw item not found") {error in
            let returnedError = error as? UnitTestBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestBootcampViewModel.DataError.itemNotFound)
        }
    }
    
    func test_UnitTestBootcampViewModel_saveItem_shouldThrowError_noData() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let loopCount: Int = Int.random(in: 1..<50)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestBootcampViewModel.DataError.noData)
        }
    }
    
    func test_UnitTestBootcampViewModel_saveItem_shouldSaveItem() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let loopCount: Int = Int.random(in: 1..<50)
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
        }
        let randomItem: String = vm.dataArray.randomElement() ?? ""
        
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
    }

    func test_UnitTestBootcampViewModel_downloadWithEscaping_shouldReturnItems() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds.")
        
        vm.$dataArray
            .dropFirst() //dropFirst was used because the first value that the dataArray receives is an empty array
            .sink { _ in
                expectation.fulfill()
//      Whenever the dataArray changes, the .sink will be called And in this way we inform you that the "expectation" has been fulfilled.
            }
            .store(in: &cancellables) //You need to store this subscript somewhere. So it will be stored in cancelables
        vm.downloadWithEscaping()
        
        wait(for: [expectation], timeout: 5) // Wait for 'expectation' to be met within a certain time to start running the tests
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestBootcampViewModel_downloadWithCombine_shouldReturnItems() {
        let vm = UnitTestBootcampViewModel(isPremium: Bool.random())
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds.")
        
        vm.$dataArray
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        vm.downloadWithCombine()
        
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_NewMockDataService_donwloadItemWithCombine_doesReturnItems2() {
        let items: [String] = Array(repeating: UUID().uuidString, count: 5)
        let dataService: NewMockDataService = NewMockDataService(items: items)
        let vm: UnitTestBootcampViewModel = UnitTestBootcampViewModel(isPremium: Bool.random(), dataService: dataService)
        
        let expectation = XCTestExpectation(description: "Should return items after a seconds.")
        vm.$dataArray
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        vm.downloadWithCombine()
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(vm.dataArray, items)
    }
}
