//
//  ContactBook.swift
//  Course
//
//  Created by Aleksandr on 11/18/24.
//
import Foundation.NSLocale

final class ContactBook {

	/// Значение вводимое с клавиатуры
	private enum EnterValue {
		/// Пользователь вводит имя/фамилию
		case name
		/// Пользователь вводит номер телефона
		case phoneNumber
		/// Пользователь вводит дату рождения
		case birthday
	}

	/// Порядок сортировки
	private enum SortOrder {
		/// По возрастанию
		case ascending
		/// По убыванию
		case descending
	}

	/// Поле сортировки
	private enum SortField {
		/// По имени
		case firstName
		/// По фамилии
		case lastName
		/// По дате рождения
		case date
		/// По номеру телефона
		case number
	}

	var notes: [Note] = []

	// MARK: 1: Добавление
	/// Создание нового контакта
	/// - Returns: Модель контакта
	func addNote() {
		print("")
		let lastNameDescription = addValue(with: "Введите фамилию: ", value: .name)
		let firstNameDescription = addValue(with: "Введите имя: ", value: .name)
		let phoneNumberDescription = addValue(with: "Введите номер телефона: ", value: .phoneNumber)
		let birthdayDescription = addValue(with: "Введите дату рождения в формате ДД.ММ.ГГГГ: ", value: .birthday)
		let birthdayArray = birthdayArray(birthdayDescription)
		let note = Note(
			firstName: firstNameDescription,
			lastName: lastNameDescription,
			phoneNumber: phoneNumberDescription,
			birthday: birthdayArray
		)
		notes.append(note)
		print("")
		print("Контакт добавлен!")
	}

	// MARK: 2: Редактирование
	func edit() {
		print("")
		print("Нужно ввести фамилию и дату рождения для редактирования нужного контакта")
		let lastName = addValue(with: "Введите фамилию: ", value: .name)
		let birthday = addValue(with: "Введите дату рождения в формате ДД.ММ.ГГГГ: ", value: .birthday)
		var index = 0
		for note in notes {
			let birthdayDescription = birthdayDescription(note: note)
			if note.lastName == lastName && birthdayDescription == birthday {
				notes[index] = editNoteMenu(note: note)
				print("")
				print("Контакт отредактирован!")
				return
			}
			index += 1
		}
		print("")
		print("Контакт не найден!", terminator: "\n")
	}

	// MARK: 3: Удаление
	func deleteNote() {
		print("")
		print("Нужно ввести фамилию и дату рождения для удаления нужного контакта")
		let lastName = addValue(with: "Введите фамилию: ", value: .name)
		let birthday = addValue(with: "Введите дату рождения в формате ДД.ММ.ГГГГ: ", value: .birthday)
		var removeIndex = -1
		var index = 0
		for note in notes {
			let birthdayDescription = birthdayDescription(note: note)

			if note.lastName == lastName && birthdayDescription == birthday {
				removeIndex = index
			}
			index += 1
		}

		if removeIndex != -1 {
			notes.remove(at: removeIndex)
			print("")
			print("Контакт удален!")
		} else {
			print("")
			print("Контакт не найден!")
		}
	}

	// MARK: 4: Поиск по фамилии и показ контактов
	func searchNote() {
		print("")
		print("Нужно ввести фамилию для поиска контактов")
		let lastName = addValue(with: "Введите фамилию: ", value: .name)

		var resultNotes: [Note] = []
		for note in notes {
			if lastName == note.lastName {
				resultNotes.append(note)
			}
		}
		if resultNotes.isEmpty {
			print("Контактов с данной фамилией не найдено")
		} else {
			beatifulPrint(resultNotes)
		}
	}

	// MARK: 5: Вывод на экран контактов
	func printNotes(_ notes: [Note]) {
		print("")
		if notes.isEmpty {
			print("Список пуст")
			print("")
		} else {
			beatifulPrint(notes)
		}
	}

	// MARK: 6: Сортировка
	func sortNotes() {
		var sortedNotes = notes
		while true {
			print("")
			print("1: Сортировать по имени")
			print("2: Сортировать по фамилии")
			print("3: Сортировать по дате")
			print("4: Сортировать по номеру телефона")
			print("5: Вывод на экран результата")
			print("6: Сохранить и выйти")
			print("0: Выйти без сохранения")
			print("Выберите пункт: ", terminator: "")
			let selectedField = Int(readLine() ?? "") ?? -1
			switch selectedField {
			case 0:
				break
			case 5:
				printNotes(sortedNotes)
			case 6:
				notes = sortedNotes
				print("")
				print("Изменения сохранены!")
				break
			case 1, 2, 3, 4:
				print("")
			default:
				print("Неверный ввод!")
				continue
			}
			while true {
				print("1: Сортировать по возрастанию")
				print("2: Сортировать по убыванию")
				print("0: Выйти")
				print("Выберите пункт: ", terminator: "")
				let selectedOrder = Int(readLine() ?? "") ?? -1

				switch (selectedField, selectedOrder) {
				case (1, 1): sortedNotes = sortByName(notes: notes, order: .ascending, field: .firstName)
				case (1, 2): sortedNotes = sortByName(notes: notes, order: .descending, field: .firstName)
				case (2, 1): sortedNotes = sortByDate(order: .ascending)
				case (2, 2): sortedNotes = sortByDate(order: .descending)
				case (3, 1): sortedNotes = sortByPhoneNumber(order: .descending)
				case (3, 2): sortedNotes = sortByPhoneNumber(order: .descending)
				case (_, 0): break
				default:
					print("Неверный ввод!")
					continue
				}
				break
			}
		}
	}

	private func beatifulPrint(_ notes: [Note]) {
		guard !notes.isEmpty else {
			 print("Список контактов пуст.")
			 return
		 }

		 let header = "  №| Данные о контакте"
		 let separator = String(repeating: "-", count: header.count * 2)

		 print("Найденные контакты:")
		 print("")
		 print(header)
		 print(separator)

		 for (index, note) in notes.enumerated() {
			 let birthdayDescription = birthdayDescription(note: note)

			 let row = String(
						 format: " %2d| %12@ %12@ %15@ %16@",
						 index + 1,
						 note.lastName,
						 note.firstName,
						 note.phoneNumber,
						 birthdayDescription
					 )
			 print(row)
		 }
		 print(separator)
	}

	private func sortByName(notes: [Note], order: SortOrder, field: SortField) -> [Note] {
		let isAscending = order == .ascending
		var sortedNotes: [Note] = [notes[0]]
		var sortIndex = 0
		var isInserted = false
		var isFirstElement = true
		for note in notes {
			if isFirstElement {
				isFirstElement = false
				continue
			}
			subLoop: for sortNote in sortedNotes {
				if field == .firstName && (note.firstName < sortNote.firstName && isAscending) || (note.firstName > sortNote.firstName && !isAscending) ||
					field == .lastName && (note.lastName < sortNote.lastName && isAscending) || (note.lastName > sortNote.lastName && !isAscending)
				{
					sortedNotes.insert(note, at: sortIndex)
					isInserted = true
					break subLoop
				}
				sortIndex += 1
			}

			if !isInserted {
				sortedNotes.append(note)
			}

			sortIndex = 0
			isInserted = false
		}
		return sortedNotes
	}

	private func sortByDate(order: SortOrder) -> [Note] {
		let isAscending = order == .ascending
		var sortedNotes: [Note] = [notes[0]]
		var sortIndex = 0
		var isInserted = false
		var isFirstElement = true
		for note in notes {
			if isFirstElement {
				isFirstElement = false
				continue
			}

			subLoop: for sortNote in sortedNotes {
				if dateCondition(noteBirthday: note.birthday, sortedBirthday: sortNote.birthday, isAscending: isAscending)
				{
					sortedNotes.insert(note, at: sortIndex)
					isInserted = true
					break subLoop
				}
				sortIndex += 1
			}

			if !isInserted {
				sortedNotes.append(note)
			}

			sortIndex = 0
			isInserted = false
		}
		return sortedNotes
	}

	private func dateCondition(noteBirthday: [Int], sortedBirthday: [Int], isAscending: Bool) -> Bool {
		let sortedDay = sortedBirthday[0] // 31
		let sortedMonth = sortedBirthday[1] // 12
		let sortedYear = sortedBirthday[2] // 1995

		let day = noteBirthday[0] // 25
		let month = noteBirthday[1] // 10
		let year = noteBirthday[2] // 2016

		// проверяем и сравниваем год в первую очередь, затем месяц и день

		// Если год основного массива меньше/больше(возрастание/убывание) сортируемого массива, то тру, иначе идем дальше ...
		if (year < sortedYear) && isAscending || (year > sortedYear && !isAscending) {
			return true
		}

		// Если год основного массива равен году сортируемого массива И Если месяц основного массива меньше/больше(возрастание/убывание) сортируемого массива, тру, иначе идем дальше ...
		if ((month < sortedMonth && isAscending) || (month > sortedMonth && !isAscending)) && year == sortedYear { return true }

		// Если год и месяц основного массива равен году и месяцу сортируемого массива
		// И Если день основного массива меньше/больше(возрастание/убывание) сортируемого массива, тру, иначе идем дальше ...
		if ((day < sortedDay && isAscending) || (day > sortedDay && !isAscending)) && year == sortedYear && month == sortedMonth { return true }

		return false
	}

	private func sortByPhoneNumber(order: SortOrder) -> [Note] {
		let isAscending = order == .ascending
		var sortedNotes: [Note] = [notes[0]]
		var sortIndex = 0
		var isInserted = false
		var isFirstElement = true
		for note in notes {
			if isFirstElement {
				isFirstElement = false
				continue
			}
			subLoop: for sortNote in sortedNotes {
				if (note.phoneNumber < sortNote.phoneNumber && isAscending) || (note.phoneNumber > sortNote.phoneNumber && !isAscending)
				{
					sortedNotes.insert(note, at: sortIndex)
					isInserted = true
					break subLoop
				}
				sortIndex += 1
			}

			if !isInserted {
				sortedNotes.append(note)
			}

			sortIndex = 0
			isInserted = false
		}

		return sortedNotes
	}

	// MARK: Проверка на валидность введенной строки формату ДД.ММ.ГГГГ
	/// Проверка на валидность введенной строки формату ДД.ММ.ГГГГ
	/// - Parameter dateString: Введенная строка
	/// - Returns: Корректная ли введенная дата
	private func isCorrectDate(_ string: String) -> Bool {
		let dayMax = 31
		let dayMin = 1
		let monthMax = 12
		let monthMin = 1
		let yearMax = 2024
		let yearMin = 1900

		let birthdayArray = birthdayArray(string)
		let day = birthdayArray[0]
		let month = birthdayArray[1]
		let year = birthdayArray[2]
		let isCorrect = day >= dayMin && day <= dayMax &&
		month >= monthMin && month <= monthMax &&
		year >= yearMin && year <= yearMax
		if !isCorrect {
			print("Неверный ввод даты")
		}
		return isCorrect
	}

	// MARK: Разбивание строки-даты на массив чисел
	/// Разбивание строки-даты на массив чисел
	/// - Parameter dateString: Строка-дата в формате ДД.ММ.ГГГГ
	/// - Returns: Массив чисел [ДД, ММ, ГГГГ]
	private func birthdayArray(_ dateString: String) -> [Int] {
		var day = 0
		var month = 0
		var year = 0

		var digitCount = 0
		var numberString = ""

		for char in dateString {
			if char.isNumber {
				if digitCount == 2 {
					day = Int(String(numberString)) ?? 0
					numberString = ""
				} else if digitCount == 4 {
					month = Int(String(numberString)) ?? 0
					numberString = ""
				}
				numberString.append(char)
				digitCount += 1
			}
		}
		year = Int(String(numberString)) ?? 0
		return [day, month, year]
	}

	// MARK: Проверка на валидность введенной строки - номер телефона
	/// Проверка на валидность введенной строки - номер телефона
	/// - Parameter string: Введенная строка
	/// - Returns: Корректен ли введенный номер телефона
	private func isCorrectNumber(_ string: String) -> Bool {
		for char in string {
			if !char.isNumber {
				print("Присутствуют неверные символы в номере")
				return false
			}
		}
		if string.count < 7 || string.count > 12 {
			print("Недостаточно цифр в указанном номере телефона")
			return false
		}
		return true
	}

	// MARK: Проверка на количество символов в строке
	/// Проверка на количество символов в строке
	/// - Parameter string: Введенная строка
	/// - Returns: Корректно ли количество символов в строке
	private func isCorrectStringCount(_ string: String) -> Bool {
		string.count >= 2 && string.count <= 15
	}

	// MARK: Проверка на валидность введенной строки фамилия/имя
	/// Проверка на валидность введенной строки фамилия/имя
	/// - Parameter string: Введенная строка
	/// - Returns: Корректна ли введенная строка
	private func isCorrectName(_ string: String) -> Bool {
		if !isCorrectStringCount(string) {
			print("")
			print("Неверный ввод!")
			return false }
		for char in string {
			if !char.isLetter {
				print("Присутствуют неверные символы")
				return false
			}
		}
		return true
	}

	private func birthdayDescription(note: Note) -> String {
		var birthDescription = ""
		for birthdayElement in note.birthday {
			var correctBirthdayElement = String(birthdayElement)
			if birthdayElement < 10 {
				correctBirthdayElement = "0" + correctBirthdayElement
			}
			if birthdayElement == note.birthday.last {
				birthDescription.append(correctBirthdayElement)
			} else {
				birthDescription.append(correctBirthdayElement + ".")
			}
		}
		return birthDescription
	}

	private func addValue(with printText: String, value: EnterValue) -> String {
		while true {
			print(printText, terminator: "")
			let resultValue = readLine() ?? ""
			var isCorrect = false
			switch value {
			case .name:
				isCorrect = isCorrectName(resultValue)
			case .phoneNumber:
				isCorrect = isCorrectNumber(resultValue)
			case .birthday:
				isCorrect = isCorrectDate(resultValue)
			}
			if isCorrect {
				// Изза проблем с кодировкой в консоли, отображается дата с дополнительными лишними символами
				if value == .birthday {
					return formattingDate(resultValue)
				}
				return resultValue
			}
		}
		return ""
	}

	private func formattingDate(_ stringDate: String) -> String {
		var result: String = ""
		for char in stringDate {
			if char.isNumber || char == "." {
				result.append(char)
			}
		}
		return result
	}

	private func editNoteMenu(note: Note) -> Note {
		var editedNote = note
		while true {
			print("1: Изменить фамилию")
			print("2: Изменить имя")
			print("3: Изменить номер телефона")
			print("4: Изменить дату рождения")
			print("5: Сохранить")
			print("0: Выход без изменений")
			print("Выберите действие: ", terminator: "")
			let selectedNum = Int(readLine() ?? "") ?? -1
			switch selectedNum {
			case 0:
				return note
			case 1:
				let lastNameDescription = addValue(with: "Введите фамилию: ", value: .name)
				editedNote.lastName = lastNameDescription
			case 2:
				let firstNameDescription = addValue(with: "Введите имя: ", value: .name)
				editedNote.firstName = firstNameDescription
			case 3:
				let phoneNumberDescription = addValue(with: "Введите номер телефона: ", value: .phoneNumber)
				editedNote.phoneNumber = phoneNumberDescription
			case 4:
				let birthdayDescription = addValue(with: "Введите дату рождения в формате ДД.ММ.ГГГГ: ", value: .birthday)
				let birthdayArray = birthdayArray(birthdayDescription)
				editedNote.birthday = birthdayArray
			case 5:
				return editedNote
			default:
				print("Некорректный ввод, повторите")
			}
		}
		return editedNote
	}
}
