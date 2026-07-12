# This is an AWFUL bash prompt.
# It has been sloppily converted from fish to bash.
# Please don't use this for actual work, and certainly not as a good reference...
# You have been warned.

# You may copy this to /root/ if you want.

if (( EUID != 0 )); then
	_prompt_timer_start() {
		[[ -z $_prompt_timer_started ]] && _prompt_timer_ms=$(( ${EPOCHREALTIME/.} / 1000 ))
		_prompt_timer_started=1
	}

	_prompt_timer_stop() {
		local now_ms=$(( ${EPOCHREALTIME/.} / 1000 ))
		_prompt_duration=$(( now_ms - ${_prompt_timer_ms:-$now_ms} ))
		unset _prompt_timer_started _prompt_timer_ms
	}

	trap '_prompt_timer_start' DEBUG
fi

_build_prompt() {
	local last_status=$?

	# time duration thing
	local dur_str=""
	if (( EUID != 0 )); then
		_prompt_timer_stop
		local dur=$_prompt_duration
		if   (( dur >= 60000 )); then
			dur_str="$(( dur / 60000 ))m$(( dur % 60000 / 1000 ))s"
		elif (( dur >= 1000 )); then
			dur_str="$(( dur / 1000 )).$(( dur % 1000 / 100 ))s"
		elif (( dur > 0 )); then
			dur_str="${dur}ms"
		fi
	fi

	# pwd
	local display_pwd="${PWD/#$HOME/\~}"
	IFS='/' read -ra parts <<< "$display_pwd"
	local n=${#parts[@]}

	local short_pwd
	if (( n <= 3 )); then
		short_pwd="$display_pwd"
	else
		local mid=()
		for (( i=1; i<n-1; i++ )); do
			mid+=("${parts[i]:0:1}…")
		done
		local IFS='/'
		short_pwd="${parts[0]}/${mid[*]}/${parts[n-1]}"
	fi

	# colors
	local reset='\[\e[0m\]'
	local brblack='\[\e[90m\]'
	local cyan='\[\e[36m\]'
	local red='\[\e[31m\]'
	local blue='\[\e[34m\]'
	local yellow='\[\e[33m\]'
	local magenta='\[\e[35m\]'

	# actual rendering
	local thing="${blue}bash${brblack}"
	if (( EUID == 0 )); then
		thing="${red}bash • ROOT${brblack}"
	fi

	local line1="${brblack}╭─[${thing}] [${cyan}${short_pwd}${brblack}]"

	if (( last_status != 0 )); then
		line1+=" [${red}ERR ${last_status}${brblack}]"
	fi

	if [[ -n $dur_str ]]; then
		line1+=" (${yellow}${dur_str}${brblack})"
	fi

	line1+="${reset}"

	local arrow_color
	if (( last_status != 0 )); then
		arrow_color=$red 
	else
		arrow_color=$blue
	fi

	PS1="${line1}\n${brblack}╰─${arrow_color}➤ ${reset}"
}

PROMPT_COMMAND='_build_prompt'
. "$HOME/.rokit/env"
