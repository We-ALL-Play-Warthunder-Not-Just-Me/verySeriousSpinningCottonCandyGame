extends Control

#  this is an autoload

enum AudioBusChannels {Master, Music, SFX}

signal master_volume_updated(new: float)
signal music_volume_updated(new: float)
signal sfx_volume_updated(new: float)

const CONFIG_FILENAME:String = "config.cfg"

func setbusVolume(bus: int, value: float) -> void:
	AudioServer.set_bus_volume_linear(bus, value)

var master_vol:float = 1.0:
	set(value):
		if (master_vol != value):
			master_vol = value
			setbusVolume(AudioBusChannels.Master, master_vol)

var music_vol:float = 1.0:
	set(value):
		if (music_vol != value):
			music_vol = value
			setbusVolume(AudioBusChannels.Music, music_vol)
var sfx_vol:float = 1.0:
	set(value):
		if (sfx_vol != value):
			sfx_vol = value
			setbusVolume(AudioBusChannels.SFX, sfx_vol)

func loadData() -> void :
	var optionsfile: ConfigFile = ConfigFile.new()

	var status = optionsfile.load("user://%s" % CONFIG_FILENAME)

	if status == OK:
		master_vol = optionsfile.get_value("Options", "master_vol")
		music_vol = optionsfile.get_value("Options", "music_vol")
		sfx_vol = optionsfile.get_value("Options", "sfx_vol")
		master_volume_updated.emit(master_vol)
		music_volume_updated.emit(music_vol)
		sfx_volume_updated.emit(sfx_vol)

func saveData() -> void:
	var optionsfile: ConfigFile = ConfigFile.new()
	
	optionsfile.set_value("Options", "master_vol", master_vol)
	optionsfile.set_value("Options", "music_vol", music_vol)
	optionsfile.set_value("Options", "sfx_vol", sfx_vol)

	optionsfile.save("user://%s" % CONFIG_FILENAME)



# # Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
