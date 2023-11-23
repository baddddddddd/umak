extends Node


var player_position = Vector2(0, 0)


class QuizInformation:
	var information: String
	var question: String
	var choices: Variant
	var answer: String

	func _init(information, question, answer, choices):
		self.information = information
		self.question = question
		self.choices = choices.duplicate()
		self.answer = answer
		


var artifact_information = [
	QuizInformation.new(
		"For almost two years, from October 1762 to April 1764, Manila was part of the Britain.",
		"For almost two years, from October 1762 to April 1764, Manila was part of the ______",
		"Britain",
		[
			"Indian",
			"Russian",
			"China",
		]
	),
	QuizInformation.new(
		"The word manok comes from the Proto-Austronesian manuk which meant bird.",
		"The word manok comes from the Proto-Austronesian manuk which meant ______",
		"bird",
		[
			"flea",
			"chicken",
			"monkey",
		]
	),
	QuizInformation.new(
		"Bibingka came from the word Bebinca which is influenced by Indians.",
		"Bibingka came from the word Bebinca which is influenced by ______",
		"Indians",
		[
			"Chinese",
			"Spanish",
			"Russians",
		]
	),
	QuizInformation.new(
		"The first known Filipino serial killer is Juan Severino Mallari",
		"The first known Filipino serial killer is ______",
		"Juan Severino Mallari",
		[
			"Jose Burgos",
			"Mariano Gomez",
			"Jacinto Zamora",
		]
	),
	QuizInformation.new(
		"Gen Manuel Tinio is the youngest general of the Philippines.",
		"Who is the youngest general of the Philippines?",
		"Gen Manuel Tinio",
		[
			"Andres Bonifacio",
			"Emilio Aguinaldo",
			"Gregorio Del Pilar",
		]
	),
	QuizInformation.new(
		"The word \"Boonies\" originated from the Filipino word \"Bundok\".",
		"The word \"Boonies\" originated from the filipino word: ",
		"Bundok",
		[
			"Bilao",
			"Bituin",
			"Bilog",
		]
	),
	QuizInformation.new(
		"Nieves Fernandez, a Filipina teacher, assassinated 200 Japanese soldiers back in WWII.",
		"A Filipina teacher who assassinated 200 Japanese soldiers back in WWII.",
		"Nieves Fernandez",
		[
			"Melchora Aquino",
			"Maria Singson",
			"Sita Sandiago",
		]
	),	
]

var artifact_info_tracker = []
var artifact_collected = []

var ultimate_charge = 0
