-- ============================================================
-- TweenManager.lua
-- 功能：封装 UGC Tween 动画库，提供简洁的链式/单次动画接口
-- 依赖：TweenLibrary, UGCDelegateUtility, UGCGameSystem
-- ============================================================

TweenManager = TweenManager or {}

-- 私有变量：TweenLibrary 实例和默认上下文（本地玩家控制器）
local _tweenLib = nil
local _defaultContext = nil

-- 缓动类型常量（方便引用，可根据实际环境调整）
TweenManager.EEasingType = {
    Linear = 0,
    QuadIn = 1, QuadOut = 2, QuadInOut = 3,
    CubicIn = 4, CubicOut = 5, CubicInOut = 6,
    QuartIn = 7, QuartOut = 8, QuartInOut = 9,
    QuintIn = 10, QuintOut = 11, QuintInOut = 12,
    SineIn = 13, SineOut = 14, SineInOut = 15,
    ExpoIn = 16, ExpoOut = 17, ExpoInOut = 18,
    CircIn = 19, CircOut = 20, CircInOut = 21,
    ElasticIn = 22, ElasticOut = 23, ElasticInOut = 24,
    BackIn = 25, BackOut = 26, BackInOut = 27,
    BounceIn = 28, BounceOut = 29, BounceInOut = 30,
}

-- 初始化管理器（在游戏启动时调用一次）
function TweenManager.Initialize()
    if not _tweenLib then
        _tweenLib = KismetLibrary.New("/Script/UnrealTween.UnrealTweenBlueprintLibrary")
    end
    if not _defaultContext then
        _defaultContext = UGCGameSystem.GetLocalPlayerController()
    end
    if not _tweenLib or not _defaultContext then
        ugcprint("[TweenManager] 初始化失败，请检查环境")
        return false
    end
    return true
end

-- 创建默认配置（可自行修改）
function TweenManager.DefaultConfig(delay, repeatCount, yoyo, repeatDelay)
    local config = CreateStruct('/Script/UnrealTween.UnrealTweenConfig')
    config.Delay = delay or 0
    config.RepeatCount = repeatCount or 1   -- 0/1 = 一次，-1 = 无限
    config.bYoyo = yoyo or false
    config.RepeatDelay = repeatDelay or 0
    return config
end

-- ==================== 通用委托创建 ====================

local function CreateDelegate(callback, selfObj)
    local delegate = UGCDelegateUtility.CreateUEDelegate(_defaultContext)
    if selfObj then
        delegate:Bind(callback, selfObj)
    else
        delegate:Bind(callback)
    end
    return delegate
end

-- 通用的 Canvas 槽位动画（偏移量基于基准值）
local function CreateCanvasAnim(slot, baseValue, setterFunc, startOffset, endOffset, duration, easingType, config)
    if not slot then return nil end
    local delegate = CreateDelegate(function(value)
        local finalX = baseValue.X + value.X
        local finalY = baseValue.Y + value.Y
        setterFunc(slot, KismetMathLibrary.MakeVector2D(finalX, finalY))
    end)
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenVectorValue(_defaultContext, startOffset, endOffset, duration, easing, delegate, cfg)
end

-- ==================== 动画创建接口 ====================

-- 1. 颜色动画（适用于 UI 控件，如 SetColorAndOpacity）
-- @param updateFunc: 每帧更新函数 function(currentVector)
-- @param startColor: 起始颜色（FLinearColor）
-- @param endColor: 目标颜色
-- @param duration: 持续时间（秒）
-- @param easingType: 可选，缓动类型（来自 TweenManager.EEasingType）
-- @param config: 可选，配置表（若不传则使用默认单次动画）
-- @param selfObj: 可选，绑定 updateFunc 的 self
-- @return tweenHandle 或 nil
function TweenManager.ColorAnim(updateFunc, startColor, endColor, duration, easingType, config, selfObj)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local delegate = CreateDelegate(updateFunc, selfObj)
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenColorValue(_defaultContext, startColor, endColor, duration, easing, delegate, cfg)
end

-- 2. 向量动画（适用于任意需要 FVector 过渡的场景）
-- @param updateFunc: 每帧更新函数 function(currentVector)
-- @param startVec: 起始向量
-- @param endVec: 目标向量
-- @param duration: 持续时间
-- @param easingType: 可选，缓动类型
-- @param config: 可选配置
-- @param selfObj: 可选，绑定 updateFunc 的 self
-- @return tweenHandle 或 nil
function TweenManager.VectorAnim(updateFunc, startVec, endVec, duration, easingType, config, selfObj)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local delegate = CreateDelegate(updateFunc, selfObj)
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenVectorValue(_defaultContext, startVec, endVec, duration, easing, delegate, cfg)
end

-- 基于Canvas 槽位的位置动画
-- @param slot: Canvas 插槽来自（UGCWidgetManagerSystem.SlotAsCanvasSlot）
-- @param basePos: 当前执行变化的位置
-- @param startOffset: 起始数值
-- @param endOffset: 结束数值
-- @param dur: 持续时间
-- @param easing: 可选，缓动类型
-- @param cfg: 可选，配置表（若不传则使用默认单次动画）
-- @return tweenHandle 或 nil
function TweenManager.PositionAnim(slot, basePos, startOffset, endOffset, dur, easing, cfg)
    return CreateCanvasAnim(slot, basePos, function(s, v) s:SetPosition(v) end, startOffset, endOffset, dur, easing, cfg)
end

-- 基于Canvas 槽位的尺寸动画
-- @param slot: Canvas 插槽来自（UGCWidgetManagerSystem.SlotAsCanvasSlot）
-- @param baseSize: 当前执行变化的尺寸
-- @param startOffset: 起始数值
-- @param endOffset: 结束数值
-- @param dur: 持续时间
-- @param easing: 可选，缓动类型
-- @param cfg: 可选，配置表（若不传则使用默认单次动画）
-- @return tweenHandle 或 nil
function TweenManager.SizeAnim(slot, baseSize, startOffset, endOffset, dur, easing, cfg)
    return CreateCanvasAnim(slot, baseSize, function(s, v) s:SetSize(v) end, startOffset, endOffset, dur, easing, cfg)
end

-- 3. 浮点数值动画（进度条、数值变化等）
-- @param updateFunc: function(currentValue)
-- @param startValue: 起始数值
-- @param endValue: 结束数值
-- @param duration: 持续时间
-- @param easingType: 可选，缓动类型
-- @param config: 可选配置
-- @param selfObj: 可选，绑定 updateFunc 的 self
-- @return tweenHandle 或 nil
function TweenManager.FloatAnim(updateFunc, startValue, endValue, duration, easingType, config, selfObj)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local delegate = CreateDelegate(updateFunc, selfObj)
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenFloatValue(_defaultContext, startValue, endValue, duration, easing, delegate, cfg)
end

-- 4. Actor 位置动画（直接移动 Actor）
-- @param updateFunc: function(currentValue)
-- @param startValue: 起始数值
-- @param endValue: 结束数值
-- @param duration: 持续时间
-- @param easingType: 可选，缓动类型
-- @param config: 可选配置
-- @param selfObj: 可选，绑定 updateFunc 的 self
-- @return tweenHandle 或 nil
function TweenManager.ActorMove(updateFunc, startValue, endValue, duration, easingType, config, selfObj)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local delegate = CreateDelegate(updateFunc, selfObj)
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenActorLocation(_defaultContext, actor, startValue, endValue, duration, easing, delegate, cfg)
end

-- 5. Actor 旋转动画（直接旋转 Actor）
-- @param updateFunc: function(currentValue)
-- @param startValue: 起始数值
-- @param endValue: 结束数值
-- @param duration: 持续时间
-- @param easingType: 可选，缓动类型
-- @param config: 可选配置
-- @param selfObj: 可选，绑定 updateFunc 的 self
-- @return tweenHandle 或 nil
function TweenManager.ActorRotate(updateFunc, startValue, endValue, duration, easingType, config, selfObj)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local delegate = CreateDelegate(updateFunc, selfObj)
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return _tweenLib.TweenActorRotation(_defaultContext, actor, startValue, endValue, duration, easing, delegate, cfg)
end

-- ==================== 动画控制接口 ====================

-- 暂停动画
function TweenManager.Pause(handle)
    if not handle then return end
    _tweenLib.PauseTween(_defaultContext, handle)
end

-- 恢复动画
function TweenManager.Resume(handle)
    if not handle then return end
    _tweenLib.ResumeTween(_defaultContext, handle)
end

-- 停止并销毁动画（回到起始值）
function TweenManager.Stop(handle)
    if not handle then return end
    _tweenLib.KillTween(_defaultContext, handle)
end

-- 检查动画是否有效
function TweenManager.IsValid(handle)
    return _tweenLib.IsTweenValid(_defaultContext, handle)
end

-- 绑定动画完成回调
-- @param handle: 动画句柄
-- @param callback: function() end
function TweenManager.OnComplete(handle, callback)
    if not handle then return end
    _tweenLib.BindCompletedDelegate(_defaultContext, handle, callback)
end

-- 链式动画：前一个完成后自动启动下一个
function TweenManager.Chain(firstHandle, secondHandle)
    if not firstHandle or not secondHandle then return end
    _tweenLib.ChainTween(_defaultContext, firstHandle, secondHandle)
end

-- ==================== 高级配置助手 ====================

-- 创建无限循环动画（默认 Yoyo = false）
function TweenManager.InfiniteConfig(delay, yoyo, repeatDelay)
    return TweenManager.DefaultConfig(delay or 0, -1, yoyo or false, repeatDelay or 0)
end

-- 创建往返一次动画（A->B->A）
function TweenManager.YoyoConfig(delay)
    return TweenManager.DefaultConfig(delay or 0, 1, true, 0)
end

-- ==================== 示例用法 ====================
--[[
-- 1. 初始化（游戏启动时调用）
TweenManager.Initialize()

-- 2. 让一个按钮循环淡入淡出
local startColor = KismetMathLibrary.MakeColor(1,1,1,0)   -- 透明
local endColor = KismetMathLibrary.MakeColor(1,1,1,1)     -- 不透明
local loopConfig = TweenManager.InfiniteConfig(0, true, 0)  -- 无限往返
local handle = TweenManager.ColorAnim(
function(Value)
    self.TweenTarget:SetColorAndOpacity(Value)
end, startColor, endColor, 1.0, TweenManager.EEasingType.Linear, loopConfig)

-- 3. 移动 Actor 到指定点，完成后播放特效
local startLocation = KismetMathLibrary.MakeVector(0, 100, 100)
local targetLocation = KismetMathLibrary.MakeVector(100, 100, 100)
local moveHandle = TweenManager.ActorMove(myActor, startLocation, targetLocation, TweenManager.EEasingType.QuadOut)
TweenManager.OnComplete(moveHandle, function()
    ugcprint("到达目标，播放特效")
end)

-- 4. 数值动画（更新血量文本）
local function updateHp(val)
    myHpText:SetText(tostring(math.floor(val)))
end
local hpHandle = TweenManager.FloatAnim(updateHp, 100, 0, 3.0, TweenManager.EEasingType.Linear)

-- 5. 暂停/恢复
TweenManager.Pause(hpHandle)
TweenManager.Resume(hpHandle)
--]]

return TweenManager