#!/bin/bash

# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Wait till processes have finished
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch all bars with individual logs
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log /tmp/polybar4.log /tmp/polybar5.log /tmp/polybar6.log

polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
polybar bar3 2>&1 | tee -a /tmp/polybar3.log & disown
polybar bar4 2>&1 | tee -a /tmp/polybar4.log & disown
polybar bar5 2>&1 | tee -a /tmp/polybar5.log & disown
polybar bar6 2>&1 | tee -a /tmp/polybar6.log & disown  

echo "All bars deployed..."
