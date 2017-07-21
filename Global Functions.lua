XMLUrl = ("");
AppVersion = (0);
DestinationPath = ("");
AppPath = ("");

function DownloadCallback (Downloaded, Total)
	local Percent = Math.Round((Downloaded/Total)*100,0);
	if(Percent ~= "-1.#IND")then
		Paragraph.SetText("Paragraph1", Percent.."%");
	end
end

function Update()
	for PID, FilePath in pairs(System.EnumerateProcesses()) do
		if(String.Lower(String.SplitPath(FilePath).Filename..String.SplitPath(FilePath).Extension) == String.Lower(String.SplitPath(AppPath).Filename..String.SplitPath(AppPath).Extension))then
			System.TerminateProcess(PID);
			break;
		end
	end
	for Count = 1, XML.Count("Updater", "Update")do
		local Update_Version = XML.GetAttribute("Updater/Update:"..Count.."", "Version");
		if(AppVersion < Update_Version)then
			if(AppVersion ~= Update_Version)then
				local Update_Url = XML.GetValue("Updater/Update:"..Count.."");
				FileInformation = String.SplitPath(Update_Url);
				if(String.Left(Update_Url, 5) == "https")then
					HTTP.DownloadSecure(Update_Url, _TempFolder.."\\UpdaterNG\\"..FileInformation.Filename..FileInformation.Extension, MODE_BINARY, 20, 443, nil, nil, DownloadCallback);
				else
					HTTP.Download(Update_Url, _TempFolder.."\\UpdaterNG\\"..FileInformation.Filename..FileInformation.Extension, MODE_BINARY, 20, 80, nil, nil, DownloadCallback);
				end
				Zip.Extract(_TempFolder.."\\UpdaterNG\\"..FileInformation.Filename..FileInformation.Extension, {"*.*"}, _TempFolder.."\\UpdaterNG\\unzip\\", true, true, "", ZIP_OVERWRITE_ALWAYS, nil);
			end
		end
	end
	File.Move(_TempFolder.."\\UpdaterNG\\unzip\\*.*", DestinationPath.."\\", true, true, true, true, nil);
	Error = Application.GetLastError();
	if(Error == 0)then
		Paragraph.SetText("Paragraph1", "Update Completed.");
		Folder.DeleteTree(_TempFolder.."\\UpdaterNG", nil);
		File.Open(AppPath, "", SW_SHOWNORMAL);
		Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
	else
		Dialog.Message("Fatal Error", _tblErrorMessages[Error], MB_OK, MB_ICONSTOP, MB_DEFBUTTON1);
		Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
	end
end

function CheckUpdates()
	for Count = 1, XML.Count("Updater", "Update")do
		local Update_Version = XML.GetAttribute("Updater/Update:"..Count.."", "Version");
		if(Update_Version > AppVersion)then
			if(AppVersion ~= Update_Version)then
				Status = (true);
				break;
			else
				Status = (false);
			end
		end
	end
	if(Status == true)then
		Update();
	else
		Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
	end
end
