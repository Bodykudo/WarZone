function ws.profile(n,pr)
    close(n)
    if p[pr].guild=="" then
        ui.addPopup(1,nil,"<p align='center'><b><font size='22' face='Soopafresh'>"..nameTagFormat(pr,22,"N","V").."</font></b>",n,nil,nil,400,280,1,true,3)
    else
        ui.addPopup(1,nil,"<p align='center'><b><font size='22' face='Soopafresh'>"..nameTagFormat(pr,22,"N","V").."\n<font color='#"..guilds[p[pr].guild].color2.."'>"..guilds[p[pr].guild].name.."</font></b>",n,nil,nil,400,280,1,true,3)
    end
    ui.addPopup(2,nil,"\n<font size='10.8'><p align='center'><b><V>"..text[n].level..": <VP>"..data[pr][4].."\n"..data[pr][5].." <V>/</V> "..10+(data[pr][4])*5 .."\n<V>"..text[n].rounds..": <VP>"..data[pr][1].."\n<V>"..text[n].wins..": <VP>"..data[pr][2].."\n<V>"..text[n].lost..": <VP>"..data[pr][3].."\n",n,410,130,180,150,1,true,3)
    ui.addPopup(3,nil,"",n,235,150,120,100,1,true,3)
    ui.addButton(1,"<p align='center'>"..text[n].close.."</p>",n,"close",nil,320,220,10,true)
    if n==pr then
        ui.addTextArea(4, "<p align='center'><V>X: <VP>"..data[pr][7].." <CH>[<a href='event:edit_7_+'>+</a>] [<a href='event:edit_7_D'>D</a>] [<a href='event:edit_7_-'>-</a>]\n<p align='center'><V>Y: <VP>"..data[pr][8].." <CH>[<a href='event:edit_8_+'>+</a>] [<a href='event:edit_8_D'>D</a>] [<a href='event:edit_8_-'>-</a>]\n", n, 225, 260, 142, 36, 0x324650, 0x000000, 0, true)
    else
        ui.addTextArea(4, "<p align='center'><V>X: <VP>"..data[pr][7].."\n<p align='center'><V>Y: <VP>"..data[pr][8], n, 225, 260, 142, 36, 0x324650, 0x000000, 0, true)
    end
    id.profile[1][n]=tfm.exec.addImage("15fd0912dfe.png", "&1", 255+(data[pr][7]+20), 165+(data[pr][8]+20), n)
    id.profile[2][n]=tfm.exec.addImage("15fa9a33e5f.png", "&2", 255, 165, n)
end