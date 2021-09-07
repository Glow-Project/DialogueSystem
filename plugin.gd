tool
extends Node
class_name Dialogue

signal on_next_message(message)
signal on_dialogue_end()

var index: int = 0
var content: Array


##
## Load a Dialogue by its name, language, and default_path into [b]this[/b] Dialogue object
##
func get_dialogue(name: String, language: String, default_dialogue_path: String) -> void:

	var file_path = "{default_path}/{dialogue_name}/{dialogue_name}-{language}.json".format(
		{
			"default_path": default_dialogue_path,
			"dialogue_name": name,
			"language": language
		}
	)
	
	var file = File.new()
	assert (file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	var dialogue_text = parse_json(file.get_as_text())
	assert (dialogue_text.size() > 0)

	content = dialogue_text
	index = 0

##
## Returns the next part of the message or ends the dialogue
##
func next_message():
	if content.size() <= index:
		end_dialogue()
		return

	var message = content[index]
	index += 1

	emit_signal("on_next_message", message)

	return message

##
## End the dialogue and reset its index
##
func end_dialogue():
	index = 0
	emit_signal("on_dialogue_end")
