//
//  Informant_Tests.swift
//  Informant-Tests
//
//  Created by Ty Irvine on 2022-04-05.
//

@testable import Informant
import SwiftUI
import XCTest

class Informant_Tests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		print("--------------- TEST START 🟢 ----------------")
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		print("--------------- TEST FINISH 🔴 ----------------")
	}

	/*
	 func testExample() throws {
	 	// This is an example of a functional test case.
	 	// Use XCTAssert and related functions to verify your tests produce the correct results.
	 	// Any test you write for XCTest can be annotated as throws and async.
	 	// Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
	 	// Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
	 }

	 func testPerformanceExample() throws {
	 	// This is an example of a performance test case.
	 	measure {
	 		// Put the code you want to measure the time of here.
	 	}
	 }
	  */

	// MARK: - Test Helpers

	func printTestName(name: String) {
		print("🛃 TEST - \(name)")
	}

	// MARK: - Tests

	// Tests to make sure the correct metadata can be found for the provided path
	func testStandardSelection() throws {

		printTestName(name: "Standard Selection")

		// Provided selection
		let path = "/Users/tyirvine/Files/Archive/Testing/SF-Display.otf"

		// Measures total execution time
		// Get current app delegate
		let appDelegate = AppDelegate.current()

		// Path bundle
		let paths = Paths(paths: [path], state: .PathAvailable)

		// Get the selection with the provided path
		guard let data = appDelegate.dataController.getSelection(paths)?.data else {
			return XCTAssertEqual(true, false, "Selection is not valid ❌")
		}

		// ---------------- Confirm data is valid ----------------

		let failureMessage = """


		Selection is not valid ❌

		It's possible size is disabled in settings. Make sure it's enabled and try again.

		"""

		XCTAssertEqual(data.data[String.keyShowSize], "2.3 MB", failureMessage)
	}
}
