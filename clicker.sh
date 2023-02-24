#!/usr/bin/env bash

# Device IDs can be found using "xinput --list"
MOUSE_ID=YOUR_MOUSE_ID
KEYBOARD_ID=YOUR_KEYBOARD_ID

# Key to enable/disable auto clicker (F4=default)
# To the keycode you can use xinput test {keyboard id} & press the key you want to get it
TOGGLE_KEY=70
PREVIOUS_TOGGLE_KEYSTATE="somerandomstringthatitwonteverequal"

# Target clicks per second
CPS=15

# Current state of the clicker
STATE=0

# Clicker loop
while true; do
    # Get the current state of the toggle key
    TOGGLE_KEYSTATE=$(xinput --query-state $KEYBOARD_ID | grep $TOGGLE_KEY | sed -n '1 p' | cut -d '=' -f 2)

    # Compare the current & previous toggle keystates
    # This allows you to press the key & it not spam change the state
    if [ $TOGGLE_KEYSTATE != $PREVIOUS_TOGGLE_KEYSTATE ]; then
        # Set current toggle keystate to the previous one
        PREVIOUS_TOGGLE_KEYSTATE=$TOGGLE_KEYSTATE

        # Update clicker state based on toggle key state
        if [ $TOGGLE_KEYSTATE = 'down' ]; then
            # Update state
            (( STATE ^= 1 ))

            # Add feedback to terminal
            echo "Updated state: $STATE"
        fi
    fi

    # Click left mouse button
    if [ $STATE = 1 ]; then
        # Simulate a mouse click using xdotool
        xdotool click 1
    fi

    # Delay before clicking again
    sleep $((1/1000/$CPS))
done
