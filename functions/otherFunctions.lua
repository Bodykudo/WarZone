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