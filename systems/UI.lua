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