local function Utility_CheckVersion(err, responseText, headers)
    curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

	if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
		print("\n##############################")
		print("\n# pe-reputation is outdated. #")
        print("\n### Github Version: " .. responseText .. " ###")
        print("\n#### Your Version:  " .. curVersion .. ' ####')
		print("\n##############################")
	elseif tonumber(curVersion) > tonumber(responseText) then
        print("\n#############################")
		print("\n####### pe-reputation #######")
        print("\n## You skipped  a version? ##")
		print("\n#############################")
	end
end

CreateThread(function()
    if Config.VersionCheck then
        PerformHttpRequest("https://raw.githubusercontent.com/projectexpress/pe-reputation/master/version", Utility_CheckVersion, "GET")
    end
end)