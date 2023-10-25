#!/usr/bin/env sh

source "$CONFIG_DIR/icons.sh"

sketchybar -m --add item network.up right \
	--set network.up label.font="$NERD_FONT:Bold:10" \
	icon.font="$NERD_FONT:Bold:16.0" \
	icon="$NETWORK_UP" \
	icon.highlight_color=$BLUE \
	y_offset=5 \
	width=0 \
	update_freq=1 \
	script="$PLUGIN_DIR/network.sh" \
	\
	--add item network.down right \
	--set network.down label.font="$NERD_FONT:Bold:10" \
	icon.font="$NERD_FONT:Bold:16.0" \
	icon="$NETWORK_DOWN" \
	icon.highlight_color=$YELLOW \
	y_offset=-5 \
	update_freq=1

