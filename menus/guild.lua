function ws.guild(n)
    if p[n].guild~="" then
        close(n)
        ui.addPopup(1,nil,"",n,nil,nil,230,250,1,true,3)
        ui.addPopup(2,nil,"",n,295,85,60,60,1,true,3)
        ui.addPopup(3,nil,"<p align='center'>\n<b><font size='15'><font color='#"..guilds[p[n].guild].color2.."'>"..text[n].teams[p[n].guild],n,368,85,140,60,1,true,3)
        ui.addPopup(4,nil,"\n<font size='10.8'><p align='center'><b><V>"..text[n].rounds..": <VP>"..guilds[p[n].guild].rounds.."\n<V>"..text[n].wins..": <VP>"..guilds[p[n].guild].wins.."\n<V>"..text[n].lost..": <VP>"..guilds[p[n].guild].looses.."\n",n,nil,160,140,100,1,true,3)
        ui.addButton(1,"<p align='center'>"..text[n].close.."</p>",n,"close",nil,310,180,10,true)
        ui.addButton(2,"<p align='center'><BV>"..text[n].members.."</p>",n,"members",313,285,80,10,true)
        ui.addButton(3,"<p align='center'><R>"..text[n].leave.."</p>",n,"leave",407,285,80,10,true)
        id.guild[1][n]=tfm.exec.addImage(guilds[p[n].guild].logo..".png","&1",300,90,n)
    else
        ui.addPopup(1,nil,"",n,nil,nil,250,200,1,true,3)
        ui.addButton(2,"<p align='center'>"..text[n].join.."</p>",n,"join_df",285,175,80,10,true)
        ui.addButton(3,"<p align='center'>"..text[n].join.."</p>",n,"join_dp",435,175,80,10,true)
        ui.addButton(4,"<p align='center'>"..text[n].join.."</p>",n,"join_gm",285,275,80,10,true)
        ui.addButton(5,"<p align='center'>"..text[n].join.."</p>",n,"join_bp",435,275,80,10,true)
        local t=0
        for i,v in pairs(guilds) do
            t=t+1
            id.guild[t][n]=tfm.exec.addImage(v.logo..".png","&"..t,v.lx,v.ly,n)
        end
    end
end