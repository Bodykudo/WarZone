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