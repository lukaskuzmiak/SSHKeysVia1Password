global theHomeFolder
set theHomeFolder to POSIX path of (path to home folder)

global theSSHAddScriptPath
set theSSHAddScriptPath to (theHomeFolder & "ssh-add-pass.sh")


on PosixFileExists(thePath)
	try
		POSIX file thePath as alias
		return true
	on error
		return false
	end try
end PosixFileExists

if not PosixFileExists(theSSHAddScriptPath) then
	display dialog "File '" & theSSHAddScriptPath & "' does not exist, this ain't gonna work :(" buttons {"OK"} default button 1
	return false
end if


on Search1Password(input)
	set theClipboardBackup to the clipboard
	set thePassword to null
	set the clipboard to null
	
	if input contains " " then
		display dialog "Input '" & input & "' contains spaces, this ain't gonna work :(" buttons {"OK"} default button 1
		return null
	end if
	
	set theSearchTerm to input
	
	tell application "2BUA8C4S2C.com.agilebits.onepassword-osx-helper" to open location "x-onepassword-helper://search/" & theSearchTerm
	delay 0.5
	
	set theClipboardTextPre to the clipboard
	tell application "System Events" to keystroke "c" using {shift down, command down}
	delay 0.5
	set theClipboardTextPost to the clipboard
	
	if theClipboardTextPre is not equal to theClipboardTextPost then
		set thePassword to theClipboardTextPost
	end if
	
	set the clipboard to theClipboardBackup
	
	return thePassword
end Search1Password

on CallSSHAdd(thePath, thePassword)
	set returnCode to do shell script theSSHAddScriptPath & " " & quoted form of thePath & " " & quoted form of thePassword
	if returnCode as number is equal to 0 then
		log "Key '" & thePath & "' added successfully."
		return true
	else
		display dialog "Error adding key '" & thePath & "' !!!"
		return false
	end if
end CallSSHAdd

on AddSSHKey(thePath, thePasswordItemName)
	
	if not PosixFileExists(thePath) then
		display dialog "File '" & thePath & "' does not exist, this ain't gonna work :(" buttons {"OK"} default button 1
		return false
	end if
	
	set thePassword to Search1Password(thePasswordItemName)
	if thePassword is not equal to null then
		return CallSSHAdd(thePath, thePassword)
	else
		display dialog "Unable to find password for item '" & thePasswordItemName & "', this ain't gonna work :(" buttons {"OK"} default button 1
	end if
	
	
end AddSSHKey

-- main code starts here
AddSSHKey(theHomeFolder & ".ssh/id_rsa1", "SSH_KEY_PASSPHRASE_id_rsa1")
AddSSHKey(theHomeFolder & ".ssh/id_rsa2", "SSH_KEY_PASSPHRASE_id_rsa2")