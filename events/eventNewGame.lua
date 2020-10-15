timerTimer,timerImg=""
function eventNewGame()
    save=false
    started=false
    done=false
    for n in pairs(tfm.get.room.playerList) do
        removeBoard(n)
    end
    if timerImg then tfm.exec.removeImage(timerImg) end
    if timerTimer then system.removeTimer(timerTimer) end
    if newTimer then system.removeTimer(newTimer) end
    if play then
        local var2=0
        for i,v in pairs(guilds) do
            if table.count(v.inRoom) > 2 then
                var2=var2+1
            end
        end
        if var2 >= 2 and not save and tfm.get.room.uniquePlayers >= 4 then
            save=true
        end
        for i,v in pairs(guilds) do
            if table.count(v.inRoom) > 0 then
                v.rounds=v.rounds+1
                v.looses=(v.rounds-1)-v.wins
            end
        end
        local currImg=0
        timerTimer=system.newTimer(function()
            newTimer=system.newTimer(function()
                if currImg~=6 then
                    currImg=currImg+1
                end
                if timerImg then tfm.exec.removeImage(timerImg) end
                timerImg=tfm.exec.addImage(times[currImg]..".png","!999",200,100)
            end,1000,true)
        end,2000,false)
        for n in pairs(tfm.get.room.playerList) do
            if not save and inRoomModule and not intRoom then
                tfm.exec.chatMessage("<R>"..text[n].toSave,n)
            end
            if intRoom and inRoomModule then
                tfm.exec.chatMessage("<R>Your data won't be saved in international rooms!",n)
            end
            p[n].use=49
            p[n].max={[49]=data[n][9],[50]=data[n][10],[51]=data[n][11]}
            if p[n].guild~="" then
                if save and inRoomModule and not intRoom then
                    data[n][1]=data[n][1]+1
                end
                saveData(n)
                tfm.exec.setNameColor(n,guilds[p[n].guild].color)
                for i,v in pairs(maps) do
                    if v.code==tfm.get.room.currentMap then
                        tfm.exec.movePlayer(n,v.x[p[n].guild],v.y[p[n].guild])
                    end
                end
            else
                tfm.exec.killPlayer(n)
            end
        end
    end
end