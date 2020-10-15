function toCheck()
    local alive=0
    for n,p in pairs(tfm.get.room.playerList) do
        if not p.isDead then
            alive=alive+1
        end
    end
    if alive==1 or alive==0 then
        tfm.exec.setGameTime(5)
    end
end

function Win(guild)
    guilds[guild].wins=guilds[guild].wins+1
    for i in pairs(guilds[guild].members) do
        if tfm.get.room.playerList[i] and not tfm.get.room.playerList[i].isDead then
            tfm.exec.giveCheese(i)
            tfm.exec.playerVictory(i)
        end
    end
    tfm.exec.setGameTime(5)
end

function board(n)
    ui.addTextArea(1,"<p align='right'><b><font size='15'>"..p[n].max[49].." / "..data[n][9].."</b></p>",n,694,27,100, 25,0x324650,0x000000,p[n].use==49 and 0.5 or 0.2,true)
    ui.addTextArea(2,"<p align='right'><b><font size='15'>"..p[n].max[50].." / "..data[n][10].."</b></p>",n,694,61,100,25,0x324650,0x000000,p[n].use==50 and 0.5 or 0.2,true)
    ui.addTextArea(3,"<p align='right'><b><font size='15'>"..p[n].max[51].." / "..data[n][11].."</b></p>",n,694,95,100,25,0x324650,0x000000,p[n].use==51 and 0.5 or 0.2,true)
    id.emt[1][n]=tfm.exec.addImage("16b2a197964.png", "&1", 695, 27, n)
    id.emt[2][n]=tfm.exec.addImage("16b2a19c097.png", "&2", 695, 61, n)
    id.emt[3][n]=tfm.exec.addImage("16b2a195c4b.png", "&3", 695, 95, n)
end

function removeBoard(n)
    for i=1,3 do
        ui.removeTextArea(i,n)
        if id.emt[i][n] then
            tfm.exec.removeImage(id.emt[i][n],n)
        end
    end
end