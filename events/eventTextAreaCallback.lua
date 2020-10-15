function eventTextAreaCallback(ids,n,cb)
    if cb:sub(0,4)=="join" then
        local g=cb:sub(6)
        if table.count(guilds[g].inRoom) < math.ceil(players/4) then 
            p[n].guild=g
            ui.closePopup(1,n)
            for i=1,4 do
                if id.guild[i][n] then
                    tfm.exec.removeImage(id.guild[i][n],n)
                end
            end
            for i=2,5 do
                ui.removeButton(i,n)
            end
            guilds[g].members[n]=true
            guilds[g].inRoom[n]=true
            p[n].leaving=os.time()
            tfm.exec.setNameColor(n,guilds[p[n].guild].color)
            ws.guild(n)
            --ws.help(n)
        else
            tfm.exec.chatMessage("<R>"..text[n].full.."</R>",n)
        end
    elseif cb=="leave" then
        if p[n].leaving<os.time()-(300*1000) then
            if tfm.get.room.currentMap~="@6760470" then
                tfm.exec.killPlayer(n)
            end
            guilds[p[n].guild].members[n]=nil
            guilds[p[n].guild].inRoom[n]=nil
            p[n].guild=""
            close(n)
            ws.guild(n)
            p[n].leaving=os.time()
        else
            tfm.exec.chatMessage("<R>"..text[n].no.."</R>",n)
        end
    elseif cb=="close" then
        close(n)
        if p[n].guild=="" then
            ws.guild(n)
        end
    elseif cb=="rank" then
        eventChatCommand(n,"rank")
    elseif cb=="profile" then
        eventChatCommand(n,"profile")
    elseif cb=="help" then
        eventChatCommand(n,"help")
    elseif cb=="shop" then
        eventChatCommand(n,"shop")
    elseif cb=="members" then
        tfm.exec.chatMessage("<V>"..text[n].gm.."\n<J>"..table.indexesConcat(guilds[p[n].guild].inRoom," <BL>-<J> ",tostring),n)
    elseif string.sub(cb,0,4)=="edit" then
        po=string.sub(cb,6,6)
        po=tonumber(po)
        ma=string.sub(cb,8,8)
        data[n][po]=data[n][po]+(ma=="+" and (data[n][po]<25 and 1 or 0) or ma=="-" and (data[n][po]>-25 and -1 or 0) or 0)
        if ma=="D" then
            data[n][po]=po==7 and -15 or 10
        end
        saveData(n)
        for i=1,2 do if id.profile[i][n] then tfm.exec.removeImage(id.profile[i][n],n) id.profile[i][n]=nil end end
        ui.addTextArea(4, "<p align='center'><V>X: <VP>"..data[n][7].." <CH>[<a href='event:edit_7_+'>+</a>] [<a href='event:edit_7_D'>D</a>] [<a href='event:edit_7_-'>-</a>]\n<p align='center'><V>Y: <VP>"..data[n][8].." <CH>[<a href='event:edit_8_+'>+</a>] [<a href='event:edit_8_D'>D</a>] [<a href='event:edit_8_-'>-</a>]\n", n, 225, 260, 142, 36, 0x324650, 0x000000, 0, true)
        id.profile[1][n]=tfm.exec.addImage("15fd0912dfe.png", "&1", 255+(data[n][7]+20), 165+(data[n][8]+20), n)
        id.profile[2][n]=tfm.exec.addImage("15fa9a33e5f.png", "&2", 255, 165, n)
    elseif cb=="next" and p[n].shPage < #stuff[p[n].shop]/3 then
        p[n].shPage=p[n].shPage+1
        for i=1,3 do
            p[n].sub[i]=p[n].sub[i]+3
        end
        ws.shop(n,p[n].cannonShop,p[n].plankShop,p[n].anvilShop)
    elseif cb=="pre" and p[n].shPage > 1 then
        p[n].shPage=p[n].shPage-1
        for i=1,3 do
            p[n].sub[i]=p[n].sub[i]-3
        end
        ws.shop(n,p[n].cannonShop,p[n].plankShop,p[n].anvilShop)
    elseif cb=="cannons" then
        p[n].shPage,p[n].sub=1,{1,2,3}
        ws.shop(n,true,false,false)
    elseif cb=="planks" then
        p[n].shPage,p[n].sub=1,{1,2,3}
        ws.shop(n,false,true,false)
    elseif cb=="anvils" then
        p[n].shPage,p[n].sub=1,{1,2,3}
        ws.shop(n,false,false,true)
    elseif string.sub(cb,0,2)=="eq" then
        local obj=tonumber(string.sub(cb,4,5))
        local new=tonumber(string.sub(cb,7))
        data[n][obj]=new
        saveData(n)
        ws.shop(n,p[n].cannonShop,p[n].plankShop,p[n].anvilShop)
    elseif string.sub(cb,0,4)=="uneq" then
        local obj=tonumber(string.sub(cb,6))
        data[n][obj]=0
        saveData(n)
        ws.shop(n,p[n].cannonShop,p[n].plankShop,p[n].anvilShop)
    elseif cb=="nextLeader" then
        p[n].lbPage=p[n].lbPage+1
        ws.leaderboard(n,p[n].lbPage,false)
    elseif cb=="nextGlobal" and p[n].globalPage < 5 then
        p[n].globalPage=p[n].globalPage+1
        ws.leaderboard(n,p[n].lbPage,true)
    elseif cb=="preGlobal" and p[n].globalPage > 1 then
        p[n].globalPage=p[n].globalPage-1
        ws.leaderboard(n,p[n].lbPage,true)
    elseif cb=="global" then
        p[n].globalPage=1
        ws.leaderboard(n,1,true)
    elseif cb=="leader" then
        p[n].lbPage=1
        ws.leaderboard(n,1,false)
    elseif cb=="preLeader" and p[n].lbPage>1 then
        p[n].lbPage=p[n].lbPage-1
        ws.leaderboard(n,p[n].lbPage,false)
    elseif cb=="nextHelp" and p[n].hPage<3 then
        p[n].hPage=p[n].hPage+1
        ws.help(n)
    elseif cb=="preHelp" and p[n].hPage>1 then
        p[n].hPage=p[n].hPage-1
        ws.help(n)
    elseif cb=="langs" then
        tfm.exec.chatMessage("<J>"..text[n].lgs.."</J>\n<ROSE><b>"..table.indexesConcat(lang,"</b></ROSE>,<ROSE><b> ",tostring).."</b>",n)
    end
end