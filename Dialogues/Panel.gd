extends Panel

var dialog_character_1 = ["Wow!! Vilkas. You have woken up. Want to hear something new? There's a wizard in a town. He lives SOUTH to the town in the forest. It is said that hes knows everything","I see you have talked to the wizard. Hope you can find your mom's killer","Good to see you Vilkas"]
var dialog_character_2 = ["Noooooo!! All my items are wasted. It will take some time to manage all this stuff.","Good Morning sir. Have a good day."]
var dialog_character_3 = ["It is a nice day today."," I wish everyday was like this."]
var dialog_character_4 = ["Hello child!!! I am the gratest wizard this world has ever seen, who has answers to any questions. The mask you wear its something different like filled with magic. I want a precious item held in the cave ruins north to this town. Bring me this item and i will tell you what you want to know.","Bring me the item held in the cave ruins, north to the town and i will answer your question."]
var magical_item = ["This must be what that wizard wants. My work has paid off."]
var page = 0
var screensize


func _ready() -> void:
	#self.rect_position.x = screensize.x / 2
	#self.rect_position.y = screensize.y / 4
	pass

func _on_Timer_timeout() -> void:
	$Text.set_visible_characters($Text.get_visible_characters() + 1)

func _on_Button_pressed() -> void:
	set_visible(false)
	
func _on_page_complete():
	var char_no = $Text.get_total_character_count()
	if($Text.get_visible_character() == char_no - 1):
		page += 1