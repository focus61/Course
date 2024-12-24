//
//  FileManager.swift
//  Course
//
//  Created by Aleksandr on 11/18/24.
//

import Foundation

final class FileManager {

	private let path = "/Users/Aleksandr/Developer/Course/Course/Resources/input.json"

	func read() -> [Note] {
		let fileUrl = URL(fileURLWithPath: path)
		guard let data = try? Data(contentsOf: fileUrl),
			  let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			  let contactBook = object["ContactBook"] as? [[String: Any]]
			else { return [] }
		print("")
		print("Данные из файла получены")
		return parseNotes(from: contactBook)
	}

	func write(notes: [Note]) {
		let dict = toJSON(notes: notes)
		let jsonObject = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
		let fileURL = URL(fileURLWithPath: path)
		do {
			try jsonObject?.write(to: fileURL)
			print("")
			print("Данные в файле обновлены")
		} catch {
			print("Ошибка записи в файл")
		}
	}

	private func parseNotes(from notesJson: [[String: Any]]) -> [Note] {
		let nameKey = "firstName"
		let lastNameKey = "lastName"
		let phoneKey = "phoneNumber"
		let birthdayKey = "birthday"
		var notesArray: [Note] = []
		for element in notesJson {
			if let name = element[nameKey] as? String,
			   let lastName = element[lastNameKey] as? String,
			   let phone = element[phoneKey] as? String,
			   let birthday = element[birthdayKey] as? [Int] {
				notesArray.append(Note(firstName: name, lastName: lastName, phoneNumber: phone, birthday: birthday))
			}
		}
		return notesArray
	}

	private func toJSON(notes: [Note]) -> [String: Any] {
		var notesJSON: [[String: Any]] = []
		for note in notes {
			notesJSON.append(note.toJson())
		}
		return ["Notes": notesJSON]
	}
}
