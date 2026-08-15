---游戏流程共享枚举。这里只保存不可变语义，不保存任何玩家运行时状态。
local GameTypes = {}

GameTypes.ModeID = {
    Lobby = 1001,
    DefaultGameplay = 1002,
}

GameTypes.ModeName = {
    Lobby = "大厅",
    SingleMode = "单人闯关",
}

GameTypes.AliveState = {
    Alive = 0,
    Dying = 1,
    Dead = 2,
}

return GameTypes
