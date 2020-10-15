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