---@meta


---@class UGCGameSystem
UGCGameSystem = {}


---GameMode变量
---生效范围：服务器
---@type UGCGameMode_C
UGCGameSystem.GameMode = GameMode


---GameState变量
---生效范围：服务器&客户端
---@type UGCGameState_C
UGCGameSystem.GameState = GameState


---获取所有的 PlayerController，客户端仅能拿到自己的PlayerController
---生效范围：服务器&客户端
---@param NotIgnorePureSpectator boolean @是否包含非玩家观战者（全局观战）
---@return UGCPlayerController_C[]
function UGCGameSystem.GetAllPlayerController(NotIgnorePureSpectator) end


---获取所有的 PlayerPawn
---生效范围：服务器&客户端
---@return UGCPlayerPawn_C[]
function UGCGameSystem.GetAllPlayerPawn() end


---获取所有的 PlayerState，客户端仅能拿到所有队友的PlayerState
---生效范围：服务器&客户端
---@param NotIgnorePureSpectator boolean @【可选】是否包含非玩家观战者(全局观战)，客户端不生效
---@return UGCPlayerState_C[]
function UGCGameSystem.GetAllPlayerState(NotIgnorePureSpectator) end


---通过PlayerController获取PlayerKey
---生效范围：服务器&客户端
---@param PlayerController UGCPlayerController_C
---@return number @PlayerKey，无效时返回-1
function UGCGameSystem.GetPlayerKeyByPlayerController(PlayerController) end


---通过PlayerPawn获取PlayerKey
---生效范围：服务器&客户端
---@param PlayerPawn UGCPlayerPawn_C
---@return number @PlayerKey，无效时返回-1
function UGCGameSystem.GetPlayerKeyByPlayerPawn(PlayerPawn) end


---通过PlayerState获取PlayerKey
---生效范围：服务器&客户端
---@param PlayerState UGCPlayerState_C
---@return number @PlayerKey，无效时返回-1
function UGCGameSystem.GetPlayerKeyByPlayerState(PlayerState) end


---根据 PlayerKey 获取 PlayerController
---生效范围：服务器&客户端
---@param PlayerKey number @玩家唯一 Key
---@return UGCPlayerController_C @玩家 Controller
function UGCGameSystem.GetPlayerControllerByPlayerKey(PlayerKey) end


---通过UID获取PlayerController
---生效范围：服务器
---@param UID number @玩家UID
---@return UGCPlayerController_C @玩家 Controller
function UGCGameSystem.GetPlayerControllerByUID(UID) end


---通过PlayerState获取PlayerController，客户端只能通过PlayerState获取当前客户端的PlayerController
---生效范围：服务器&客户端
---@param PlayerState UGCPlayerState_C
---@return UGCPlayerController_C @玩家 Controller
function UGCGameSystem.GetPlayerControllerByPlayerState(PlayerState) end


---通过PlayerPawn获取PlayerController，客户端只能通过PlayerPawn获取当前客户端的PlayerController
---生效范围：服务器&客户端
---@param PlayerPawn UGCPlayerPawn_C
---@return UGCPlayerController_C @玩家 Controller
function UGCGameSystem.GetPlayerControllerByPlayerPawn(PlayerPawn) end


---根据 PlayerKey 获取 PlayerPawn（不会获取到尸体）
---生效范围：服务器&客户端
---@param PlayerKey number @玩家唯一 Key
---@return UGCPlayerPawn_C @玩家 Pawn
function UGCGameSystem.GetPlayerPawnByPlayerKey(PlayerKey) end


---通过UID获取PlayerPawn，客户端也可以获取敌人的Pawn
---生效范围：服务器&客户端
---@param UID number @玩家UID
---@return UGCPlayerPawn_C @玩家 Pawn
function UGCGameSystem.GetPlayerPawnByUID(UID) end


---通过PlayerState获取PlayerPawn
---生效范围：服务器&客户端
---@param PlayerState UGCPlayerState_C
---@return UGCPlayerPawn_C @玩家 Pawn
function UGCGameSystem.GetPlayerPawnByPlayerState(PlayerState) end


---通过PlayerController获取PlayerPawn
---生效范围：服务器&客户端
---@param PlayerController UGCPlayerController_C
---@return UGCPlayerPawn_C @玩家 Pawn
function UGCGameSystem.GetPlayerPawnByPlayerController(PlayerController) end


---根据 PlayerKey 获取 PlayerState，客户端只能拿到队友的PlayerState
---生效范围：服务器&客户端
---@param PlayerKey number @玩家唯一 Key
---@return UGCPlayerState_C @玩家 PlayerState
function UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey) end


---通过 PlayerPawn 获取 PlayerState，客户端仅能拿到所有队友的PlayerState
---生效范围：服务器&客户端
---@param PlayerPawn UGCPlayerPawn_C
---@return UGCPlayerState_C @玩家 PlayerState
function UGCGameSystem.GetPlayerStateByPlayerPawn(PlayerPawn) end


---根据 UID 获取 PlayerState，客户端仅能拿到所有队友的PlayerState
---生效范围：服务器&客户端
---@param UID number @玩家 UID
---@return UGCPlayerState_C @玩家 PlayerState
function UGCGameSystem.GetPlayerStateByUID(UID) end


---根据 PlayerController 获取 PlayerState
---生效范围：服务器&客户端
---@param PlayerController UGCPlayerController_C @玩家 Controller
---@return UGCPlayerState_C @玩家 PlayerState
function UGCGameSystem.GetPlayerStateByPlayerController(PlayerController) end


---根据 PlayerController 获取 UID
---生效范围：服务器&客户端
---@param PlayerController UGCPlayerController_C @玩家 Controller
---@return number @玩家 UID
function UGCGameSystem.GetUIDByPlayerController(PlayerController) end


---根据 PlayerState 获取 UID
---生效范围：服务器&客户端
---@param PlayerState UGCPlayerState_C @玩家 PlayerState
---@return number @玩家 UID
function UGCGameSystem.GetUIDByPlayerState(PlayerState) end


---根据 PlayerPawn 获取 UID
---生效范围：服务器&客户端
---@param PlayerPawn UGCPlayerPawn_C @玩家 PlayerPawn
---@return number @玩家 UID
function UGCGameSystem.GetUIDByPlayerPawn(PlayerPawn) end


---进入观战，默认观战任意队友
---可以通过 UGCGameSystem.ChangeAllowOBPlayerKeys 自定义可观战玩家列表
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @进入观战的玩家 Controller
---@return number @被观战的玩家的 PlayerKey
function UGCGameSystem.EnterSpectating(PlayerController) end


---退出观战
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @退出观战的玩家 Controller
function UGCGameSystem.LeaveSpectating(PlayerController) end


---设置可被观战玩家列表
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @可被观战玩家列表的 Controller
---@param PlayerKeyList int32[] @可观战玩家列表数组
function UGCGameSystem.ChangeAllowOBPlayerKeys(PlayerController, PlayerKeyList) end


---让观战我的人切换别的观战目标，只有当观战对象的Pawn死亡时才生效
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @不再被观战的玩家 Controller
function UGCGameSystem.MyObserversChangeTarget(PlayerController) end


---是否开启 GM，自定义 GM 逻辑和界面可接入此开关，正式服中此开关为 false
---生效范围：服务器&客户端
---@param PlayerController UGCPlayerController_C @玩家 Controller
---@return boolean @是否开启 GM
function UGCGameSystem.IsEnableGM(PlayerController) end


---改变当前观战目标（仅限观战中使用）
---例：被观战的玩家被淘汰后，需要使用此接口，切换至其他玩家进行观战
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @自己的 PlayerController
---@param PlayerKey number @观战目标玩家 PlayerKey
function UGCGameSystem.ChangeOBPlayer(PlayerController, PlayerKey) end


---是否关闭移动输入事件
---IsOverride 开启后需要在 PlayerController 重载 UGCMoveEvent(Vector2D) 事件
---生效范围：客户端
---@param PlayerController UGCPlayerController_C @玩家控制器
---@param IsEnable boolean @是否关闭
---@param IsOverride boolean @是否重载（原移动输入会被覆盖）
function UGCGameSystem.SetMoveInputEventEnable(PlayerController, IsEnable, IsOverride) end


---开启/关闭旋转输入事件
---IsOverride 开启后需要在 PlayerController 重载 UGCLookEvent(Vector2D) 事件
---生效范围：客户端
---@param PlayerController UGCPlayerController_C @玩家控制器
---@param IsEnable boolean @是否开启
---@param IsOverride boolean @是否重载（原旋转输入会被覆盖）
function UGCGameSystem.SetLookInputEventEnable(PlayerController, IsEnable, IsOverride) end


---在PlayerController对应的客户端震屏
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @震屏玩家的 PlayerController
---@param CameraShakeType EPESkillCameraShakeType @震屏类型(随机方向/X方向/Y方向)
---@param ShakeScale number @震屏强度
---@param Duration number @震屏时间(单位:秒，<=0 表示一直持续)
function UGCGameSystem.ClientPlayCameraShake(PlayerController, CameraShakeType, ShakeScale, Duration) end


---在PlayerController对应的客户端停止某类型的震屏
---生效范围：服务器
---@param PlayerController UGCPlayerController_C @震屏玩家的 PlayerController
---@param CameraShakeType EPESkillCameraShakeType @震屏类型(随机方向/X方向/Y方向)
function UGCGameSystem.ClientStopCameraShake(PlayerController, CameraShakeType) end


---获取客户端当前的 PlayerController
---生效范围：客户端
---@return UGCPlayerController_C @当前正在控制的玩家
function UGCGameSystem.GetLocalPlayerController() end


---获取客户端当前的 PlayerPawn
---生效范围：客户端
---@return UGCPlayerPawn_C @当前的PlayerPawn
function UGCGameSystem.GetLocalPlayerPawn() end


---获取客户端当前的 PlayerState
---生效范围：客户端
---@return UGCPlayerState_C @当前的PlayerState
function UGCGameSystem.GetLocalPlayerState() end


---获取当前的 GameMode
---生效范围：服务器
---@return UGCGameMode_C @当前的 GameMode
function UGCGameSystem.GetGameMode() end


---获取当前的 GameState
---生效范围：服务器&客户端
---@return UGCGameState_C @当前的 GameState
function UGCGameSystem.GetGameState() end


---判断玩家是否为观战玩家
---生效范围：服务器 & 客户端
---@param PlayerController UGCPlayerController_C @玩家控制器
---@return boolean @是否为观战玩家
function UGCGameSystem.IsObserver(PlayerController) end
