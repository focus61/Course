//
//  Programm.swift
//  Course
//
//  Created by Aleksandr on 12/9/24.
//

import Foundation

final class Programm {
	private let fileManager: FileManager
	private let contactBook: ContactBook
	init() {
		self.fileManager = FileManager()
		self.contactBook = ContactBook()
	}
	func start() {
		setlocale(LC_ALL, "ru_RU.UTF-8")
		setlocale(LC_CTYPE, "ru_RU.UTF-8")
		let menuArray = [
			"Добавить контакт", // 0
			"Редактировать контакт", // 1
			"Удалить контакт", // 2
			"Поиск контакта", // 3
			"Вывод на экран контактов", // 4
			"Сортировка", // 5
			"Сохранить в БД", // 6
			"Загрузить из БД", // 7
			"Выход" // 8
		]
		var isNotesChanged = false
		var isLoadedFromFile = false
		while true {
			let isEmptyNotes = contactBook.notes.isEmpty
			var numberMenuItem = 1
			for item in menuArray {
				if item == "Сохранить в БД" && !isNotesChanged {
					continue
				} else if item == "Сохранить в БД" && isNotesChanged && !isLoadedFromFile && isEmptyNotes {
					continue
				}

				if isEmptyNotes && item == "Редактировать контакт" ||
					isEmptyNotes && item == "Удалить контакт" ||
					isEmptyNotes && item == "Поиск контакта" ||
					isEmptyNotes && item == "Вывод на экран контактов" ||
					isEmptyNotes && item == "Сортировка"
				{ continue }

				if item == menuArray.last {
					print("0 - " + item)
				} else {
					print(String(numberMenuItem) + " - " + item)
				}

				numberMenuItem += 1
			}
			print("Выберите пункт: ", terminator: "")
			let selected = Int(readLine() ?? "") ?? -1
			if isEmptyNotes && !isNotesChanged && !isLoadedFromFile {
				// Только: Добавить/Загрузить/Выход
				switch selected {
				case 0: exit(0)
				case 1:
					contactBook.addNote()
					isNotesChanged = true
				case 2:
					contactBook.notes = fileManager.read()
					isLoadedFromFile = true
				default: print("\nНеверный ввод!")
				}
			} else if isEmptyNotes && isNotesChanged {
				// Только: Добавить/Сохранить/Загрузить/Выход
				switch selected {
				case 0: exit(0)
				case 1: contactBook.addNote()
				case 2: fileManager.write(notes: contactBook.notes)
				case 3:
					contactBook.notes = fileManager.read()
					isLoadedFromFile = true
				default: print("\nНеверный ввод!")
				}
			} else if !isEmptyNotes && !isNotesChanged {
				// Все элементы кроме Сохранить
				switch selected {
				case 0: exit(0)
				case 1:
					contactBook.addNote()
					isNotesChanged = true
				case 2:
					contactBook.edit()
					isNotesChanged = true
				case 3:
					contactBook.deleteNote()
					isNotesChanged = true
				case 4: contactBook.searchNote()
				case 5: contactBook.printNotes(contactBook.notes)
				case 6: contactBook.sortNotes()
				case 7:
					contactBook.notes = fileManager.read()
					isLoadedFromFile = true
				default: print("\nНеверный ввод!")
				}
			} else {
				// Все элементы
				switch selected {
				case 0: exit(0)
				case 1: contactBook.addNote()
				case 2: contactBook.edit()
				case 3: contactBook.deleteNote()
				case 4: contactBook.searchNote()
				case 5: contactBook.printNotes(contactBook.notes)
				case 6: contactBook.sortNotes()
				case 7: fileManager.write(notes: contactBook.notes)
				case 8:
					contactBook.notes = fileManager.read()
					isLoadedFromFile = true
				default: print("\nНеверный ввод!")
				}
			}
			print("")
		}
	}
}

