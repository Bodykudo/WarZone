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