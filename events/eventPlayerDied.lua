function eventPlayerDied(n)
    if tfm.get.room.currentMap~="@6760470" then
        local t={df=0,dp=0,gm=0,bp=0}
        if p[n].guild~="" then
            if save and inRoomModule and not intRoom then
                data[n][3]=data[n][3]+1
            end
            saveData(n)
            removeBoard(n)
            for n,pr in pairs(tfm.get.room.playerList) do
                if not pr.isDead then
                    t[p[n].guild]=t[p[n].guild]+1
                end
            end
            local team = {}
            for k,v in pairs(t) do
                if v ~= 0 then
                    team[#team+1] = k
                end
                if #team > 1 then
                    break
                end
            end
            if #team==1 then
                done=true
                table.foreach(tfm.get.room.playerList,removeBoard)
                tfm.exec.setGameTime(10)
                for i in pairs(guilds[team[1]].members) do
                    tfm.exec.movePlayer(i,maps[currMap].x[p[i].guild],maps[currMap].y[p[i].guild])
                end
                system.newTimer(function()
                    Win(team[1])
                end,5000,false)
            end
        end
    end
end