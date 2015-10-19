--Truth Stones™ for Macintosh, © 2015 C K Yap yapchenkuang@yahoo.com
--Modification [for resale] permitted agreeing to maintain the top line
--File->Export as stay-open application. Place below the board and stones
--This version is 0.7b [beta]

on idle
	
	set pS to "debug test"
	set patN to ""
	set arcB to false
	
	repeat
		delay 0.1
		
		tell application "System Events"
			set appN to item 1 of (get name of processes whose frontmost is true)
		end tell
		
		if appN is "Finder" then
			tell application "Finder" to set patN to (target of front window) as text
			
			if patN contains "Truth Stones" then
				tell application "Finder"
					--get name only
					set selL to selection
					set selS to {}
					repeat with iC in selL
						set end of selS to name of iC
					end repeat
				end tell
				
				--if more than 1 selection
				if (count of selS) is greater than 1 then
					
					set AppleScript's text item delimiters to space
					set selS to mySP as string
					set AppleScript's text item delimiters to ""
					
					--trigger spotlight search archive folder
					--check your system preferences for shortcut conflicts
					tell application "System Events"
						keystroke space using {command down}
						keystroke the mySP
					end tell
				end if
				
				--window list with blank files as space markers
				tell application "System Events"
					set spFs to every file of folder patN whose name starts with " "
					set myFs to every file of folder patN whose name ¬
						does not start with " "
				end tell
				
				repeat with i from 1 to the count of spFs --ok
					set spF to (item i of spFs)
					
					--find file with position same as " " files behind it
					repeat with i from 1 to the count of myFs
						set myF to (item i of myFs)
						--some files fail / hidden
						try
							--set myPos to item 1 of position of file spF
							if item 1 of position of myF is equal to item ¬
								1 of position of spF and ¬
								item 2 of position of myF is equal to item ¬
								2 of position of spF then
								--blank marker filename length --todo
								set myLen to length of spF
								exit repeat
							end if
						end try
					end repeat
					
					--backup script is in Resources
					--terms may be safely adjusted for SEO
					--the current ones are beta quality
					--also adjust the stone icon names in the folder
					--quadrant 1
					if myLen = 1 then
						set pS to pS & " in the beginning " & myF
					else if myLen = 6 then
						set pS to pS & " " & myF & " approached"
						--quadrant 2
					else if myLen = 10 then
						set pS to pS & " " & myF & " approached"
					else if myLen = 13 then
						set pS to pS & " later " & myF
						--quadrant 3
					else if myLen = 4 then
						set pS to pS & " now " & myF
					else if myLen = 7 then
						set pS to pS & " " & myF & " approaches"
						--quadrant 4
					else if myLen = 11 then
						set pS to pS & " " & myF & " will approach"
					else if myLen = 16 then
						set pS to pS & " finally " & myF
						exit repeat
					else
						set pS to pS & " " & myF
					end if
				end repeat
				
				log pS
			end if
			
		else if appN is "Safari" then
			tell application "System Events"
				tell process "Safari"
					--set search field's append terms  if Safari search field is edited
					--check for presence of the [old] pre-string and *not* an URL
					if value does not start with pS then
						if value contains " " then
							set value of text field 1 of group 2 of toolbar 1 of window 1 to ¬
								pS & " " & value --todo not showing
							set arcB to true
						else if value does not contain " " then
							set arcB to false
						end if
					end if
				end tell
			end tell
			
			set pgT to " " --name of document 1
			set aF to " " --patN & "Archives/" & pS & pgT & ".webloc"
			
			--file check handler
			if canCreate(aF) and arcB is true then
				arcB = no
				tell application "Safari" to set urlN to URL of current tab of window 1
				tell application "Finder" to make new internet location file to ¬
					urlN at patN & "Archives/" with properties ¬
					{name:aF}
			end if
		end if
	end repeat
	return 1
end idle

-----handlers-----
on canCreate(theF)
	tell application "System Events"
		if exists file theF then
			return false
		else
			return true
		end if
	end tell
end canCreate
