/*
Allows changing from one profile to another using a hotkey.
*/
class ProfileSwitcherEz extends _UCR.Classes.Plugin {
	Type := "Profile Switcher 2 Buttons"
	Description := "Changes to a named profile when you hit two Input Buttons"
	
	ButtonsPressed := [0,0]
	
	Init(){
		Gui, Add, Text, y+10, % "Hotkey: "
		this.AddControl("InputButton", "MyHk1", 0, this.MyHkChangedState.Bind(this, 1), "x170 yp w100")
		this.AddControl("ButtonPreviewThin", "", 0, this.IOControls.MyHk1, "x+0 yp")
		this.AddControl("InputButton", "MyHk2", 0, this.MyHkChangedState.Bind(this, 2), "x+5 yp w100")
		this.AddControl("ButtonPreviewThin", "", 0, this.IOControls.MyHk2, "x+0 yp")
		
		Gui, Add, Text, xm, % "Change to this profile on press"
		this.AddControl("ProfileSelect", "Profile1", 0, "x170 yp-2 w380", 0)
		
		Gui, Add, Text, xm, % "Change to this profile on release"
		this.AddControl("ProfileSelect", "Profile0", 0, "x170 yp-2 w380", 0)	
	}

	; The hotkey was pressed to change profile
	MyHkChangedState(code,e){
		;Button 1 changed state, which is into pressed
		;Remember what's recorded in this function is the "change of state", not current condition
		
		;Thus, store the current condition
		if (e)
			this.ButtonsPressed[code] := 1
		else
			this.ButtonsPressed[code] := 0
		
		if (this.ButtonsPressed[1] && this.ButtonsPressed[2]) 
			prof = 1
		else
			prof = 0
		
		new_profile := this.GuiControls["Profile" prof].Get()
		;OutputDebug % "UCR| new_profile: " new_profile ", Current: " UCR.CurrentPID
		if (!new_profile || UCR.CurrentPID == new_profile)
			return	; Filter repeats and unbound profiles
		;OutputDebug % "UCR| ProfileSwitcher changing to: " new_profile
		if (!UCR.ChangeProfile(new_profile))
			SoundBeep, 300, 200
	}
	
	; In order to free memory when a plugin is closed, we must free references to this object
	OnClose(){
		GuiControl -g, % this.hTest0
		GuiControl -g, % this.hTest1
		base.OnClose()
	}
		
}