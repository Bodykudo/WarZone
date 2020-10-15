function eventPlayerWon(n,tE)
    if save and inRoomModule and not intRoom and (tE/10 >= 35) then
        data[n][2]=data[n][2]+1
        data[n][5]=data[n][5]+5
        data[n][6]=data[n][6]+5
        if data[n][5] >= (10+(data[n][4])*5) then
            data[n][4]=data[n][4]+1
            data[n][5]=0
            tfm.exec.chatMessage("<VP>"..string.format(text[n].lvlup,data[n][4]),n)
            if data[n][4] % 3==0 and data[n][4] <= 105 then
                local tool=math.random(49,51)
                while data[n][items[tool].data]==items[tool].lims do
                    tool=math.random(49,51)
                end
                data[n][items[tool].data]=data[n][items[tool].data]+1
            end
        end
    end
    saveData(n)
    p[n].score=p[n].score+5
    tfm.exec.setPlayerScore(n,p[n].score)
end