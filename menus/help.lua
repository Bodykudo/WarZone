function ws.help(n)
    close(n)
    ui.addPopup(1,nil,text[n].help[p[n].hPage],n,nil,nil,320,230,1,true,3)
    ui.addButton(1,"<p align='center'>"..text[n].close,n,"close",nil,300,100,10,true)
    ui.addButton(2,"<p align='center'>"..text[n].next,p[n].hPage==3 and "n" or n,"nextHelp",470,300,70,10,true)
    ui.addButton(3,"<p align='center'>"..text[n].pre,p[n].hPage==1 and "n" or n,"preHelp",260,300,70,10,true)
end