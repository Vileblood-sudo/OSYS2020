##########################################################
#     Filename: OSYS2020_Script
#     Author: Steven Thompson W0266159
#     Description: Assignment 3: Automating Security with PowerShell
#
#     Date Created: 2020-03-06
#     Last Modified: 2020-03-06
#
######################################################################


# This block of code initializes a variable to contain data on the header I will use
# in the HTML formatted document. The output text will be wrapped in a bordered table
# with columns as required in this assignment.
$Header = @"
<style>
TABLE {border-width: 3px; border-style: solid; border-color: red; border-collapse: collapse;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@


# The Do block will run a loop prompting for user input for target computers
# After initial input, the Response variable will prompt to add servers, y or n
# If input is Y, loop will continue adding TargetName inputs to the TargetList variable
# If input is N, the loop will stop and the TargetList values will be used for the next commands.
Do 
{ 
$TargetName = Read-Host 'Please Input The Target Computer'
$Prompt = Read-Host 'Add Targets? (y/n)'
$Targetlist = $TargetName.Split(',')
}
Until ($Prompt -eq 'n')

# This command will use the System and Application strings to pass to the foreach loop
# The loop will run the Get-EventLog command with the specific Error and Warning log levels
# The target computer will use the PromptOne variable which the user previously input and
# check events only from the previous 12 hour span and sort them by time. Once complete, the ConvertTo-HTML
# will use the Header variable to format the data into an easy to read table with columns
# as requested by this assignment. The output will be sent to the C:\ drive with a filename
# that will change to the current day.
"System","Application" | foreach {Get-EventLog -LogName $_ -EntryType Error, Warning `
-ComputerName $TargetList -After (Get-Date).AddHours(-12)} | ConvertTo-Html `
-Property MachineName,EventID,TimeGenerated,EntryType,Source,Message `
-Head $Header | Out-File "C:\$(get-date -f yyyy-MM-dd).html"

# This command will output text on the command line informing the user the process was successful
# The `n instructs the script to write an empty line each time used
Write-Host "`n"
Write-Host "Event Log HTML Report Sent to C:\" 
Write-Host "`n"

# This command will output all disk drive utilization details for the given targets
Write-Host "DISK SPACE UTILIZATION" 
Get-WmiObject win32_logicaldisk -ComputerName $TargetList 