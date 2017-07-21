for _, Line in pairs(_CommandLineArgs) do
	LineARGS = String.Find(Line, "=", 1);
	if(LineARGS ~= -1)then
		Command = String.Left(Line, LineARGS-1);
		Argument = String.Mid(Line, LineARGS+1, -1);
		if(Command == "XML")then
			if(Argument ~= "")then
				if(String.Left(tostring(Argument), 5) == "https")then
					XML.SetXML(HTTP.SubmitSecure(tostring(Argument), {}, SUBMITWEB_GET, 20, 443, nil, nil));
				else
					XML.SetXML(HTTP.Submit(tostring(Argument), {}, SUBMITWEB_GET, 20, 80, nil, nil));
				end
				XMLUrl = (Argument);
			end
		end
		if(Command == "Version")then
			if(Argument ~= "")then
				AppVersion = (Argument);
			end
		end
		if(Command == "DestinationPath")then
			if(Argument ~= "")then
				DestinationPath = (Argument);
			end
		end
		if(Command == "AppPath")then
			if(Argument ~= "")then
				AppPath = (Argument);
			end
		end
	end
end

if(XMLUrl == "")then
	Dialog.Message("Error", "Missing parameter: XML.", MB_OK, MB_ICONSTOP, MB_DEFBUTTON1);
	Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
end

if(AppVersion == "")then
	Dialog.Message("Error", "Missing parameter: Version.", MB_OK, MB_ICONSTOP, MB_DEFBUTTON1);
	Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
end

if(DestinationPath == "")then
	Dialog.Message("Error", "Missing parameter: DestinationPath.", MB_OK, MB_ICONSTOP, MB_DEFBUTTON1);
	Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
end

if(AppPath == "")then
	Dialog.Message("Error", "Missing parameter: AppPath.", MB_OK, MB_ICONSTOP, MB_DEFBUTTON1);
	Window.Close(Application.GetWndHandle(), CLOSEWND_TERMINATE);
end
