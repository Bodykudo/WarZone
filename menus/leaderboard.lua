function ws.leaderboard(n,page,global)
    close(n)
    local names=""
    local wins=""
    local ids=""
    local lvls=""
    local lbCommus={}
    if global then
        local page=p[n].globalPage*10
        for i=page-9,page do
            local player=lb_gbPl[i]
            local playerName=mini(player)
            names=names..playerName.."\n"
            wins=wins.."<ROSE>"..gbPl[player][2].."</ROSE>\n"
            --lvls=lvls.."<R>"..gbPl[player][3].."</R>\n"
            ids=ids.."#<J>"..i.."</J>\n"
            lbCommus[#lbCommus+1]=gbPl[player][1]
        end
    else
        p_B=page*10
        p_A=p_B-9
        lbData=rankPlayers()
        if #lbData < p_B then
            p_B=#lbData
        end
        for a=p_A,p_B do
            names=names..""..tostring(mini(lbData[a][1])).."\n"
            wins=wins.."<ROSE>"..tostring(lbData[a][2]).."</ROSE>\n"
            --lvls=lvls.."<R>"..data[lbData[a][1]][4].."</R>\n"
            ids=ids.."#<J>"..a.."</J>\n"
            lbCommus[#lbCommus+1]=data[lbData[a][1]][15]
        end
        if math.ceil(#lbData/10) == 0 then
            npage=1
        else
            npage=math.ceil(#lbData/10)
        end
    end
    ui.addButton(4,global and "<p align='center'>"..text[n].room or "<p align='center'>"..text[n].global,n,global and "leader" or "global",90,90,80,15,true)
    ui.addPopup(1,nil,"",n,nil,nil,455,240,1,true,3)
    ui.addPopup(2,nil,"<p align='center'>"..ids,n,180,130,30,140,1,true,3)
    ui.addPopup(3,nil,"<p align='center'>"..names,n,230,130,140,140,1,true,3)
    ui.addPopup(4,nil,"<p align='center'>"..wins,n,390,130,50,140,1,true,3)
    --ui.addPopup(10,nil,"<p align='center'>"..lvls,n,460,130,50,140,1,true,3)
    ui.addPopup(5,nil,"",n,530,130,70,140,1,true,3)
    ui.addPopup(6,nil,"<p align='center'>#<J>X</J>",n,180,90,30,20,1,true,3)
    ui.addPopup(7,nil,"<p align='center'>"..text[n].name,n,230,90,140,20,1,true,3)
    ui.addPopup(8,nil,"<p align='center'><ROSE>"..text[n].winsB,n,390,90,50,20,1,true,3)
    ui.addPopup(9,nil,"<p align='center'><VP>"..text[n].commu,n,530,90,70,20,1,true,3)
    --ui.addPopup(11,nil,"<p align='center'><R>"..text[n].level,n,460,90,50,20,1,true,3)
    ui.addButton(3,"<p align='center'>"..text[n].close,n,"close",325,300,150,10,true)
    if global then
        ui.addButton(1,"<p align='center'>"..text[n].pre,p[n].globalPage==1 and "n" or n,"preGlobal",225,300,80,10,true)
        ui.addButton(2,"<p align='center'>"..text[n].next,p[n].globalPage==3 and "n" or n,"nextGlobal",505,300,80,10,true)
    else
        ui.addButton(1,"<p align='center'>"..text[n].pre,page==1 and "n" or n,"preLeader",225,300,80,10,true)
        ui.addButton(2,"<p align='center'>"..text[n].next,page==npage and "n" or n,"nextLeader",505,300,80,10,true)
    end
    local Y=136
    for i=1,#lbCommus do
        if commus[lbCommus[i]] then
            if commus[lbCommus[i]]~=nil then
                id.lb[i][n]=tfm.exec.addImage(commus[lbCommus[i]]..".png","&999",557,Y,n)
            end
        end
        Y=Y+13.5
    end
end