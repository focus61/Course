//
//  Note.swift
//  Course
//
//  Created by Aleksandr on 11/18/24.
//

struct Note {
	var firstName: String = ""
	var lastName: String = ""
	var phoneNumber: String = ""
	var birthday: [Int] = []
	init(firstName: String, lastName: String, phoneNumber: String, birthday: [Int]) {
		self.firstName = firstName
		self.lastName = lastName
		self.phoneNumber = phoneNumber
		self.birthday = birthday
	}
	func toJson() -> [String: Any] {
		[
			"firstName": firstName,
			"lastName": lastName,
			"phoneNumber": phoneNumber,
			"birthday": birthday
		]
	}
}
