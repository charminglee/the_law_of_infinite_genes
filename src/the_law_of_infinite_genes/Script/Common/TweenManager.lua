-- ============================================================
-- TweenManager.lua
-- 功能：封装 UGC Tween 动画库，提供简洁的链式/单次动画接口
-- 依赖：TweenLibrary, UGCDelegateUtility, UGCGameSystem
-- ============================================================

TweenManager = TweenManager or {}

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

--- 通用的 Canvas 槽位动画（偏移量基于基准值）
--- @param slot UCanvasPanelSlot: Canvas 插槽来自（UGCWidgetManagerSystem.SlotAsCanvasSlot）
--- @param baseValue FVector: 当前执行变化的位置
--- @param setterFunc function: 每帧更新函数 function()
--- @param startOffset FVector: 起始数值
--- @param endOffset FVector: 结束数值
--- @param duration number: 持续时间
--- @param easingType EEasingType: 可选，缓动类型
--- @param config FUnrealTweenConfig: 可选，配置表（若不传则使用默认单次动画）
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
local function CreateCanvasAnim(slot, baseValue, setterFunc, startOffset, endOffset, duration, easingType, config)
    if not slot then return nil end
    local callback = function(Object, value)
        local finalX = baseValue.X + value.X
        local finalY = baseValue.Y + value.Y
        setterFunc(slot, KismetMathLibrary.MakeVector2D(finalX, finalY))
    end
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenVectorValue(startOffset, endOffset, duration, easing, callback, cfg)
end

-- ==================== 动画创建接口 ====================

--- 颜色动画（适用于 UI 控件，如 SetColorAndOpacity）
--- @param updateFunc function: 每帧更新函数 function()
--- @param startColor FLinearColor: 起始颜色
--- @param endColor FLinearColor: 目标颜色
--- @param duration number: 持续时间（秒）
--- @param easingType EEasingType: 可选，缓动类型（来自 TweenManager.EEasingType）
--- @param config FUnrealTweenConfig: 可选，配置表（若不传则使用默认单次动画）
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.ColorAnim(updateFunc, startColor, endColor, duration, easingType, config)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenColorValue(startColor, endColor, duration, easing, updateFunc, cfg)
end

--- 向量动画（适用于任意需要 FVector 过渡的场景）
--- @param updateFunc function: 每帧更新函数 function()
--- @param startVec FVector: 起始向量
--- @param endVec FVector: 目标向量
--- @param duration number: 持续时间
--- @param easingType EEasingType: 可选，缓动类型
--- @param config FUnrealTweenConfig: 可选配置
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.VectorAnim(updateFunc, startVec, endVec, duration, easingType, config)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenVectorValue(startVec, endVec, duration, easing, updateFunc, cfg)
end

--- 基于Canvas 槽位的位置动画
--- @param slot UCanvasPanelSlot: Canvas 插槽来自（UGCWidgetManagerSystem.SlotAsCanvasSlot）
--- @param basePos FVector2D: 当前执行变化的位置
--- @param startOffset FVector2D: 起始数值
--- @param endOffset FVector2D: 结束数值
--- @param dur number: 持续时间
--- @param easing EEasingType: 可选，缓动类型
--- @param cfg FUnrealTweenConfig: 可选，配置表（若不传则使用默认单次动画）
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.PositionAnim(slot, basePos, startOffset, endOffset, dur, easing, cfg)
    return CreateCanvasAnim(slot, basePos, function(s, v) s:SetPosition(v) end, startOffset, endOffset, dur, easing, cfg)
end

--- 基于Canvas 槽位的尺寸动画
--- @param slot UCanvasPanelSlot: Canvas 插槽来自（UGCWidgetManagerSystem.SlotAsCanvasSlot）
--- @param baseSize FVector2D: 当前执行变化的尺寸
--- @param startOffset FVector2D: 起始数值
--- @param endOffset FVector2D: 结束数值
--- @param dur number: 持续时间
--- @param easing EEasingType: 可选，缓动类型
--- @param cfg FUnrealTweenConfig: 可选，配置表（若不传则使用默认单次动画）
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.SizeAnim(slot, baseSize, startOffset, endOffset, dur, easing, cfg)
    return CreateCanvasAnim(slot, baseSize, function(s, v) s:SetSize(v) end, startOffset, endOffset, dur, easing, cfg)
end

--- 浮点数值动画（进度条、数值变化等）
--- @param updateFunc function: 每帧更新函数 function()
--- @param startValue number: 起始数值
--- @param endValue number: 结束数值
--- @param duration number: 持续时间
--- @param easingType EEasingType: 可选，缓动类型
--- @param config FUnrealTweenConfig: 可选配置
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.FloatAnim(updateFunc, startValue, endValue, duration, easingType, config)
    if type(updateFunc) ~= "function" then return nil end
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenFloatValue(startValue, endValue, duration, easing, updateFunc, cfg)
end

--- Actor 位置动画（直接移动 Actor）
--- @param actor AActor: 目标 Actor
--- @param targetLocation FVector: 目标位置
--- @param duration number: 持续时间
--- @param easingType EEasingType: 可选，缓动类型
--- @param config FUnrealTweenConfig: 可选配置
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.ActorMove(actor, targetLocation, duration, easingType, config)
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenActorLocation(actor, targetLocation, duration, easing, cfg)
end

--- Actor 旋转动画（直接旋转 Actor）
--- @param actor AActor: 目标 Actor
--- @param targetRotation FRotator: 目标旋转
--- @param duration number: 持续时间
--- @param bShortestPath boolean: 是否走最短路径旋转
--- @param easingType EEasingType: 可选，缓动类型
--- @param config FUnrealTweenConfig: 可选配置
--- @return FTweenHandle|nil 成功返回句柄，失败返回 nil
function TweenManager.ActorRotate(actor, targetRotation, duration, bShortestPath, easingType, config)
    local easing = easingType or TweenManager.EEasingType.Linear
    local cfg = config or TweenManager.DefaultConfig(0, 1, false, 0)
    return UGCTweenSystem.TweenActorRotation(actor, targetRotation, duration, easing, bShortestPath, cfg)
end

-- ==================== 动画控制接口 ====================

--- 暂停 Tween 动画
function TweenManager.Pause(handle)
    if not handle then return end
    UGCTweenSystem.PauseTween(handle)
end

--- 恢复已暂停的 Tween 动画
function TweenManager.Resume(handle)
    if not handle then return end
    UGCTweenSystem.ResumeTween(handle)
end

--- 停止并销毁 Tween 动画
function TweenManager.Stop(handle)
    if not handle then return end
    UGCTweenSystem.KillTween(handle)
end

--- 判断 Tween 句柄是否有效（动画是否仍在运行）
function TweenManager.IsValid(handle)
    return UGCTweenSystem.IsTweenValid(handle)
end

--- 绑定 Tween 完成回调
--- @param handle FTweenHandle: 动画句柄
--- @param callback function: 完成回调，签名 function(Obj, Handle)，Obj 为 WorldContext，Handle 为动画句柄
function TweenManager.OnComplete(handle, callback)
    if not handle then return end
    UGCTweenSystem.BindCompletedDelegate(handle, callback)
end

--- 链式连接两个 Tween：Parent 完成后自动播放 Child
--- @param firstHandle FTweenHandle: 父动画句柄
--- @param secondHandle FTweenHandle: 子动画句柄（将在父动画完成后自动触发）
function TweenManager.Chain(firstHandle, secondHandle)
    if not firstHandle or not secondHandle then return end
    UGCTweenSystem.ChainTween(firstHandle, secondHandle)
end

-- ==================== 配置助手 ====================

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
-- 1. 让一个按钮循环淡入淡出
local startColor = KismetMathLibrary.MakeColor(1,1,1,0)   -- 透明
local endColor = KismetMathLibrary.MakeColor(1,1,1,1)     -- 不透明
local loopConfig = TweenManager.InfiniteConfig(0, true, 0)  -- 无限往返
local handle = TweenManager.ColorAnim(
function(Value)
    self.TweenTarget:SetColorAndOpacity(Value)
end, startColor, endColor, 1.0, TweenManager.EEasingType.Linear, loopConfig)

-- 2. 移动 Actor 到指定点，完成后播放特效
local targetLocation = KismetMathLibrary.MakeVector(100, 100, 100)
local moveHandle = TweenManager.ActorMove(myActor, targetLocation, duration, TweenManager.EEasingType.QuadOut)
TweenManager.OnComplete(moveHandle, function()
    ugcprint("到达目标，播放特效")
end)

-- 3. 数值动画（更新血量文本）
local function updateHp(val)
    myHpText:SetText(tostring(math.floor(val)))
end
local hpHandle = TweenManager.FloatAnim(updateHp, 100, 0, 3.0, TweenManager.EEasingType.Linear)

-- 4. 暂停/恢复
TweenManager.Pause(hpHandle)
TweenManager.Resume(hpHandle)
--]]

return TweenManager