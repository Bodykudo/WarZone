function eventLoop(time,remaining)
    var=0
    var2=0
    for i,v in pairs(guilds) do
        if table.count(v.inRoom) > 0 then
            var=var+1
        end
        if table.count(v.inRoom) > 2 then
            var2=var2+1
        end
    end
    if var >= 2 and not play then
        play=true
        if tfm.get.room.currentMap=="@6760470" and startCool then
            startCool=false
            tfm.exec.setGameTime(11)
        end
    end
    if var < 2 and play then
        play=false
        if tfm.get.room.currentMap~="@6760470" then
            tfm.exec.setGameTime(11)
            startCool=true
        end
    end
    if time >= 8000 and play and not started and tfm.get.room.currentMap~="@6760470" then
        started=true
        if newTimer then
            system.removeTimer(newTimer)
        end
        for n in pairs(tfm.get.room.playerList) do
            if p[n].guild~="" then
                board(n)
            end
        end
    end
    if time >= 9000 and timerImg then
        tfm.exec.removeImage(timerImg)
    end
    for i,object in ipairs(toDespawn) do
        if object[1] <= os.time()-1500 then
            tfm.exec.removeObject(object[2])
            table.remove(toDespawn,i)
        end
    end
    if remaining<=0 then
        newGame()
    end
    if os.time()-90000 > updateFileTime then
        system.loadFile(2)
        updateFileTime=os.time()
    end
    for n in pairs(tfm.get.room.playerList) do
        if p[n].timing <= 7 then
            p[n].timing=p[n].timing+0.5
            if p[n].timing==7 then
                if p[n].newImg then tfm.exec.removeImage(p[n].newImg,n) p[n].newImg=nil end
            end
        end
    end
end