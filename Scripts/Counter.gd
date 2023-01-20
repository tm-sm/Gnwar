extends Label

export(int) var counter = 0

func increment():
	counter += 1
	text = str(counter)

func decrement():
	counter -= 1
	text = str(counter)
