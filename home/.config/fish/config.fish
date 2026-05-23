if status is-interactive
	# Commands to run in interactive sessions can go here
end

if uwsm check may-start
    exec uwsm start sway.desktop
end
fish_add_path /home/hamza/.spicetify
