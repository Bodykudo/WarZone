function eventPlayerLeft(n)
    players=players-1
    if p[n].guild~="" then
        guilds[p[n].guild].inRoom[n]=nil
    end
end