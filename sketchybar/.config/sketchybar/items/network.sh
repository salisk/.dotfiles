#!/usr/bin/env sh

sketchybar -m --add item network.up right \
              --set network.up label.font="$FONT:Bold:9.0" \
                               icon.font="$FONT:Bold:12.0" \
                               icon=􀆇 \
                               icon.highlight_color=$BLUE \
                               y_offset=5 \
                               width=0 \
                               update_freq=1 \
                               script="$PLUGIN_DIR/network.sh" \
\
              --add item network.down right \
              --set network.down label.font="$FONT:Bold:9.0" \
                                 icon.font="$FONT:Bold:12.0" \
                                 icon=􀆈 \
                                 icon.highlight_color=$YELLOW \
                                 y_offset=-5 \
                                 update_freq=1\