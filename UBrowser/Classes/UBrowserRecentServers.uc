class UBrowserRecentServers extends UBrowserServerListWindow;

function Created()
{
	Super.Created();
	Refresh();
}
final function AddRecentServer(UBrowserServerList Server)
{
	local UBrowserServerList NewItem;

	if (PingedList.FindExistingServer(Server.IP, Server.QueryPort) == None)
		NewItem = UBrowserServerList(PingedList.CopyExistingListItem(ServerListClass, Server));
	UBrowserRecentFact(Factories[0]).AddServer(Server);
}

defaultproperties
{
	ListFactories(0)="UBrowser.UBrowserRecentFact"
}
