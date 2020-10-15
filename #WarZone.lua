VERSION = "1.0.0"

local translations={}
--[[ File main.lua ]]--
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
--[[ End of file main.lua ]]--
--[[ Directory functions ]]--
--[[ File functions/otherFunctions.lua ]]--
function nameTagFormat(name, size, color1, color2)
    local Name, Hash = string.match(name,"([^#]+)(#%d+)")
    Name = Name or name
    Hash = Hash or ""
    local size = tonumber(size or 14)
    local color1 = color1 or 'r'
    local color2 = color2 or 'j'
    local colorN, colorH = (string.match(1,"#") and "<font color='"..color1.."' size='"..size.."'>%s</font>" ) or "<font size='"..size.."'><"..color1..">%s</"..color1.."></font>" , ( string.match(color2,"#") and "<font color='"..color2.."' size='".. math.floor(size*2/3) .."'>%s</font>" ) or "<font size='".. math.floor(size*2/3) .."'><"..color2..">%s</"..color2.."></font>" 
    return string.format(colorN, Name)..string.format(colorH, Hash)
end

function mini(pr)
    return pr:sub(0,1)=="*" and (pr:len() > 12 and ""..pr:sub(0,12).."</font>.." or ""..pr.."</font>") or pr:len()-5 > 12 and ""..pr:sub(0,12).."</font>..<font size='8'><V>"..pr:sub(-5).."</V></font>" or ""..pr:sub(1,pr:len()-5).."</font><font size='8'><V>"..pr:sub(-5).."</V></font>"
end
--[[ End of file functions/otherFunctions.lua ]]--
--[[ File functions/tableFunctions.lua ]]--
function table.count(tbl)
    local out = 0
    for k in next, tbl do
        out = out + 1
    end
    return out
end

function table.indexesConcat(list,sep,f,i,j)
    local txt = ""
    sep = sep or ""
    i,j = i or 1,j or #list
    for k,v in next,list do
        if type(k) ~= "number" and true or (k >= i and k <= j) then
            txt = txt .. (f and f(k,v) or v) .. sep
        end
    end
    return string.sub(txt,1,-1-#sep)
end
--[[ End of file functions/tableFunctions.lua ]]--
--[[ End of directory functions ]]--
--[[ Directory tables ]]--
--[[ File tables/maps.lua ]]--
maps={
    {code="@5729211",x={df=263,dp=478,gm=176,bp=702},y={df=165,dp=165,gm=165,bp=165}},
    {code="@5580081",x={df=608,dp=728,gm=191,bp=70},y={df=135,dp=215,gm=135,bp=215}},
    {code="@5563558",x={df=134,dp=663,gm=139,bp=668},y={df=180,dp=85,gm=85,bp=180}},
    {code="@7286076",x={df=75,dp=315,gm=730,bp=480},y={df=125,dp=257,gm=123,bp=257}},
    {code="@7080372",x={df=400,dp=562,gm=79,bp=85},y={df=342,dp=167,gm=212,bp=82}},
    {code="@7005593",x={df=464,dp=28,gm=352,bp=774},y={df=119,dp=209,gm=119,bp=209}},
    {code="@7288124",x={df=590,dp=473,gm=330,bp=209},y={df=145,dp=345,gm=345,bp=145}},
    {code="@7287871",x={df=271,dp=723,gm=556,bp=273},y={df=228,dp=152,gm=152,bp=106}},
    {code="@7287699",x={df=395,dp=395,gm=395,bp=395},y={df=178,dp=88,gm=268,bp=358}},
    {code="@7280598",x={df=411,dp=649,gm=192,bp=730},y={df=55,dp=254,gm=187,bp=70}},
    {code="@7286949",x={df=300,dp=173,gm=555,bp=677},y={df=302,dp=145,gm=302,bp=145}},
    {code="@7286403",x={df=700,dp=620,gm=105,bp=174},y={df=117,dp=303,gm=117,bp=303}},
    {code="@7114389",x={df=552,dp=450,gm=245,bp=349},y={df=190,dp=357,gm=190,bp=357}},
    {code="@7286394",x={df=440,dp=358,gm=537,bp=264},y={df=358,dp=358,gm=125,bp=125}},
    {code="@7286382",x={df=199,dp=597,gm=197,bp=598},y={df=119,dp=354,gm=354,bp=119}},
    {code="@5017354",x={df=60,dp=610,gm=740,bp=190},y={df=140,dp=260,gm=140,bp=260}},
    {code="@5014291",x={df=682,dp=122,gm=224,bp=583},y={df=190,dp=160,gm=245,bp=105}},
    {code="@4884688",x={df=302,dp=58,gm=423,bp=181},y={df=185,dp=185,gm=185,bp=185}},
    {code="@3661362",x={df=565,dp=734,gm=188,bp=378},y={df=205,dp=255,gm=335,bp=155}},
    {code="@4795468",x={df=196,dp=198,gm=597,bp=598},y={df=285,dp=85,gm=285,bp=85}},
    {code="@3899992",x={df=284,dp=148,gm=515,bp=721},y={df=242,dp=164,gm=149,bp=90}},
    {code="@4773530",x={df=199,dp=597,gm=760,bp=598},y={df=164,dp=64,gm=165,bp=265}},
    {code="@4741121",x={df=119,dp=522,gm=340,bp=161},y={df=195,dp=195,gm=330,bp=330}},
    {code="@4741187",x={df=364,dp=639,gm=437,bp=165},y={df=148,dp=148,gm=148,bp=148}},
    {code="@4741210",x={df=697,dp=700,gm=239,bp=699},y={df=156,dp=247,gm=156,bp=66}},
    {code="@4741230",x={df=275,dp=682,gm=112,bp=725},y={df=330,dp=215,gm=99,bp=99}},
    {code="@4741240",x={df=200,dp=515,gm=596,bp=291},y={df=160,dp=160,gm=160,bp=160}},
    {code="@4734030",x={df=285,dp=492,gm=248,bp=765},y={df=207,dp=243,gm=344,bp=193}},
    {code="@4734088",x={df=560,dp=400,gm=398,bp=242},y={df=186,dp=346,gm=186,bp=186}},
    {code="@4734142",x={df=401,dp=401,gm=173,bp=625},y={df=131,dp=131,gm=141,bp=141}},
    {code="@4734196",x={df=113,dp=322,gm=480,bp=694},y={df=158,dp=158,gm=158,bp=158}},
    {code="@541917",x={df=449,dp=357,gm=352,bp=443},y={df=250,dp=150,gm=250,bp=151}},
    {code="@559634",x={df=665,dp=400,gm=144,bp=400},y={df=130,dp=205,gm=130,bp=205}},
    {code="@559644",x={df=145,dp=660,gm=660,bp=142},y={df=171,dp=171,gm=81,bp=81}},
    {code="@589708",x={df=652,dp=726,gm=70,bp=147},y={df=152,dp=152,gm=152,bp=152}},
    {code="@589736",x={df=120,dp=753,gm=41,bp=681},y={df=256,dp=85,gm=85,bp=257}},
    {code="@1700322",x={df=81,dp=110,gm=542,bp=623},y={df=305,dp=55,gm=135,bp=305}},
    {code="@7595782",x={df=401,dp=709,gm=89,bp=401},y={df=163,dp=255,gm=255,bp=163}},
    {code="@7594576",x={df=471,dp=376,gm=438,bp=337},y={df=187,dp=187,gm=187,bp=187}},
    {code="@7590371",x={df=688,dp=112,gm=112,bp=686},y={df=286,dp=287,gm=87,bp=87}},
    {code="@7292307",x={df=183,dp=620,gm=536,bp=265},y={df=170,dp=170,gm=170,bp=170}},
    {code="@7293047",x={df=295,dp=705,gm=705,bp=295},y={df=194,dp=145,gm=194,bp=145}},
    {code="@6714009",x={df=448,dp=498,gm=350,bp=304},y={df=105,dp=105,gm=105,bp=105}},
    {code="@7286390",x={df=640,dp=361,gm=165,bp=448},y={df=245,dp=165,gm=245,bp=165}},
    {code="@7294324",x={df=444,dp=400,gm=358,bp=400},y={df=365,dp=125,gm=365,bp=125}},
    {code="@7293554",x={df=250,dp=35,gm=550,bp=765},y={df=125,dp=125,gm=125,bp=125}},
    {code="@7291944",x={df=250,dp=700,gm=100,bp=550},y={df=245,dp=145,gm=345,bp=245}},
    {code="@7291507",x={df=640,dp=286,gm=104,bp=200},y={df=345,dp=205,gm=205,bp=205}},
    {code="@7288035",x={df=400,dp=525,gm=400,bp=270},y={df=231,dp=90,gm=231,bp=90}},
    {code="@7562525",x={df=580,dp=223,gm=357,bp=441},y={df=350,dp=350,gm=165,bp=165}},
    {code="@7482755",x={df=215,dp=767,gm=618,bp=370},y={df=263,dp=184,gm=184,bp=263}},
    {code="@7538006",x={df=169,dp=489,gm=314,bp=631},y={df=285,dp=350,gm=350,bp=285}},
    {code="@7549205",x={df=84,dp=749,gm=400,bp=400},y={df=235,dp=235,gm=155,bp=345}},
    {code="@7549214",x={df=219,dp=252,gm=609,bp=578},y={df=300,dp=130,gm=155,bp=325}},
    {code="@7549209",x={df=579,dp=262,gm=61,bp=695},y={df=252,dp=252,gm=76,bp=80}},
    {code="@1904053",x={df=731,dp=69,gm=194,bp=604},y={df=65,dp=65,gm=157,bp=158}},
    {code="@1951332",x={df=290,dp=508,gm=56,bp=747},y={df=350,dp=350,gm=216,bp=216}},
    {code="@1985670",x={df=76,dp=730,gm=45,bp=768},y={df=55,dp=304,gm=220,bp=55}},
    {code="@2059382",x={df=663,dp=143,gm=250,bp=557},y={df=68,dp=68,gm=172,bp=172}},
    {code="@1531279",x={df=86,dp=715,gm=280,bp=521},y={df=255,dp=255,gm=205,bp=205}},
    {code="@1966987",x={df=630,dp=298,gm=499,bp=170},y={df=308,dp=309,gm=308,bp=310}},
    {code="@1879154",x={df=126,dp=396,gm=134,bp=638},y={df=228,dp=351,gm=56,bp=271}},
    {code="@1829042",x={df=103,dp=501,gm=705,bp=300},y={df=65,dp=165,gm=65,bp=165}},
    {code="@1943308",x={df=199,dp=51,gm=601,bp=748},y={df=60,dp=175,gm=60,bp=175}},
    {code="@3237641",x={df=185,dp=618,gm=143,bp=657},y={df=226,dp=226,gm=75,bp=74}},
    {code="@1675316",x={df=54,dp=746,gm=496,bp=297},y={df=92,dp=92,gm=90,bp=90}},
    {code="@1314982",x={df=589,dp=403,gm=403,bp=213},y={df=277,dp=212,gm=212,bp=277}},
    {code="@1286824",x={df=398,dp=719,gm=99,bp=405},y={df=85,dp=287,gm=287,bp=346}},
    {code="@1997222",x={df=159,dp=521,gm=768,bp=308},y={df=249,dp=293,gm=126,bp=104}},
    {code="@3654127",x={df=158,dp=719,gm=433,bp=648},y={df=187,dp=307,gm=225,bp=88}},
    {code="@3274133",x={df=301,dp=698,gm=600,bp=202},y={df=114,dp=238,gm=214,bp=244}},
    {code="@2103061",x={df=401,dp=739,gm=58,bp=399},y={df=90,dp=135,gm=135,bp=242}},
    {code="@2135145",x={df=422,dp=539,gm=147,bp=17},y={df=272,dp=312,gm=192,bp=152}},
    {code="@2221226",x={df=739,dp=400,gm=400,bp=60},y={df=105,dp=59,gm=270,bp=105}},
    {code="@1846255",x={df=289,dp=65,gm=508,bp=0},y={df=82,dp=190,gm=82,bp=0}},
    {code="@3326933",x={df=160,dp=638,gm=398,bp=400},y={df=330,dp=330,gm=200,bp=70}},
    {code="@1922239",x={df=625,dp=324,gm=175,bp=473},y={df=65,dp=65,gm=65,bp=65}},
    {code="@2173893",x={df=481,dp=299,gm=303,bp=479},y={df=157,dp=307,gm=107,bp=265}},
    {code="@3210915",x={df=57,dp=750,gm=341,bp=454},y={df=185,dp=185,gm=76,bp=253}},
    {code="@2050554",x={df=169,dp=18,gm=633,bp=782},y={df=125,dp=125,gm=124,bp=125}},
    {code="@2119800",x={df=770,dp=758,gm=27,bp=40},y={df=340,dp=139,gm=139,bp=340}},
    {code="@1675013",x={df=668,dp=310,gm=495,bp=131},y={df=108,dp=179,gm=179,bp=108}},
    {code="@1643446",x={df=402,dp=401,gm=718,bp=78},y={df=70,dp=215,gm=85,bp=85}},
    {code="@1681719",x={df=399,dp=402,gm=179,bp=621},y={df=197,dp=65,gm=76,bp=76}},
    {code="@3577308",x={df=40,dp=759,gm=212,bp=589},y={df=140,dp=140,gm=262,bp=262}},
    {code="@910078",x={df=316,dp=638,gm=173,bp=479},y={df=324,dp=184,gm=183,bp=324}},
    {code="@7401383",x={df=401,dp=87,gm=713,bp=401},y={df=185,dp=135,gm=135,bp=185}},
    {code="@7473147",x={df=284,dp=516,gm=283,bp=518},y={df=165,dp=315,gm=315,bp=165}},
    {code="@7474110",x={df=762,dp=400,gm=42,bp=402},y={df=125,dp=113,gm=125,bp=345}},
    {code="@7474530",x={df=742,dp=512,gm=43,bp=252},y={df=211,dp=186,gm=275,bp=112}},
    {code="@1667582",x={df=680,dp=124,gm=138,bp=670},y={df=66,dp=66,gm=194,bp=194}},
    {code="@1825269",x={df=410,dp=578,gm=410,bp=106},y={df=185,dp=65,gm=185,bp=265}},
    {code="@1749647",x={df=400,dp=650,gm=150,bp=400},y={df=335,dp=335,gm=335,bp=335}},
    {code="@2324513",x={df=485,dp=629,gm=629,bp=332},y={df=256,dp=215,gm=215,bp=206}},
    {code="@2218853",x={df=601,dp=202,gm=402,bp=404},y={df=67,dp=67,gm=45,bp=162}},
    {code="@3219038",x={df=637,dp=305,gm=325,bp=738},y={df=245,dp=245,gm=105,bp=105}},
    {code="@2020179",x={df=730,dp=398,gm=66,bp=398},y={df=70,dp=85,gm=70,bp=85}},
    {code="@4411127",x={df=401,dp=552,gm=248,bp=401},y={df=163,dp=245,gm=245,bp=351}},
    {code="@1985678",x={df=720,dp=81,gm=556,bp=244},y={df=59,dp=59,gm=170,bp=170}},
    {code="@589800",x={df=700,dp=550,gm=250,bp=100},y={df=162,dp=162,gm=162,bp=162}},
    {code="@1616785",x={df=675,dp=567,gm=235,bp=127},y={df=108,dp=210,gm=210,bp=108}},
    {code="@1688696",x={df=738,dp=59,gm=182,bp=620},y={df=115,dp=115,gm=215,bp=215}},
    {code="@2232342",x={df=715,dp=715,gm=94,bp=94},y={df=90,dp=190,gm=90,bp=190}},
    {code="@2222981",x={df=667,dp=131,gm=448,bp=354},y={df=122,dp=122,gm=66,bp=66}},
    {code="@7292599",x={df=739,dp=61,gm=402,bp=402},y={df=44,dp=44,gm=74,bp=74}},
    {code="@3015995",x={df=555,dp=255,gm=94,bp=705},y={df=208,dp=208,gm=334,bp=334}},
    {code="@7292145",x={df=775,dp=600,gm=202,bp=20},y={df=251,dp=181,gm=181,bp=251}},
    {code="@7286179",x={df=770,dp=308,gm=32,bp=490},y={df=319,dp=336,gm=319,bp=336}},
    {code="@7293452",x={df=645,dp=650,gm=155,bp=156},y={df=266,dp=95,gm=95,bp=266}},
    {code="@7297649",x={df=450,dp=684,gm=173,bp=368},y={df=303,dp=132,gm=211,bp=92}},
    {code="@7290901",x={df=735,dp=398,gm=60,bp=398},y={df=184,dp=157,gm=184,bp=157}},
    {code="@7093063",x={df=740,dp=408,gm=408,bp=60},y={df=99,dp=202,gm=202,bp=99}},
    {code="@7291632",x={df=680,dp=405,gm=406,bp=120},y={df=332,dp=307,gm=307,bp=332}},
    {code="@5028713",x={df=500,dp=630,gm=300,bp=165},y={df=308,dp=308,gm=309,bp=310}},
    {code="@2130154",x={df=50,dp=760,gm=760,bp=40},y={df=179,dp=285,gm=189,bp=285}},
    {code="@2315803",x={df=501,dp=86,gm=713,bp=302},y={df=176,dp=305,gm=305,bp=177}},
    {code="@2174353",x={df=280,dp=520,gm=630,bp=175},y={df=171,dp=171,gm=359,bp=359}},
    {code="@4376567",x={df=700,dp=47,gm=751,bp=100},y={df=65,dp=171,gm=171,bp=65}},
    {code="@2117839",x={df=100,dp=555,gm=250,bp=700},y={df=45,dp=365,gm=365,bp=45}},
    {code="@2088076",x={df=147,dp=103,gm=650,bp=696},y={df=221,dp=342,gm=221,bp=342}},
    {code="@2068396",x={df=55,dp=750,gm=600,bp=200},y={df=335,dp=335,gm=55,bp=55}},
    {code="@5122003",x={df=90,dp=320,gm=580,bp=710},y={df=245,dp=352,gm=352,bp=245}},
    {code="@5124047",x={df=240,dp=240,gm=560,bp=560},y={df=345,dp=242,gm=242,bp=345}},
    {code="@5124024",x={df=660,dp=520,gm=145,bp=280},y={df=348,dp=348,gm=348,bp=348}},
    {code="@5124098",x={df=400,dp=670,gm=400,bp=100},y={df=265,dp=188,gm=265,bp=344}},
    {code="@1298164",x={df=740,dp=60,gm=622,bp=175},y={df=247,dp=247,gm=247,bp=247}},
    {code="@1642575",x={df=701,dp=710,gm=90,bp=99},y={df=355,dp=170,gm=170,bp=355}},
    {code="@7473297",x={df=55,dp=395,gm=750,bp=395},y={df=204,dp=146,gm=204,bp=146}},
    {code="@1561467",x={df=328,dp=624,gm=475,bp=176},y={df=217,dp=216,gm=216,bp=216}},
    {code="@1280342",x={df=400,dp=765,gm=400,bp=40},y={df=95,dp=145,gm=95,bp=145}},
    {code="@1596270",x={df=680,dp=690,gm=120,bp=120},y={df=90,dp=250,gm=90,bp=250}},
    {code="@2386206",x={df=540,dp=254,gm=610,bp=190},y={df=291,dp=290,gm=106,bp=106}},
    {code="@1888080",x={df=400,dp=400,gm=400,bp=400},y={df=306,dp=308,gm=308,bp=306}},
    {code="@4550458",x={df=478,dp=322,gm=18,bp=780},y={df=166,dp=164,gm=160,bp=160}},
    {code="@1273114",x={df=700,dp=399,gm=105,bp=399},y={df=337,dp=322,gm=337,bp=322}},
    {code="@1276664",x={df=489,dp=745,gm=230,bp=20},y={df=205,dp=205,gm=205,bp=205}},
    {code="@2055551",x={df=430,dp=430,gm=430,bp=430},y={df=305,dp=305,gm=305,bp=305}},
    {code="@2336044",x={df=550,dp=725,gm=250,bp=75},y={df=85,dp=135,gm=85,bp=135}},
    {code="@1420943",x={df=175,dp=630,gm=68,bp=730},y={df=254,dp=254,gm=95,bp=95}},
    {code="@3497786",x={df=293,dp=532,gm=701,bp=115},y={df=159,dp=82,gm=144,bp=105}},
    {code="@1459902",x={df=505,dp=292,gm=86,bp=710},y={df=314,dp=314,gm=196,bp=202}},
    {code="@1737915",x={df=700,dp=550,gm=250,bp=100},y={df=320,dp=220,gm=220,bp=320}},
    {code="@2125502",x={df=60,dp=495,gm=725,bp=375},y={df=304,dp=302,gm=325,bp=189}},
    {code="@1666996",x={df=40,dp=760,gm=535,bp=275},y={df=210,dp=210,gm=358,bp=359}},
    {code="@3485425",x={df=680,dp=220,gm=110,bp=410},y={df=112,dp=360,gm=112,bp=139}},
    {code="@4741135",x={df=760,dp=265,gm=760,bp=263},y={df=173,dp=173,gm=173,bp=261}},
    {code="@3479878",x={df=600,dp=740,gm=63,bp=195},y={df=87,dp=223,gm=223,bp=87}},
    {code="@1967362",x={df=200,dp=590,gm=590,bp=200},y={df=145,dp=145,gm=145,bp=145}},
    {code="@2155997",x={df=20,dp=205,gm=770,bp=570},y={df=209,dp=209,gm=209,bp=209}},
    {code="@3242517",x={df=750,dp=95,gm=700,bp=55},y={df=156,dp=347,gm=347,bp=156}},
    {code="@2135605",x={df=28,dp=615,gm=190,bp=770},y={df=109,dp=109,gm=109,bp=109}},
    {code="@1424739",x={df=600,dp=508,gm=400,bp=196},y={df=300,dp=310,gm=301,bp=288}},
    {code="@1306592",x={df=757,dp=45,gm=218,bp=588},y={df=130,dp=127,gm=126,bp=132}},
    {code="@1648013",x={df=660,dp=140,gm=400,bp=400},y={df=135,dp=135,gm=165,bp=165}},
    {code="@1296949",x={df=630,dp=630,gm=175,bp=175},y={df=319,dp=168,gm=168,bp=319}},
    {code="@869836",x={df=605,dp=70,gm=195,bp=735},y={df=288,dp=164,gm=288,bp=163}},
    {code="@1525751",x={df=300,dp=685,gm=496,bp=116},y={df=229,dp=93,gm=230,bp=93}},
    {code="@1057753",x={df=400,dp=400,gm=130,bp=675},y={df=268,dp=268,gm=183,bp=183}},
    {code="@6215497",x={df=58,dp=738,gm=293,bp=509},y={df=95,dp=95,gm=146,bp=146}},
    {code="@5928493",x={df=474,dp=695,gm=220,bp=101},y={df=290,dp=175,gm=115,bp=360}},
}
--[[ End of file tables/maps.lua ]]--
--[[ File tables/shopTables.lua ]]--
artists={a="Artgir#0000"}
stuff={
    [12]={ --cannons
        {id=1,inShop="16b383ef724",right="16b383ed9fc",left="16b3849205d",w=35,h=35,x=-16,y=-17,xl=-17,yl=-17,req=50,text="win",type=2,artist=artists.a},
        {id=2,inShop="16b383e9fdd",right="16b383e8224",left="16b3849034d",w=35,h=35,x=-17,y=-17,xl=-18,yl=-17,req=100,text="win",type=2,artist=artists.a},
        {id=3,inShop="16b383fb8a8",right="16b383f9ba2",left="16b3849613d",w=36,h=37,x=-18,y=-18,xl=-18,yl=-16,req=200,text="win",type=2,artist=artists.a},
        {id=4,inShop="16b347683d6",right="16b3396b4d3",left="16b339697be",w=35,h=35,x=-18,y=-16,xl=-17,yl=-18,req=10,text="level",type=4,artist=artists.a}, --win 65
        {id=5,inShop="16b383f60d3",right="16b383f436d",left="16b38493d93",w=36,h=36,x=-19,y=-18,xl=-16,yl=-18,req=15,text="level",type=4,artist=artists.a}, --win 135
        {id=6,inShop="16b38401212",right="16b383ff4c7",left="16b38497e79",w=37,h=36,x=-20,y=-18,xl=-17,yl=-19,req=25,text="level",type=4,artist=artists.a}, --win 350
    },

    [13]={ --planks
        {id=1,inShop="16b38645890",right="16b38645890",w=102,h=11,x=-50,y=-6,req=600,text="exp",type=6,artist=artists.a}, --win 120
        {id=2,inShop="16b3396eece",right="16b3396eece",w=100,h=11,x=-50,y=-6,req=1100,text="exp",type=2,artist=artists.a}, --win 220 
        {id=3,inShop="16b386492ee",right="16b386492ee",w=102,h=11,x=-50,y=-6,req=1500,text="exp",type=2,artist=artists.a}, --win 300
        {id=4,inShop="16b38643b7b",right="16b38643b7b",w=102,h=11,x=-50,y=-6,req=13,text="maxP",type=10,artist=artists.a},
        {id=5,inShop="16b3396d1d2",right="16b3396d1d2",w=100,h=11,x=-50,y=-6,req=20,text="maxC",type=9,artist=artists.a},
        {id=6,inShop="16b386475a2",right="16b386475a2",w=102,h=11,x=-50,y=-6,req=7,text="maxV",type=11,artist=artists.a},
    },

    [14]={ --anvils
        {id=1,inShop="16b503a21b9",right="16b503a21b9",w=50,h=28,x=-24,y=-14,req=300,text="play",type=1,artist=artists.a},
        {id=2,inShop="16b33971db2",right="16b33971db2",w=50,h=40,x=-24,y=-26,req=500,text="play",type=1,artist=artists.a},
        {id=3,inShop="16b503a042d",right="16b503a042d",w=50,h=28,x=-24,y=-14,req=20,text="level",type=4,artist=artists.a}, --win 230
        --[[{id=4,inShop="16b33971db2",right="16b33971db2",w=50,h=40,x=-24,y=-26,req=0,text="win",type=2,artist=artists.a},
        {id=5,inShop="16b33971db2",right="16b33971db2",w=50,h=40,x=-24,y=-26,req=0,text="win",type=2,artist=artists.a},
        {id=6,inShop="16b33971db2",right="16b33971db2",w=50,h=40,x=-24,y=-26,req=0,text="win",type=2,artist=artists.a},]]
    },
}
--[[ End of file tables/shopTables.lua ]]--
--[[ End of directory tables ]]--
--[[ Directory translations ]]--
--[[ File translations/ar.lua ]]--
translations.ar={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="يجب أن يوجد على الأقل 6 لاعبين بنقابات مختلفة حتى يتم حفظ البيانات.",
    lgs="اللغات المتاحة هي",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>مرحبًا في  <b><J>#Warzone</J></b>, في هذه اللعبة هدفك العمل مع أعضاء نقابتك لهزيمة باقي النقابات, يُمكنك تغيير سلاحك بواسطة <b><J>الضغط على زر 1،2 أو 3</J></b>, يُمكنك الهجوم بواسطة <b><J>زر أسفل</J></b> أو <b><J>الضغط على زر المسافة</J></b>, لديك حد أقصى لكل سلاح، يتم زيادة الحد الأقصى <b><J>بزيادة المستوى</J></b>\n\n<b>يجب أن لا تقتل أعضاء نقابتك!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>الأوامر</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> أو <b><J>زر H</J></b> - عرض معلومات حول اللعبة.\n<b><J>!profile</J> [Name#0000]</b> أول <b><J>زر P</J></b> - عرض ملفك الشخصي أو الملف الشخصي للاعب آخر.\n<b><J>!guild</J></b> أو <b><J>زر G</J></b> - عرض الملف الشخصي لنقابتك.\n<b><J>!shop</J></b> أو <b><J>زر O</J></b> - عرض المتجر.\n<b><J>!leaderboard</J></b> أو <b><J>زر /</J></b> - عرض قائمة الصدارة العالمية/الغرفة.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - تغيير لغة النمط.",
        "<p align='center'><font size='30' face='Soopafresh'><J>ائتمان</J></font>\n\n\n<p align='left'><font size='12'>هذه اللعبة تم صناعتها بواسطة <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(مطوِّر)</font> و <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(رسّامة)</font>.\n\n<b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> - الترجمة العربية",
    },
    room="الغرفة",
    global="العالمية",
    name="الاسم",
    winsB="الفوز",
    commu="المجتمع",
    quests={
        play="العب <FC>%s</FC> / <FC>%s</FC> جولة.",
        win="اكسب <FC>%s</FC> / <FC>%s</FC> جولة",
        exp="اجمع <FC>%s</FC> / <FC>%s</FC> نقطة خبرة كليًا.",
        level="كُن في المستوى <FC>%s</FC> / <FC>%s</FC>.",
        maxC="اجعل الحد الأقصى للكرات <FC>%s</FC> / <FC>%s</FC>.",
        maxV="اجعل الحد الأقصى للسنادين <FC>%s</FC> / <FC>%s</FC>.",
        maxP="اجعل الحد الأقصى للخشب <FC>%s</FC> / <FC>%s</FC>.",
    },
    next="التالي",
    pre="السابق",
    eq="استعمال",
    uneq="نزع",
    disabled="غير متاحة",
    lvlup="لقد وصلت للمستوى <J>%s</J>!",
    wrong="يجب أن تنضم لنقابة حتى تستعمل هذه الميزة",
    no="لا يُمكنك مغادرة نقابتك الآن، رجاءً حاول مجددًا لاحقًا.",
    full="هذه النقابة ممتلئة باللاعبين.",
    join="انضمام",
    level="المستوى",
    rounds="الجولات الملعوبة",
    wins="مرات الفوز",
    lost="مرات الخسارة",
    close="إغلاق",
    members="الأعضاء",
    leave="مغادرة",
    gm="أعضاء نقابتك هم:-"
}
--[[ End of file translations/ar.lua ]]--
--[[ File translations/en.lua ]]--
translations.en={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="There should be at least six players from different guilds to save the data.",
    lgs="The available languages are",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>Welcome to <b><J>#Warzone</J></b>, in this game your aim is to work together with your guild's members to defeat the other guilds, you can change your weapon by <b><J>perssing 1,2 or 3 buttons</J></b>, you can attack by <b><J>ducking</J></b> or <b><J>pressing Space Bar</J></b>, you have limits of each weapon, they're increased by <b><J>upgrading in levels</J></b>\n\n<b>YOU SHOULDN'T KILL YOUR GUILD'S MEMBERS!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>Commands</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> or <b><J>H button</J></b> - Displays info about the game.\n<b><J>!profile</J> [Name#0000]</b> or <b><J>P button</J></b> - Displays your or someone else's profile.\n<b><J>!guild</J></b> or <b><J>G button</J></b> - Displays your guild's profile.\n<b><J>!shop</J></b> or <b><J>O button</J></b> - Displays the shop.\n<b><J>!leaderboard</J></b> or <b><J>L button</J></b> - Displays the room/global leaderboard.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - Changes the language of the module.",
        "<p align='center'><font size='30' face='Soopafresh'><J>Credits</J></font>\n\n\n<p align='left'><font size='12'>This game was developed by <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Developer)</font> and <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Artist)</font>.\n\n<b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> - EN Translation",
    },
    room="Room",
    global="Global",
    name="Name",
    winsB="Wins",
    commu="Community",
    quests={
        play="Play <FC>%s</FC> / <FC>%s</FC> rounds.",
        win="Win <FC>%s</FC> / <FC>%s</FC> rounds.",
        exp="Collect <FC>%s</FC> / <FC>%s</FC> EXP point in total.",
        level="Reach level <FC>%s</FC> / <FC>%s</FC>.",
        maxC="Reach the limits of <FC>%s</FC> / <FC>%s</FC> cannons.",
        maxV="Reach the limits of <FC>%s</FC> / <FC>%s</FC> anvils.",
        maxP="Reach the limits of <FC>%s</FC> / <FC>%s</FC> planks.",
    },
    next="Next",
    pre="Previous",
    eq="Equip",
    uneq="Unequip",
    disabled="Disabled",
    lvlup="You have reached level <J>%s</J>!",
    wrong="You must join a guild to use this feature.",
    no="You can't leave your guild now, please try again later.",
    full="This guild is full of players.",
    join="Join",
    level="Level",
    rounds="Played rounds",
    wins="Wins",
    lost="Lost rounds",
    close="Close",
    members="Members",
    leave="Leave",
    gm="Your guild's members are:-"
}
--[[ End of file translations/en.lua ]]--
--[[ File translations/es.lua ]]--
translations.es={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="Deben haber al menos 4 jugadores de diferentes equipos para guardar datos.",
    lgs="Los idiomas disponibles son",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>Bienvenido a <b><J>#Warzone</J></b>, el objetivo de este juego trabajar junto con los miembros de tu equipo para defenderse de los otros, podés cambiar tu arma <b><J>presionando los botones 1, 2 o 3</J></b>, podés atacar <b><J>agachándote</J></b> o <b><J>presionando la barra espaciadora</J></b>, tenés limites en cada arma, los cuales son incrementados al <b><J>mejorar en nivel</J></b>\n\n<b>¡NO DEBES MATAR A LOS MIEMBROS DE TU EQUIPO!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>Comandos</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> o la <b><J>tecla H</J></b> - Muestra información sobre el juego.\n<b><J>!profile</J> [Nombre#0000]</b> o la <b><J>tecla P</J></b> - Muestra el perfil de alguien.\n<b><J>!guild</J></b> o la <b><J>tecla G</J></b> - Muestra el perfil de tu equipo.\n<b><J>!shop</J></b> o la <b><J>tecla O</J></b> - Abre la tienda.\n<b><J>!leaderboard</J></b> o la <b><J>tecla L</J></b> - Muestra el ranking global/de la sala.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - Cambia el idioma del juego.",
        "<p align='center'><font size='30' face='Soopafresh'><J>Créditos</J></font>\n\n\n<p align='left'><font size='12'>Este juego fue diseñado por <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Developer)</font> y <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Artista)</font>.\n\n<b><BV>Tocutoeltuco</BV><V><font size='10'>#0000</font></V></b> - Traducción ES",
    },
    room="Sala",
    global="Global",
    name="Nombre",
    winsB="Victorias",
    commu="Comunidad",
    quests={
        play="Jugar <FC>%s</FC> / <FC>%s</FC> rondas.",
        win="Ganar <FC>%s</FC> / <FC>%s</FC> rondas.",
        exp="Obtener <FC>%s</FC> / <FC>%s</FC> puntos de experiencia en total.",
        level="Alcanzar el nivel <FC>%s</FC> / <FC>%s</FC>.",
        maxC="Alcanzar el límite de <FC>%s</FC> / <FC>%s</FC> cañones.",
        maxV="Alcanzar el límite de <FC>%s</FC> / <FC>%s</FC> yunques.",
        maxP="Alcanzar el límite de <FC>%s</FC> / <FC>%s</FC> tablas.",
    },
    next="Siguiente",
    pre="Previo",
    eq="Equipar",
    uneq="Quitar",
    disabled="Desactivado",
    lvlup="¡Alcanzaste el nivel <J>%s</J>!",
    wrong="Debes entrar en un equipo para usar esta característica.",
    no="No puedes dejar tu equipo ahora, por favor intenta mas tarde.",
    full="Este equipo está lleno.",
    join="Entrar",
    level="Nivel",
    rounds="Rondas jugadas",
    wins="Victorias",
    lost="Rondas perdidas",
    close="Cerrar",
    members="Miembros",
    leave="Salir",
    gm="Los miembros de tu equipo son:-"
}
--[[ End of file translations/es.lua ]]--
--[[ File translations/hu.lua ]]--
translations.hu={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="Az adatok elmentéséhez legalább 6 játékosnak kell lennie különböző céhekből.",
    lgs="Elérhető nyelvek",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>Üdvözlünk a <b><J>#Warzone</J></b> Modulban! Ebben a játékban az a cél, hogy együtt dolgozz a céhed tagjaival és legyőzzétek a többi céhet. Megváltoztathatod a fegyvered az <b><J>1-es, 2-es vagy a 3-mas gomb lenyomásával</J></b>, támadhatsz a <b><J>lefele gomb</J></b> vagy a <b><J>Szóköz gomb</J></b> megnyomásával. Minden fegyver korlátozva van, ezek <b><J>szintlépéssel</J></b> megnőnek.\n\n<b>A CÉHED TAGJAIT NE ÖLD MEG!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>Parancsok</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> vagy <b><J>H gomb</J></b> - Megjeleníti a játék információit.\n<b><J>!profile</J> [Név#0000]</b> vagy <b><J>P gomb</J></b> - Megjeleníti valaki profilját.\n<b><J>!guild</J></b> vagy <b><J>G gomb</J></b> - Megjeleníti a céhed profilját.\n<b><J>!shop</J></b> vagy <b><J>O gomb</J></b> - Megjeleníti a boltot.\n<b><J>!leaderboard</J></b> vagy <b><J>L gomb</J></b> - Megjeleníti a szoba/globális ranglistát.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - Megváltoztatja a Modul nyelvét.",
        "<p align='center'><font size='30' face='Soopafresh'><J>Kreditek</J></font>\n\n\n<p align='left'><font size='12'>Ezt a játékot készítette <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Fejlesztő)</font> és <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Művész)</font>.\n\n<b><BV>Weth</BV><V><font size='10'>#9837</font></V></b> - HU Fordítás",
    },
    room="Szoba",
    global="Globális",
    name="Név",
    winsB="Győzelmek",
    commu="Közösség",
    quests={
        play="Játssz <FC>%s</FC> / <FC>%s</FC> kört.",
        win="Nyerj <FC>%s</FC> / <FC>%s</FC> kört.",
        exp="Gyűjts össze <FC>%s</FC> / <FC>%s</FC> EXP pontot.",
        level="Érd el a <FC>%s</FC> / <FC>%s</FC> szintet.",
        maxC="Érd el az ágyú <FC>%s</FC> / <FC>%s</FC> határait.",
        maxV="Érd el az üllő <FC>%s</FC> / <FC>%s</FC> határait.",
        maxP="Érd el a deszka <FC>%s</FC> / <FC>%s</FC> határait.",
    },
    next="Következő",
    pre="Előző",
    eq="Felvesz",
    uneq="Levesz",
    disabled="Tiltva",
    lvlup="Elérted a <J>%s</J> szintet!",
    wrong="Ennek a funkciónak a használatához csatlakoznod kell egy céhez.",
    no="Most már nem hagyhatod el a céhed, kérlek próbálkozz később.",
    full="Ez a céh tele van játékosokkal.",
    join="Csatlakozás",
    level="Szint",
    rounds="Játszott körök",
    wins="Győzelmek",
    lost="Elvesztett körök",
    close="Bezárás",
    members="Tagok",
    leave="Elhagyás",
    gm="A céhed tagjai: -"
}
--[[ End of file translations/hu.lua ]]--
--[[ File translations/pl.lua ]]--
translations.pl={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="By zapisać postęp, potrzeba przynajmniej 6 osób z innych gildii.",
    lgs="Dostępne języki",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>Witaj w<b><J>#Warzone</J></b>, w tej grze twoim celelem jest współpraca z członkami twojej gildii , by pokonać inne gildie, możesz zmienić swoją broń  <b><J>używając klawiszy 1,2 lub 3 </J></b>, atakujesz <b><J>strzałką w dół</J></b> lub <b><J>Spacją</J></b>, masz ograniczoną ilość każdej broni, możesz zwiększyć ten limit poprzez <b><J>ulepszanie poziomów</J></b>\n\n<b>NIE ZABIJAJ SOJUSZNIKÓW!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>Komendy</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> lub <b><J> klawisz H </J></b> - Wyświetla informacje o grze. \n<b><J>!profile</J> [Name#0000]</b> lub <b><J> klawisz P </J></b> - Wyświetla twój profil (lub innego gracza). \n<b><J>!guild</J></b> lub <b><J> klawisz G </J></b> - Wyświetla profil twojej gildii.\n<b><J>!shop</J></b> lub <b><J>klawisz O</J></b> - Wyświetla sklep.\n<b><J>!leaderboard</J></b> lub <b><J>klawisz L</J></b> - Wyświetla tabelę wyników pokoju / globalną tabelę wyników.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - Zmienia język pokoju.",
        "<p align='center'><font size='30' face='Soopafresh'><J>Podziękowania</J></font>\n\n\n<p align='left'><font size='12'>Gra jest rozwijana przez <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Developer)</font> i <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Artist)</font>.\n\n<b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> - PL Translation",
    },
    room="Pokój",
    global="Globalna",
    name="Nazwa",
    winsB="Wygrane",
    commu="Społeczność",
    quests={
        play="Zagraj <FC>%s</FC> / <FC>%s</FC> rundy.",
        win="Wygraj <FC>%s</FC> / <FC>%s</FC> rundy.",
        exp="Zbierz <FC>%s</FC> / <FC>%s</FC> EXP całkowicie.",
        level="Zdobądź poziom <FC>%s</FC> / <FC>%s</FC>.",
        maxC="Dojdź do limitu <FC>%s</FC> / <FC>%s</FC> kul armatnich.",
        maxV="Dojdź do limitu <FC>%s</FC> / <FC>%s</FC> kowadeł.",
        maxP="Dojdź do limitu <FC>%s</FC> / <FC>%s</FC> desek.",
    },
    next="Następny",
    pre="Poprzedni",
    eq="Załóż",
    uneq="Zdejmij",
    disabled="Wyłączone",
    lvlup="Zdobyłeś poziom <J>%s</J>!",
    wrong="By użyć tej opcji, musisz dołączyć do gildii ",
    no="Nie możesz teraz opuścić tej gildii, spróbuj później.",
    full="Ta gildia jest pełna.",
    join="Dołącz",
    level="Poziom",
    rounds="Zagrane rundy",
    wins="Wygrane",
    lost="Przegrane rundy",
    close="Zamknij",
    members="Członkowie",
    leave="Opuść",
    gm="Członkowie twojej gildii to:-"
}
--[[ End of file translations/pl.lua ]]--
--[[ File translations/ro.lua ]]--
translations.ro={
    teams={
        df="Dragon Fist",
        dp="Blue Pegasus",
        gm="Green Mermaid",
        bp="Sabertooth"
    },
    toSave="Trebuie să fie cel puțin şase jucători în sală pentru a salva.",
    lgs="The available languages are",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><J>#WarZone</J></font>\n\n<p align='left'><font size='12'>Bine ai venit pe <b><J>#Warzone</J></b>, în acest joc trebuie să lucrezi cu coechipierii pentru a omorî șoarecii din celelalte clanuri, îți poți schimba arma <b><J>apăsând pe butoanele 1, 2 sau 3</J></b>, poți ataca <b><J>apăsând în jos</J></b> sau <b><J>apăsând Space</J></b>, fiecare armă are limite și le poți extinde <b><J>crescându-ți nivelul.</J></b>\n\n<b>NU-ȚI OMORÎ COECHIPIERII!</b>",
        "<p align='center'><font size='30' face='Soopafresh'><J>Comenzi</J></font>\n\n<p align='left'><font size='12'><b><J>!help</J></b> sau <b><J>butonul H</J></b> - Afișează informații despre joc.\n<b><J>!profile</J> [Nume#0000]</b> sau <b><J>butonul P</J></b> - Arată profilul unei persoane.\n<b><J>!guild</J></b> sau <b><J>butonul G</J></b> - Arată prfilul clanului tău.\n<b><J>!shop</J></b> sau <b><J>butonul O</J></b> - Deschide magazinul.\n<b><J>!leaderboard</J></b> sau <b><J>butonul L</J></b> - Arată leaderboardul din sală/global.\n<b><J>!lang</J> [<a href='event:langs'>XX</a>]</b> - Schimbă limba modulului.",
        "<p align='center'><font size='30' face='Soopafresh'><J>Credits</J></font>\n\n\n<p align='left'><font size='12'>Jocul este dezvoltat de <b><BV>Bodykudo</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Developer)</font> și <b><BV>Artgir</BV><V><font size='10'>#0000</font></V></b> <font size='10'>(Artist)</font>.\n\n<b><BV>Sergiubucur</BV><V><font size='10'>#0000</font></V></b> - traducerea în RO",
    },
    room="Sală",
    global="Global",
    name="Nume",
    winsB="Câștiguri",
    commu="Comunitate",
    quests={
        play="Joacă <FC>%s</FC> / <FC>%s</FC> runde.",
        win="Câștigă <FC>%s</FC> / <FC>%s</FC> runde.",
        exp="Colectează <FC>%s</FC> / <FC>%s</FC> experiență în total.",
        level="Atinge level <FC>%s</FC> / <FC>%s</FC>.",
        maxC="Atinge limita de <FC>%s</FC> / <FC>%s</FC> ghiulele.",
        maxV="Atinge limita de <FC>%s</FC> / <FC>%s</FC> nicovale.",
        maxP="Atinge limita de <FC>%s</FC> / <FC>%s</FC> scânduri.",
    },
    next="Următorul",
    pre="Înapoi",
    eq="Echipează",
    uneq="Dezechipează",
    disabled="Dezactivat",
    lvlup="Ai atins nivelul <J>%s</J>!",
    wrong="Trebuie să intri într-un clan pentrua folosi opțiunea.",
    no="Nu poți părăsi clanul acum, încearcă mai târziu.",
    full="Clanul acesta este plin.",
    join="Alătură-te",
    level="Nivel",
    rounds="Runde jucate",
    wins="Câștiguri",
    lost="Runde pierdute",
    close="Închide",
    members="Membrii",
    leave="Părăsește",
    gm="Membrii clanului sunt:-"
}
--[[ End of file translations/ro.lua ]]--
--[[ End of directory translations ]]--
--[[ Directory systems ]]--
--[[ File systems/dataSystem.lua ]]--
inRoomModule=tfm.get.room.isTribeHouse and false or true
intRoom=tfm.get.room.name:sub(1,1)=="*"
moduleName="o"
loadedData={}

local gmatch, sub, match = string.gmatch, string.sub, string.match
local splitter = "\1"

function stringToTable(str, tab, splitChar)
    local split = splitter..string.char(splitChar)
    for i in gmatch(str, '[^'..split..']+') do
        local index, value = match(i, '(.-)=(.*)')
        local indexType, index, valueType, value = sub(index, 1, 1), sub(index, 2), sub(value, 1, 1), sub(value, 2)
        if indexType == "s" then
            index = tostring(index)
        elseif indexType == "n" then
            index = tonumber(index)
        end
        if valueType == 's' then
            tab[index] = tostring(value)
        elseif valueType == 'n' then
            tab[index] = tonumber(value)
        elseif valueType == 'b' then
            tab[index] = value == '1'
        elseif valueType == 't' then
            tab[index] = {}
            stringToTable(value,tab[index], splitChar + 1)
        end
    end
end

function tableToString(index, value, splitChar)
    local sep = splitter..string.char(splitChar)
    local str = type(index) == 'string' and 's'..index..'=' or 'n'..index..'=' 
    if type(value) == 'table' then
        local tab = {}
        for i, v in next, value do
            tab[#tab + 1] = tableToString(i,v,splitChar+1)
        end
        str = str .. 't' .. table.concat(tab, sep)
    elseif type(value) == 'number' then
        str = str .. 'n' .. tostring(value)
    elseif type(value) == 'boolean' then
        str = str .. 'b' .. (value and '1' or '0')
    elseif type(value) == 'string' then
        str = str .. 's' .. value
    end
    return str
end

function eventPlayerDataLoaded(n, pD)
    if pD:find("hunter")~=nil or pD:find("myhero")~=nil or pD:find("sniper")~=nil or pD:find("*m") then
        system.savePlayerData(n,"")
        pD=""
    end
    loadedData[n] = {}
    for i in gmatch(pD, "[^\0]+") do
        local moduleName = match(i, "s([^=]+)")
        local str = sub(i, #moduleName+4)
        loadedData[n][moduleName] = {}
        stringToTable(str,loadedData[n][moduleName], 1)
    end
    if loadedData[n]["f"] then loadedData[n]["f"] =nil end
    if loadedData[n]["w"] then loadedData[n]["w"] =nil end
    if loadedData[n]["z"] then loadedData[n]["z"] =nil end
    for i, v in next, loadedData[n][moduleName] or {} do
        data[n][i]=v 
    end
    loadedData[n][moduleName]=data[n]
    if tfm.get.room.playerList[n] then
        data[n][15]=tfm.get.room.playerList[n].community
    end
end

function saveData(name)
    if loadedData[name] then
        local res = {}
        for module, data in next, loadedData[name] do
            res[#res + 1] = tableToString(module,data,1)
        end
        system.savePlayerData(name, table.concat(res, "\0"))
    end
end
--[[ End of file systems/dataSystem.lua ]]--
--[[ File systems/gameplay.lua ]]--
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
--[[ End of file systems/gameplay.lua ]]--
--[[ File systems/mapsSystem.lua ]]--
lastMap,currMap=0,1
function newMap()
    currMap=math.random(#maps)
    while lastMap==currMap do
        currMap=math.random(#maps)
    end
    lastMap=currMap
    tfm.exec.newGame(maps[currMap].code)
end

function newGame()
    if play then
        newMap()
    else
        tfm.exec.newGame("@6760470")
    end
end
--[[ End of file systems/mapsSystem.lua ]]--
--[[ File systems/rankingSystem.lua ]]--
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

gbPl=deepcopy(data)
lb_gbPl={}

function sort_gb(t)
    local lb1, lb = {} , {}
    for name in next, t do
        lb1[#lb1 + 1] = {name, t[name][2]}
    end
    repeat
        local a, max_Val = -math.huge , 1
        for i = 1, #lb1 do
            if lb1[i][2] > a then
                a = lb1[i][2]
                max_Val = i
            end
        end
        table.insert(lb, lb1[max_Val][1])
        table.remove(lb1, max_Val)
    until #lb1 == 0
    return lb
end

function eventFileLoaded(fN, fD)
    if fN=="2" then
    	gbPl = deepcopy(data)
    	for n in pairs(gbPl) do
      		gbPl[n][1] = gbPl[n][2]
      	end
        for n in fD:gmatch("[^$]+") do 
            local t = {}
            for k in n:gmatch("[^,]+") do 
                table.insert(t, k)
            end
            if not gbPl[t[1]] then
                gbPl[t[1]] = {t[2], tonumber(t[3])}
            end
        end
    	lb_gbPl = sort_gb(gbPl)
        local t = ""
        for i=1,50 do
            if lb_gbPl[i] then
                local n = lb_gbPl[i]
                if n:sub(0,1)~="*" then
                	t=t..""..n..","..gbPl[n][1]..","..gbPl[n][2].."$"
                end
            end
        end
        t = t:sub(#t) == "$" and t:sub(0,#t-1) or t
        if inRoomModule and not intRoom then
            system.saveFile(t,2)
        end
    end
end

function rankPlayers()
    prs={}
    for n in pairs(data) do
        if tfm.get.room.playerList[n] then
            table.insert(prs,n)
        end
    end
    maxPlayers={}
    while (#prs~=0) do
        mS=-1
        mp=nil
        for i,n in pairs (prs) do
            if mS < data[n][2] then
                mS=data[n][2]
                mP=n
                idRa=i
            end
        end
        table.insert(maxPlayers,{mP,mS})
        table.remove(prs,idRa)
    end
    return maxPlayers
end
--[[ End of file systems/rankingSystem.lua ]]--
--[[ File systems/translateSystem.lua ]]--
function setLang(n)
    text[n]=translations[tfm.get.room.playerList[n].community] or translations.en
end
--[[ End of file systems/translateSystem.lua ]]--
--[[ File systems/UI.lua ]]--
function ui.addPopup(id,title,content,n,x,y,w,h,opacity,fixed,type,button)
    w=w or 200
    h=h or 100
    x=x or (800-w)/2
    y=y or (400-h)/2
    hasButton=button and true or false
    ui.addTextArea(45 .. id .. 95 .. 1,content, n,x,y, w, h, 0x142b2e,0x8a583c,opacity,fixed)
    if title then
        ui.addTextArea(45 .. id .. 95 .. 2,"",n,x - 5,y - 5,w + 10,12,0x27373F,0x27373F,opacity,fixed)
        ui.addTextArea(45 .. id .. 95 .. 12, "<p align='center'><font size='15' color='#009D9D'><b>"..title.."</b></font></p>",n,x - 5,y - 10,nil,nil,0xFF0000,0xFF0000,0,fixed)
    end
    if hasButton then
        popup.addButton(id+2565+1,button.c,n,button.e,x+6,y+h-15,w-12,nil,fixed)
    end
end
 
function ui.closePopup(id,n)
    ui.removeTextArea(45 .. id .. 95 .. 1, n)
    ui.removeTextArea(45 .. id .. 95 .. 2, n)
    ui.removeTextArea(45 .. id .. 95 .. 12, n)
    ui.removeButton(id+2565+1, n)
end

function ui.addButton(id,content,n,event,x,y,w,h,fixed)
    w=w or 180
    h=h or 10
    x=x or (800-w)/2
    y=y or (400-h)/2
    content=content or ""
    event=event or ""
    ui.addTextArea(45 .. id .. 94 .. 2, "", n, x - 1, y - 1, w, h, 0x648FA4, 0x648FA4, f1, fixed)
    ui.addTextArea(45 .. id .. 94 .. 3, "", n, x + 1, y + 1, w, h, 0x142b2e, 0x142b2e, f1, fixed)
    ui.addTextArea(45 .. id .. 94 .. 1, "", n, x, y, w, h, 0x27373F, 0x27373F, f1, fixed)
    if event~="" then
        ui.addTextArea(45 .. id .. 94 .. 4, "<a href='event:"..event.."'>"..content.."</a>", n, x, y - 3.25, w, h + 10, 0xFF0000, 0xFF0000, 0, fixed)
    else
        ui.addTextArea(45 .. id .. 94 .. 4, content, n, x, y - 3.25, w, h + 10, 0xFF0000, 0xFF0000, 0, fixed)
    end
end
 
function ui.removeButton(id,n)
    ui.removeTextArea(45 .. id .. 94 .. 1, n)
    ui.removeTextArea(45 .. id .. 94 .. 2, n)
    ui.removeTextArea(45 .. id .. 94 .. 3, n)
    ui.removeTextArea(45 .. id .. 94 .. 4, n)
end

function ui.timerImage(img,x,y,n,time)
    time=time or 5
    local img=tfm.exec.addImage(img..".png","&0",x,y,n)
    system.newTimer(function()
        tfm.exec.removeImage(img,n)
    end,time*1000,false)
end
--[[ End of file systems/UI.lua ]]--
--[[ End of directory systems ]]--
--[[ Directory menus ]]--
--[[ File menus/guild.lua ]]--
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
--[[ End of file menus/guild.lua ]]--
--[[ File menus/help.lua ]]--
function ws.help(n)
    close(n)
    ui.addPopup(1,nil,text[n].help[p[n].hPage],n,nil,nil,320,230,1,true,3)
    ui.addButton(1,"<p align='center'>"..text[n].close,n,"close",nil,300,100,10,true)
    ui.addButton(2,"<p align='center'>"..text[n].next,p[n].hPage==3 and "n" or n,"nextHelp",470,300,70,10,true)
    ui.addButton(3,"<p align='center'>"..text[n].pre,p[n].hPage==1 and "n" or n,"preHelp",260,300,70,10,true)
end
--[[ End of file menus/help.lua ]]--
--[[ File menus/leaderboard.lua ]]--
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
--[[ End of file menus/leaderboard.lua ]]--
--[[ File menus/profile.lua ]]--
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
--[[ End of file menus/profile.lua ]]--
--[[ File menus/shop.lua ]]--
function ws.shop(n,cannon,plank,anvil)
    close(n)
    ui.addButton(7,cannon and "<p align='center'>Planks</p>" or "<p align='center'>Cannons</p>",n,cannon and "planks" or "cannons",125,70,70,13,true)
    ui.addButton(8,cannon and "<p align='center'>Anvils</p>" or (plank and "<p align='center'>Anvils</p>" or "<p align='center'>Planks</p>"),n,cannon and "anvils" or (plank and "anvils" or "planks"),125,110,70,13,true)
    ui.addPopup(1,nil,"",n,nil,nil,400,280,1,true,3)
    ui.addButton(1,"<p align='center'>"..text[n].close.."</p>",n,"close",nil,320,140,10,true)
    if not plank then
        if cannon then
            p[n].cannonShop,p[n].plankShop,p[n].anvilShop,p[n].shop=true,false,false,12
            ui.addPopup(5,nil,"<p align='center'>"..string.format(text[n].quests[stuff[12][p[n].sub[1]].text],data[n][stuff[12][p[n].sub[1]].type],stuff[12][p[n].sub[1]].req),n,275,90,210,40,1,true,3)
            ui.addPopup(6,nil,"<p align='center'>"..string.format(text[n].quests[stuff[12][p[n].sub[2]].text],data[n][stuff[12][p[n].sub[2]].type],stuff[12][p[n].sub[2]].req),n,275,165,210,40,1,true,3)
            ui.addPopup(7,nil,"<p align='center'>"..string.format(text[n].quests[stuff[12][p[n].sub[3]].text],data[n][stuff[12][p[n].sub[3]].type],stuff[12][p[n].sub[3]].req),n,275,245,210,40,1,true,3)
            ui.addButton(4,data[n][12]==stuff[12][p[n].sub[1]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[12][p[n].sub[1]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[12][p[n].sub[1]].type] >= stuff[12][p[n].sub[1]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][12]==stuff[12][p[n].sub[1]].id and ("uneq_12") or (n==stuff[12][p[n].sub[1]].artist and "eq_12_"..stuff[12][p[n].sub[1]].id or n=="Bodykudo#0000" and "eq_12_"..stuff[12][p[n].sub[1]].id or (data[n][stuff[12][p[n].sub[1]].type] >= stuff[12][p[n].sub[1]].req and "eq_12_"..stuff[12][p[n].sub[1]].id or "")),503,103,80,13,true)
            ui.addButton(5,data[n][12]==stuff[12][p[n].sub[2]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[12][p[n].sub[2]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or  (data[n][stuff[12][p[n].sub[2]].type] >= stuff[12][p[n].sub[2]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][12]==stuff[12][p[n].sub[2]].id and ("uneq_12") or (n==stuff[12][p[n].sub[2]].artist and "eq_12_"..stuff[12][p[n].sub[2]].id or n=="Bodykudo#0000" and "eq_12_"..stuff[12][p[n].sub[2]].id or (data[n][stuff[12][p[n].sub[2]].type] >= stuff[12][p[n].sub[2]].req and "eq_12_"..stuff[12][p[n].sub[2]].id or "")),503,178,80,13,true)
            ui.addButton(6,data[n][12]==stuff[12][p[n].sub[3]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[12][p[n].sub[3]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or  (data[n][stuff[12][p[n].sub[3]].type] >= stuff[12][p[n].sub[3]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][12]==stuff[12][p[n].sub[3]].id and ("uneq_12") or (n==stuff[12][p[n].sub[3]].artist and "eq_12_"..stuff[12][p[n].sub[3]].id or n=="Bodykudo#0000" and "eq_12_"..stuff[12][p[n].sub[3]].id or (data[n][stuff[12][p[n].sub[3]].type] >= stuff[12][p[n].sub[3]].req and "eq_12_"..stuff[12][p[n].sub[3]].id or "")),503,257,80,13,true)
            ui.addButton(2,"<p align='center'>"..text[n].next.."</p>",p[n].shPage==#stuff[12]/3 and "n" or n,"next",490,320,80,10,true)
            ui.addButton(3,"<p align='center'>"..text[n].pre.."</p>",p[n].shPage==1 and "n" or n,"pre",230,320,80,10,true)
            id.shop[1][n]=tfm.exec.addImage(stuff[12][p[n].sub[1]].inShop..".png","&1",205+((65-stuff[12][p[n].sub[1]].w)/2), 75+((65-stuff[12][p[n].sub[1]].h)/2),n)
            id.shop[2][n]=tfm.exec.addImage(stuff[12][p[n].sub[2]].inShop..".png","&2",205+((65-stuff[12][p[n].sub[2]].w)/2), 155+((65-stuff[12][p[n].sub[2]].h)/2),n)
            id.shop[3][n]=tfm.exec.addImage(stuff[12][p[n].sub[3]].inShop..".png","&3",205+((65-stuff[12][p[n].sub[3]].w)/2), 235+((65-stuff[12][p[n].sub[3]].h)/2),n)
        else
            p[n].cannonShop,p[n].plankShop,p[n].anvilShop,p[n].shop=false,false,true,14
            ui.addPopup(5,nil,"<p align='center'>"..string.format(text[n].quests[stuff[14][p[n].sub[1]].text],data[n][stuff[14][p[n].sub[1]].type],stuff[14][p[n].sub[1]].req),n,275,90,210,40,1,true,3)
            ui.addPopup(6,nil,"<p align='center'>"..string.format(text[n].quests[stuff[14][p[n].sub[2]].text],data[n][stuff[14][p[n].sub[2]].type],stuff[14][p[n].sub[2]].req),n,275,165,210,40,1,true,3)
            ui.addPopup(7,nil,"<p align='center'>"..string.format(text[n].quests[stuff[14][p[n].sub[3]].text],data[n][stuff[14][p[n].sub[3]].type],stuff[14][p[n].sub[3]].req),n,275,245,210,40,1,true,3)
            ui.addButton(4,data[n][14]==stuff[14][p[n].sub[1]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[14][p[n].sub[1]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[14][p[n].sub[1]].type] >= stuff[14][p[n].sub[1]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][14]==stuff[14][p[n].sub[1]].id and ("uneq_14") or (n==stuff[14][p[n].sub[1]].artist and "eq_14_"..stuff[14][p[n].sub[1]].id or n=="Bodykudo#0000" and "eq_14_"..stuff[14][p[n].sub[1]].id or (data[n][stuff[14][p[n].sub[1]].type] >= stuff[14][p[n].sub[1]].req and "eq_14_"..stuff[14][p[n].sub[1]].id or "")),503,103,80,13,true)
            ui.addButton(5,data[n][14]==stuff[14][p[n].sub[2]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[14][p[n].sub[2]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[14][p[n].sub[2]].type] >= stuff[14][p[n].sub[2]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][14]==stuff[14][p[n].sub[2]].id and ("uneq_14") or (n==stuff[14][p[n].sub[2]].artist and "eq_14_"..stuff[14][p[n].sub[2]].id or n=="Bodykudo#0000" and "eq_14_"..stuff[14][p[n].sub[2]].id or (data[n][stuff[14][p[n].sub[2]].type] >= stuff[14][p[n].sub[2]].req and "eq_14_"..stuff[14][p[n].sub[2]].id or "")),503,178,80,13,true)
            ui.addButton(6,data[n][14]==stuff[14][p[n].sub[3]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[14][p[n].sub[3]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[14][p[n].sub[3]].type] >= stuff[14][p[n].sub[3]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][14]==stuff[14][p[n].sub[3]].id and ("uneq_14") or (n==stuff[14][p[n].sub[3]].artist and "eq_14_"..stuff[14][p[n].sub[3]].id or n=="Bodykudo#0000" and "eq_14_"..stuff[14][p[n].sub[3]].id or (data[n][stuff[14][p[n].sub[3]].type] >= stuff[14][p[n].sub[3]].req and "eq_14_"..stuff[14][p[n].sub[3]].id or "")),503,257,80,13,true)
            ui.addButton(2,"<p align='center'>"..text[n].next.."</p>",p[n].shPage==#stuff[14]/3 and "n" or n,"next",490,320,80,10,true)
            ui.addButton(3,"<p align='center'>"..text[n].pre.."</p>",p[n].shPage==1 and "n" or n,"pre",230,320,80,10,true)
            id.shop[1][n]=tfm.exec.addImage(stuff[14][p[n].sub[1]].inShop..".png","&1",205+((65-stuff[14][p[n].sub[1]].w)/2), 75+((65-stuff[14][p[n].sub[1]].h)/2),n)
            id.shop[2][n]=tfm.exec.addImage(stuff[14][p[n].sub[2]].inShop..".png","&2",205+((65-stuff[14][p[n].sub[2]].w)/2), 155+((65-stuff[14][p[n].sub[2]].h)/2),n)
            id.shop[3][n]=tfm.exec.addImage(stuff[14][p[n].sub[3]].inShop..".png","&3",205+((65-stuff[14][p[n].sub[3]].w)/2), 235+((65-stuff[14][p[n].sub[3]].h)/2),n)
        end
        ui.addPopup(2,nil,"",n,205,75,65,65,1,true,3)
        ui.addPopup(3,nil,"",n,205,155,65,65,1,true,3)
        ui.addPopup(4,nil,"",n,205,235,65,65,1,true,3)
    else
        p[n].cannonShop,p[n].plankShop,p[n].anvilShop,p[n].shop=false,true,false,13
        ui.addPopup(5,nil,"<p align='center'>\n"..string.format(text[n].quests[stuff[13][p[n].sub[1]].text],data[n][stuff[13][p[n].sub[1]].type],stuff[13][p[n].sub[1]].req),n,215,110,100,120,1,true,3)
        ui.addPopup(6,nil,"<p align='center'>\n"..string.format(text[n].quests[stuff[13][p[n].sub[2]].text],data[n][stuff[13][p[n].sub[2]].type],stuff[13][p[n].sub[2]].req),n,350,110,100,120,1,true,3)
        ui.addPopup(7,nil,"<p align='center'>\n"..string.format(text[n].quests[stuff[13][p[n].sub[3]].text],data[n][stuff[13][p[n].sub[3]].type],stuff[13][p[n].sub[3]].req),n,485,110,100,120,1,true,3)
        ui.addButton(4,data[n][13]==stuff[13][p[n].sub[1]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[13][p[n].sub[1]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[13][p[n].sub[1]].type] >= stuff[13][p[n].sub[1]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][13]==stuff[13][p[n].sub[1]].id and ("uneq_13") or (n==stuff[13][p[n].sub[1]].artist and "eq_13_"..stuff[13][p[n].sub[1]].id or n=="Bodykudo#0000" and "eq_13_"..stuff[13][p[n].sub[1]].id or (data[n][stuff[13][p[n].sub[1]].type] >= stuff[13][p[n].sub[1]].req and "eq_13_"..stuff[13][p[n].sub[1]].id or "")),225,260,80,13,true)
        ui.addButton(5,data[n][13]==stuff[13][p[n].sub[2]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[13][p[n].sub[2]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[13][p[n].sub[2]].type] >= stuff[13][p[n].sub[2]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][13]==stuff[13][p[n].sub[2]].id and ("uneq_13") or (n==stuff[13][p[n].sub[2]].artist and "eq_13_"..stuff[13][p[n].sub[2]].id or n=="Bodykudo#0000" and "eq_13_"..stuff[13][p[n].sub[2]].id or (data[n][stuff[13][p[n].sub[2]].type] >= stuff[13][p[n].sub[2]].req and "eq_13_"..stuff[13][p[n].sub[2]].id or "")),360,260,80,13,true)
        ui.addButton(6,data[n][13]==stuff[13][p[n].sub[3]].id and ("<p align='center'>"..text[n].uneq) or (n==stuff[13][p[n].sub[3]].artist and ("<p align='center'>"..text[n].eq) or  n=="Bodykudo#0000" and ("<p align='center'>"..text[n].eq) or (data[n][stuff[13][p[n].sub[3]].type] >= stuff[13][p[n].sub[3]].req and "<p align='center'>"..text[n].eq or "<p align='center'>"..text[n].disabled)),n,data[n][13]==stuff[13][p[n].sub[3]].id and ("uneq_13") or (n==stuff[13][p[n].sub[3]].artist and "eq_13_"..stuff[13][p[n].sub[3]].id or n=="Bodykudo#0000" and "eq_13_"..stuff[13][p[n].sub[3]].id or (data[n][stuff[13][p[n].sub[3]].type] >= stuff[13][p[n].sub[3]].req and "eq_13_"..stuff[13][p[n].sub[3]].id or "")),495,260,80,13,true)
        ui.addButton(2,"<p align='center'>"..text[n].next.."</p>",p[n].shPage==#stuff[13]/3 and "" or n,"next",490,320,80,10,true)
        ui.addButton(3,"<p align='center'>"..text[n].pre.."</p>",p[n].shPage==1 and "n" or n,"pre",230,320,80,10,true)
        ui.addPopup(2,nil,"",n,205,85,120,20,1,true,3)
        ui.addPopup(3,nil,"",n,340,85,120,20,1,true,3)
        ui.addPopup(4,nil,"",n,475,85,120,20,1,true,3)
        id.shop[1][n]=tfm.exec.addImage(stuff[13][p[n].sub[1]].inShop..".png","&1",205+((120-stuff[13][p[n].sub[1]].w)/2), 85+((20-stuff[13][p[n].sub[1]].h)/2),n)
        id.shop[2][n]=tfm.exec.addImage(stuff[13][p[n].sub[2]].inShop..".png","&2",340+((120-stuff[13][p[n].sub[2]].w)/2), 85+((20-stuff[13][p[n].sub[2]].h)/2),n)
        id.shop[3][n]=tfm.exec.addImage(stuff[13][p[n].sub[3]].inShop..".png","&3",475+((120-stuff[13][p[n].sub[3]].w)/2), 85+((20-stuff[13][p[n].sub[3]].h)/2),n)
    end
end
--[[ End of file menus/shop.lua ]]--
--[[ End of directory menus ]]--
--[[ Directory events ]]--
--[[ File events/eventChatCommand.lua ]]--
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
--[[ End of file events/eventChatCommand.lua ]]--
--[[ File events/eventKeyboard.lua ]]--
function eventKeyboard(n,k,d,x,y)
    if k==0 then
        p[n].right=false
    elseif k==2 then
        p[n].right=true
    elseif keys[k] then
        p[n].shPage=1
        p[n].sub={1,2,3}
        p[n].shop=12
        p[n].lbPage=1
        p[n].globalPage=1
        p[n].hPage=1
        open(n,n,keys[k])
    elseif items[k] and play and not done and started and tfm.get.room.currentMap~="@6760470" and not tfm.get.room.playerList[n].isDead then
        p[n].use=k
        removeBoard(n)
        board(n)
    elseif (k==32 or k==3) and play and not done and started and p[n].timestamp<os.time()-1350 and not tfm.get.room.playerList[n].isDead and p[n].max[p[n].use]>0 and tfm.get.room.currentMap~="@6760470" then
        p[n].objectid=tfm.exec.addShamanObject(items[p[n].use].id,p[n].use==49 and x+(p[n].right and data[n][7] or -data[n][7]) or x+(p[n].right and items[p[n].use].x or -items[p[n].use].x),p[n].use==49 and y+data[n][8] or y,p[n].right and items[p[n].use].angle or -items[p[n].use].angle,p[n].right and items[p[n].use].speed or -items[p[n].use].speed)
        if p[n].use==49 then
            for k,v in pairs(stuff[items[p[n].use].da]) do
                if data[n][items[p[n].use].da]~=0 and v.id==data[n][items[p[n].use].da] then
                    tfm.exec.addImage(p[n].right and v.right..".png" or v.left..".png","#"..tostring(p[n].objectid),p[n].right and v.x or v.xl,p[n].right and v.y or v.yl)
                end
            end
        else
            for k,v in pairs(stuff[items[p[n].use].da]) do
                if data[n][items[p[n].use].da]~=0 and v.id==data[n][items[p[n].use].da] then
                    tfm.exec.addImage(v.right..".png","#"..tostring(p[n].objectid),v.x,v.y)
                end
            end
        end
        p[n].max[p[n].use]=p[n].max[p[n].use]-1
        p[n].timestamp=os.time()
        table.insert(toDespawn,{os.time(),p[n].objectid})
        removeBoard(n)
        board(n)
    end
end
--[[ End of file events/eventKeyboard.lua ]]--
--[[ File events/eventLoop.lua ]]--
function eventLoop(time,remaining)
    var=0
    var2=0
    for i,v in pairs(guilds) do
        if table.count(v.inRoom) > 0 then
            var=var+1
        end
        if table.count(v.inRoom) > 2 then
            var2=var2+1
        end
    end
    if var >= 2 and not play then
        play=true
        if tfm.get.room.currentMap=="@6760470" and startCool then
            startCool=false
            tfm.exec.setGameTime(11)
        end
    end
    if var < 2 and play then
        play=false
        if tfm.get.room.currentMap~="@6760470" then
            tfm.exec.setGameTime(11)
            startCool=true
        end
    end
    if time >= 8000 and play and not started and tfm.get.room.currentMap~="@6760470" then
        started=true
        if newTimer then
            system.removeTimer(newTimer)
        end
        for n in pairs(tfm.get.room.playerList) do
            if p[n].guild~="" then
                board(n)
            end
        end
    end
    if time >= 9000 and timerImg then
        tfm.exec.removeImage(timerImg)
    end
    for i,object in ipairs(toDespawn) do
        if object[1] <= os.time()-1500 then
            tfm.exec.removeObject(object[2])
            table.remove(toDespawn,i)
        end
    end
    if remaining<=0 then
        newGame()
    end
    if os.time()-90000 > updateFileTime then
        system.loadFile(2)
        updateFileTime=os.time()
    end
    for n in pairs(tfm.get.room.playerList) do
        if p[n].timing <= 7 then
            p[n].timing=p[n].timing+0.5
            if p[n].timing==7 then
                if p[n].newImg then tfm.exec.removeImage(p[n].newImg,n) p[n].newImg=nil end
            end
        end
    end
end
--[[ End of file events/eventLoop.lua ]]--
--[[ File events/eventNewGame.lua ]]--
timerTimer,timerImg=""
function eventNewGame()
    save=false
    started=false
    done=false
    for n in pairs(tfm.get.room.playerList) do
        removeBoard(n)
    end
    if timerImg then tfm.exec.removeImage(timerImg) end
    if timerTimer then system.removeTimer(timerTimer) end
    if newTimer then system.removeTimer(newTimer) end
    if play then
        local var2=0
        for i,v in pairs(guilds) do
            if table.count(v.inRoom) > 2 then
                var2=var2+1
            end
        end
        if var2 >= 2 and not save and tfm.get.room.uniquePlayers >= 4 then
            save=true
        end
        for i,v in pairs(guilds) do
            if table.count(v.inRoom) > 0 then
                v.rounds=v.rounds+1
                v.looses=(v.rounds-1)-v.wins
            end
        end
        local currImg=0
        timerTimer=system.newTimer(function()
            newTimer=system.newTimer(function()
                if currImg~=6 then
                    currImg=currImg+1
                end
                if timerImg then tfm.exec.removeImage(timerImg) end
                timerImg=tfm.exec.addImage(times[currImg]..".png","!999",200,100)
            end,1000,true)
        end,2000,false)
        for n in pairs(tfm.get.room.playerList) do
            if not save and inRoomModule and not intRoom then
                tfm.exec.chatMessage("<R>"..text[n].toSave,n)
            end
            if intRoom and inRoomModule then
                tfm.exec.chatMessage("<R>Your data won't be saved in international rooms!",n)
            end
            p[n].use=49
            p[n].max={[49]=data[n][9],[50]=data[n][10],[51]=data[n][11]}
            if p[n].guild~="" then
                if save and inRoomModule and not intRoom then
                    data[n][1]=data[n][1]+1
                end
                saveData(n)
                tfm.exec.setNameColor(n,guilds[p[n].guild].color)
                for i,v in pairs(maps) do
                    if v.code==tfm.get.room.currentMap then
                        tfm.exec.movePlayer(n,v.x[p[n].guild],v.y[p[n].guild])
                    end
                end
            else
                tfm.exec.killPlayer(n)
            end
        end
    end
end
--[[ End of file events/eventNewGame.lua ]]--
--[[ File events/eventNewPlayer.lua ]]--
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
--[[ End of file events/eventNewPlayer.lua ]]--
--[[ File events/eventPlayerDied.lua ]]--
function eventPlayerDied(n)
    if tfm.get.room.currentMap~="@6760470" then
        local t={df=0,dp=0,gm=0,bp=0}
        if p[n].guild~="" then
            if save and inRoomModule and not intRoom then
                data[n][3]=data[n][3]+1
            end
            saveData(n)
            removeBoard(n)
            for n,pr in pairs(tfm.get.room.playerList) do
                if not pr.isDead then
                    t[p[n].guild]=t[p[n].guild]+1
                end
            end
            local team = {}
            for k,v in pairs(t) do
                if v ~= 0 then
                    team[#team+1] = k
                end
                if #team > 1 then
                    break
                end
            end
            if #team==1 then
                done=true
                table.foreach(tfm.get.room.playerList,removeBoard)
                tfm.exec.setGameTime(10)
                for i in pairs(guilds[team[1]].members) do
                    tfm.exec.movePlayer(i,maps[currMap].x[p[i].guild],maps[currMap].y[p[i].guild])
                end
                system.newTimer(function()
                    Win(team[1])
                end,5000,false)
            end
        end
    end
end
--[[ End of file events/eventPlayerDied.lua ]]--
--[[ File events/eventPlayerLeft.lua ]]--
function eventPlayerLeft(n)
    players=players-1
    if p[n].guild~="" then
        guilds[p[n].guild].inRoom[n]=nil
    end
end
--[[ End of file events/eventPlayerLeft.lua ]]--
--[[ File events/eventPlayerWon.lua ]]--
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
--[[ End of file events/eventPlayerWon.lua ]]--
--[[ File events/eventTextAreaCallback.lua ]]--
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
--[[ End of file events/eventTextAreaCallback.lua ]]--
--[[ End of directory events ]]--
--[[ File end.lua ]]--
table.foreach(tfm.get.room.playerList,eventNewPlayer)
newGame()
system.loadFile(2)
--[[ End of file end.lua ]]--