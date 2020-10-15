local c={"profile","p","guild","pr","profil","map","c","C","shop","rank","leaderboard","lang","help"}
function eventChatCommand(n,cmd)
    local c={}
    for i in string.gmatch(cmd,'[^%s]+') do
        table.insert(c,i)
    end
    c[1]=string.lower(c[1])
    if (c[1]=="profile" or c[1]=="profil" or c[1]=="pr" or c[1]=="p") then
        if c[2] then
            local pr=string.gsub(c[2]:lower(),"%a",string.upper,1)
            open(n,pr,"profile")
        else
            open(n,n,"profile")
        end
    elseif c[1]=="wins" and c[2] and tonumber(c[2])~=nil and n=="Bodykudo#0000" then
        c[2]=tonumber(c[2])
        local exp=c[2]*5
        local lvl = (-3 + math.sqrt(9 + 8*c[2])) / 2
        tfm.exec.chatMessage("<VP>Wins: <J>"..tonumber(c[2]).."\n<VP>EXP: <J>"..exp.."\n<VP>Level: <J>"..lvl)
    elseif c[1]=="guild" then
        open(n,n,"guild")
    elseif c[1]=="map" and n=="Bodykudo#0000" then
        newMap()
    elseif c[1]=="shop" then
        p[n].shPage=1
        p[n].sub={1,2,3}
        p[n].shop=12
        open(n,"of","shop")
    elseif c[1]=="leaderboard" or c[1]=="rank" then
        p[n].lbPage=1
        p[n].globalPage=1
        open(n,"of","leaderboard")
    elseif c[1]=="lang" then    
        text[n]=lang[c[2]] or text[n]
    elseif c[1]=="help" then
        p[n].hPage=1
        open(n,"of","help")
    elseif c[1]=="exit" and n=="Bodykudo#0000" then
        system.exit()
    elseif c[1]=="c" and c[2] and p[n].guild~="" then
        for i in pairs(guilds[p[n].guild].inRoom) do
            local pr=n:find("#") and "<BV>"..n:sub(1, n:len()-5).."</BV><font color='#606090' size='10'><V>"..n:sub(-5).."</V></font>"
            tfm.exec.chatMessage("<BL>(</BL>"..pr.."<BL>)</BL> <font color='#"..guilds[p[n].guild].color2.."'>".. cmd:sub(c[1]:len()+2) .."",i)
        end
    end
end

for i=1,#c do
    system.disableChatCommandDisplay(c[i],true)
end