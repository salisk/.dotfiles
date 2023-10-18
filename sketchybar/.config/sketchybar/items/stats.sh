sketchybar --add alias "Stats,Disk_mini" right \
	--set "Stats,Disk_mini" padding_right=-15 padding_left=-10 label.width=0 \
	click_script="open -a /System/Applications/Utilities/Disk\ Utility.app"

sketchybar --add alias "Stats,RAM_mini" right \
	--set "Stats,RAM_mini" padding_right=-15 padding_left=-10 label.width=0 \
	click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,CPU_mini" right \
	--set "Stats,CPU_mini" padding_right=-15 padding_left=0 label.width=0 \
	click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,Network_speed" right \
	--set "Stats,Network_speed" padding_right=0 padding_left=0 label.width=0 \
	click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"
