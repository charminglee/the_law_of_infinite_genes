---@meta


---@class __UnrealTweenHandle


---@class __UnrealTweenBlueprintLibrary
__UnrealTweenBlueprintLibrary = {}


---@param WorldContextObject UObject
---@param Start FVector
---@param End FVector
---@param Duration number
---@param EasingType integer
---@param UpdateDelegate ULuaSingleDelegate|UGCLuaDelegate
---@param Config table
---@return __UnrealTweenHandle|nil
function __UnrealTweenBlueprintLibrary.TweenVectorValue(WorldContextObject, Start, End, Duration, EasingType, UpdateDelegate, Config) end


---@param WorldContextObject UObject
---@param Start FLinearColor
---@param End FLinearColor
---@param Duration number
---@param EasingType integer
---@param UpdateDelegate ULuaSingleDelegate|UGCLuaDelegate
---@param Config table
---@return __UnrealTweenHandle|nil
function __UnrealTweenBlueprintLibrary.TweenColorValue(WorldContextObject, Start, End, Duration, EasingType, UpdateDelegate, Config) end


---@param WorldContextObject UObject
---@param Start number
---@param End number
---@param Duration number
---@param EasingType integer
---@param UpdateDelegate ULuaSingleDelegate|UGCLuaDelegate
---@param Config table
---@return __UnrealTweenHandle|nil
function __UnrealTweenBlueprintLibrary.TweenFloatValue(WorldContextObject, Start, End, Duration, EasingType, UpdateDelegate, Config) end


---@param WorldContextObject UObject
---@param Actor AActor
---@param Start FVector
---@param End FVector
---@param Duration number
---@param EasingType integer
---@param UpdateDelegate ULuaSingleDelegate|UGCLuaDelegate
---@param Config table
---@return __UnrealTweenHandle|nil
function __UnrealTweenBlueprintLibrary.TweenActorLocation(WorldContextObject, Actor, Start, End, Duration, EasingType, UpdateDelegate, Config) end


---@param WorldContextObject UObject
---@param Actor AActor
---@param Start FRotator
---@param End FRotator
---@param Duration number
---@param EasingType integer
---@param UpdateDelegate ULuaSingleDelegate|UGCLuaDelegate
---@param Config table
---@return __UnrealTweenHandle|nil
function __UnrealTweenBlueprintLibrary.TweenActorRotation(WorldContextObject, Actor, Start, End, Duration, EasingType, UpdateDelegate, Config) end


---@param WorldContextObject UObject
---@param Handle __UnrealTweenHandle
function __UnrealTweenBlueprintLibrary.PauseTween(WorldContextObject, Handle) end


---@param WorldContextObject UObject
---@param Handle __UnrealTweenHandle
function __UnrealTweenBlueprintLibrary.ResumeTween(WorldContextObject, Handle) end


---@param WorldContextObject UObject
---@param Handle __UnrealTweenHandle
function __UnrealTweenBlueprintLibrary.KillTween(WorldContextObject, Handle) end


---@param WorldContextObject UObject
---@param Handle __UnrealTweenHandle
---@return boolean
function __UnrealTweenBlueprintLibrary.IsTweenValid(WorldContextObject, Handle) end


---@param WorldContextObject UObject
---@param Handle __UnrealTweenHandle
---@param Completed function
function __UnrealTweenBlueprintLibrary.BindCompletedDelegate(WorldContextObject, Handle, Completed) end


---@param WorldContextObject UObject
---@param FirstHandle __UnrealTweenHandle
---@param SecondHandle __UnrealTweenHandle
function __UnrealTweenBlueprintLibrary.ChainTween(WorldContextObject, FirstHandle, SecondHandle) end
