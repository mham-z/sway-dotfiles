#!/usr/bin/env python3

import i3ipc
sway = i3ipc.Connection()

def get_app_name(leave):
	app_name = leave.app_id or leave.window_class
	
	if app_name:
		return app_name
	
	if leave.name:
		return leave.name[:15] + "..." if len(leave.name) > 15 else leave.name
		
	return ""

def update_workspaces(sway, event=None):
	tree = sway.get_tree()
	
	for workspace in tree.workspaces():
		ws_num = workspace.num
		app_names = []

		for leave in workspace.descendants():
			name = get_app_name(leave)
			if name: # and name not in app_names
				app_names.append(name)
		
		if app_names:
			new_name = f"{ws_num}: [{', '.join(app_names)}]"
		else:
			new_name = f"{ws_num}"
			
		if workspace.name != new_name:
			sway.command(f'rename workspace "{workspace.name}" to "{new_name}"')

sway.on('window', update_workspaces)
sway.on('workspace', update_workspaces)

update_workspaces(sway)
sway.main()