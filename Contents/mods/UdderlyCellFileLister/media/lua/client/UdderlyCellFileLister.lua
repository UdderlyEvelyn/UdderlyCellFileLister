Events.OnFillWorldObjectContextMenu.Add(
    function(player, contextMenu, worldObjects)
        if isClient() == false or isAdmin() or getAccessLevel() == "admin" then
            return contextMenu:addOption("Dump Cell Chunks", nil, --name, target.. 
		function() --onSelect
			local player = getPlayer()	
			
			local playerX = player:getX()
			local playerY = player:getY()
			
			local cellx = math.floor(playerX/300)
			local celly = math.floor(playerY/300)

			local minx = cellx*300
			local miny = celly* 300
			local maxx = minx+300
			local maxy = miny+300

			print("Current cell ranges from "..minx..", "..miny.." to "..maxx..", "..maxy..".")

			local chunks = {}

			function containsChunk(chunks, newChunk)
			    for i,chunk in ipairs(chunks) do
			    if (chunk == newChunk) then
				return true
			    end
			    end
			    return false
			end

			local count = 0
			for y = miny,maxy,10 do
			    for x = minx,maxx,10 do
			    chunkName = math.floor(x/10).."_"..math.floor(y/10)
			    if not containsChunk(chunks, chunkName) then
				table.insert(chunks, chunkName)
				count = count + 1
			    end
			    end
			end

			local cellName = cellx.."_"..celly
			local fileName = "chunks_"..cellName..".txt"

			local msg = "Dumping "..count.." chunks to file \""..fileName.."\"."
			print(msg)
			player:setHaloNote(msg, 255, 255, 255, 300)

			local file = getFileWriter(fileName, true, false)
			file:write("chunkdata_"..cellName..".bin\n")
			file:write("zpop_"..cellName..".bin\n")
			for i,chunk in ipairs(chunks) do
			    file:write("map_"..chunk.. ".bin\n");
			end
			file:close()
		    end
		, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil) --params1-10
        end
	return nil --not admin so do nothing
    end
)