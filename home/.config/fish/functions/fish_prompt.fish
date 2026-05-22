# This is an AWFUL fish prompt.
# Please don't use this for actual work, and certainly not as a good reference...
# You have been warned.

function fish_prompt
	set -l last_status $status
	set -l dur $CMD_DURATION
	
	# time duration thing
	set -l dur_str
	if test $dur -ge 60000
		set dur_str (math -s0 $dur / 60000)m(math -s0 $dur % 60000 / 1000)s
	else if test $dur -ge 1000
		set dur_str (math -s1 $dur / 1000)s
	else if test $dur -gt 0
		set dur_str {$dur}ms
	end
	
	# pwd
	set -l parts (string split / (string replace -r "^$HOME" '~' $PWD))
	set -l n (count $parts)
	
	set -l short_pwd
	if test $n -le 3
		set short_pwd (string join / $parts)
	else
		set -l mid
		for i in (seq 2 (math $n - 1))
			set -a mid (string sub -l 1 $parts[$i])…
		end
		set short_pwd (string join / $parts[1] $mid $parts[$n])
	end

	# actual rendering
	set_color brblack; echo -n '╭─['
	set_color cyan; echo -n $short_pwd
	set_color brblack; echo -n ']'

	if test $last_status -ne 0
		echo -n ' ['
		set_color red; echo -n "ERR $last_status"
		set_color brblack; echo -n ']'
	end

	if test -n "$dur_str"
		echo -n ' ('
		set_color yellow; echo -n $dur_str
		set_color brblack; echo -n ')'
	end
	
	echo
	set_color brblack; echo -n '╰─'
	
	if test $last_status -ne 0
		set_color red
	else
		set_color magenta
	end
	echo -n '➤ '
	set_color normal
end