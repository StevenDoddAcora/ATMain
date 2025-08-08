Set-ExecutionPolicy unrestricted

Set-Location 'C:\Program Files (x86)\Microsoft Dynamics NAV\110\RoleTailored Client'
#https://community.dynamics.com/nav/b/navision360/archive/2019/01/25/how-to-convert-c-al-based-solution-to-al-using-txt2al
#
#Run Command Prompt as Administrator
#Change directory to point RTC folder. If you are using Microsoft Dynamics 365 Business Central then your command would be like:

finsql.exe command=exporttonewsyntax, file="M:\Projects\AVT\Tmp\TxtFiles\Test.txt", database="AVT_V11R17_DEV", servername=10.169.150.117 ,filter=type=table;ID=18

txt2al --source="M:\Projects\AVT\Tmp\TxtFiles" --target="M:\Projects\AVT\Tmp\AlFiles" --extensionStartId=66000