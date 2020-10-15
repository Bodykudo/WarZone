for _,v in pairs ({'disableAutoScore','disablePhysicalConsumables','disableAutoNewGame','disableDebugCommand','disableMinimalistMode','disableMortCommand','disableAutoTimeLeft','disableAutoShaman'}) do
    tfm.exec[v](true)
end
tfm.exec.setRoomMaxPlayers(32)

ws={}
toDespawn={}

id={
    guild={{},{},{},{}},
    emt={{},{},{}},
    profile={{},{},{}},
    shop={{},{},{}},
    lb={{},{},{},{},{},{},{},{},{},{}}
}

p={}
data={}
players=0
playe=false
started=false
startCool=true
done=false
save=false
updateFileTime=os.time()

text={}
translations={}

guilds={
    df={name="Dragon Fist",members={},inRoom={},color=0xFF4646,color2='FF4646',logo="15e15465adb",lx=300,ly=110,rounds=0,wins=0,looses=0},
    dp={name="Blue Pegasus",members={},inRoom={},color=0xb6deff ,color2='b6deff',logo="15e154606d4",lx=450,ly=110,rounds=0,wins=0,looses=0},
    gm={name="Green Mermaid",members={},inRoom={},color=0x6cff73,color2='6cff73',logo="15e15467027",lx=300,ly=210,rounds=0,wins=0,looses=0},
    bp={name="Sabertooth",members={},inRoom={},color=0xf9c944,color2='f9c944',logo="15e154685d3",lx=450,ly=210,rounds=0,wins=0,looses=0}, --525552
}

items={
    [49]={name="Cannon",id=17,x=15,y=0,max=20,xa=30,angle=90,max_x=24,max_x2=24,max_y=24,data=9,lims=30,da=12,speed=30},
    [50]={name="Plank",id=3,x=70,y=-3,max=15,xa=25,angle=0,max_x=69,max_x2=29,max_y=24,data=10,lims=25,da=13,speed=30},
    [51]={name="Anvil",id=10,x=15,y=0,max=5,xa=25,angle=0,max_x=24,max_x2=-1,max_y=24,data=11,lims=10,da=14,speed=25}
}

commus={bg="16501fe9900",br="16501feb767",es="16502016f7e",en="16502014e66",e2="16502014e66",ch="16502014e66",az="16502014e66",ee="16502012786",de="16502010d54",cz="1650200f889",cn="1650200dcb8",he="1650201cd14",fr="1650201ae36",fi="16502018f27",hu="1650202c454",hr="16502029140",it="165020300f6",id="1650202ed53",jp="165020338b5",lt="16502035415",lv="16502037161",nl="1650203a27f",pl="16502046783",ph="16502043268",pt="1650204a49f",ro="1650204bfab",ru="1650204f3c4",ar="165020563f3",sk="16502069482",vk="1650206ff15",xx="16502071c3a",tr="1650206d73c"}

times={
    "1683e9a470b",
    "1683e9a28dd",
    "1683e9abc43",
    "1683e9a81be",
    "1683e9adbed",
    "1683e9a9f15"
}

keys={
    [79]="shop",
    [80]="profile",
    [76]="leaderboard",
    [71]="guild",
    [72]="help"
}

function open(n,pr,func)
    if p[n].guild=="" then
        if func~="guild" then
            if id.guild[4][n] then tfm.exec.removeImage(id.guild[4][n],n) id.guild[4][n]=nil end
            ws[func](n,func=="leaderboard" and 1 or (func=="shop" and true or pr),false,false)
        else
            tfm.exec.chatMessage("<R>"..text[n].wrong,n)
        end
    else
        ws[func](n,func=="leaderboard" and 1 or (func=="shop" and true or pr),false,false)
    end
end

function close(n)
    for i=1,11 do
        ui.closePopup(i,n)
    end
    for i=1,8 do
        ui.removeButton(i,n)
    end
    ui.removeTextArea(4,n)
    for v,o in pairs({"guild","profile","shop"}) do
        for i=1,3 do
            if id[o][i][n] then
                tfm.exec.removeImage(id[o][i][n],n)
                id[o][i][n]=nil
            end
        end
    end
    for i=1,10 do
        if id.lb[i][n] then
            tfm.exec.removeImage(id.lb[i][n],n)
            id.lb[i][n]=nil
        end
    end
end