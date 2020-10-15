function eventNewPlayer(n)
    --ui.addPopup(100,nil,"",n,5,27,120,25,1,true,3)

    ui.addButton(100,"<p align='center'>?</p>",n,"help",5,29,18,15,true)
    ui.addButton(101,"<p align='center'>P</p>",n,"profile",35,29,18,15,true)
    ui.addButton(102,"<p align='center'>$</p>",n,"shop",65,29,18,15,true)
    ui.addButton(103,"<p align='center'>L</p>",n,"rank",95,29,18,15,true)
    --ui.addPopup(3,nil,"<p align='center'>\n<b><font size='15'><font color='#"..guilds[p[n].guild].color2.."'>"..text[n].teams[p[n].guild],n,368,85,140,60,1,true,3)

    setLang(n)
    players=players+1
    data[n]={
        0, --rounds 1
        0, --wins 2
        0, --looses 3
        0, --lvl 4
        0, --exp 5 
        0, --totalExp 6
        -15, --x 7
        10, --y 8
        15, --max cannon 9
        10, --max plank 10
        5, --max anvil 11
        0, --used cannon 12
        0, --sued plank 13
        0, --used anvil 14
        tfm.get.room.playerList[n].community --commu 15
    }
    p[n]={timing=0,newImg="",hPage=1,score=0,lbPage=1,globalPage=1,shPage=1,sub={1,2,3},guild="",right=true,use=51,max={[51]=data[n][9],[50]=data[n][10],[49]=data[n][11]},timestamp=os.time(),leaving=os.time(),cannonShop=true,plankShop=false,anvilShop=false}
    --ws.guild(n)
    ws.help(n)
    system.loadPlayerData(n)
    if tfm.get.room.currentMap=="@6760470" then
        tfm.exec.respawnPlayer(n)
    end
    if p[n].guild~="" then
        guilds[p[n].guild].inRoom[n]=true
    end
    for k=0,100 do
        tfm.exec.bindKeyboard(n,k,true,true)
    end
    tfm.exec.setPlayerScore(n,p[n].score)
    p[n].newImg=tfm.exec.addImage("16c256da563.png","&0",100,50,n)
end