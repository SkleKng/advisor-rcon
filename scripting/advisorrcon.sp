#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = 
{
    name = "Advisor Rcon",
    author = "Skle",
    description = "Allows advisors access to select rcon commands",
    version = "1.0.0",
    url = "http://www.edgegamers.com"
}

public void OnPluginStart()
{
    RegAdminCmd("sm_advisorrcon", Command_AdvisorRcon, ADMFLAG_SLAY, "Allows advisors access to select rcon commands");
    RegAdminCmd("sm_advrcon", Command_AdvisorRcon, ADMFLAG_SLAY, "Allows advisors access to select rcon commands");
    RegAdminCmd("sm_arcon", Command_AdvisorRcon, ADMFLAG_SLAY, "Allows advisors access to select rcon commands");
}


public Action Command_AdvisorRcon(int client, int args) // host_workshop_map, sv_cheats, mp_ignore_round_win_conditions
{
	char[] possibleCommands = "host_workshop_map;sv_cheats;mp_ignore_round_win_conditions";

	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_arcon <args> | Possible commands: sv_cheats, host_workshop_map, mp_ignore_round_win_conditions");
		return Plugin_Handled;
	}

	char commandstring[255];
	GetCmdArg(1, commandstring, sizeof(commandstring));
	char argstring[255];
	GetCmdArgString(argstring, sizeof(argstring));

	// Check if the command is in the list of possible commands
	if (StrContains(possibleCommands, commandstring, false) == -1)
    	{
        	ReplyToCommand(client, "[SM] This command is not in the list of possible commands | Possible commands: sv_cheats, host_workshop_map, mp_ignore_round_win_conditions");
        	return Plugin_Handled;
    	}
	else if (StrContains(";", commandstring, false) == 1)
	{
		ReplyToCommand(client, "[SM] Command injection detected! Don't do that :(");
		return Plugin_Handled;
	}
	else
	{
		char responseBuffer[4096];
		ServerCommandEx(responseBuffer, sizeof(responseBuffer), "%s", argstring);
		if (IsClientConnected(client))
		{
			ReplyToCommand(client, responseBuffer);
		}
	}

	return Plugin_Handled;
}
