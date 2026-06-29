---@meta


---@param Object UObject
---@return boolean
function KismetSystemLibrary.IsRecycled(Object) end


---类型是否可用
---@param Class UClass
---@return boolean  true可用，false不可用
function KismetSystemLibrary.IsValidClass(Class) end


---获取对象名称
---@param Object UObject
---@return string  对象实际名称
function KismetSystemLibrary.GetObjectName(Object) end


---获取对象展示名称
---@param Object UObject
---@return string  对象展示名称
function KismetSystemLibrary.GetDisplayName(Object) end


---获取类展示名称
---@param Class UClass
---@return string  类展示名称
function KismetSystemLibrary.GetClassDisplayName(Class) end


---If there is an object class, strips it off.
---@param PathName string
---@param bAssertOnBadPath boolean
---@return string
function KismetSystemLibrary.StripObjectClass(PathName, bAssertOnBadPath) end


---@return string
function KismetSystemLibrary.GetEngineVersion() end


---Get the name of the current game
---@return string
function KismetSystemLibrary.GetGameName() end


---Retrieves the game's platform-specific bundle identifier or package name of the game
---@return string  The game's bundle identifier or package name.
function KismetSystemLibrary.GetGameBundleId() end


---Get the current user name from the OS
---@return string
function KismetSystemLibrary.GetPlatformUserName() end


---@param TestObject UObject
---@param Interface UClass
---@return boolean
function KismetSystemLibrary.DoesImplementInterface(TestObject, Interface) end


---Get the current game time, in seconds. This stops when the game is paused and is affected by slomo.
---@param WorldContextObject UObject  World context
---@return number
function KismetSystemLibrary.GetGameTimeInSeconds(WorldContextObject) end


---Returns whether the world this object is in is the host or not
---@param WorldContextObject UObject
---@return boolean
function KismetSystemLibrary.IsServer(WorldContextObject) end


---Returns whether this is running on a dedicated server
---@param WorldContextObject UObject
---@return boolean
function KismetSystemLibrary.IsDedicatedServer(WorldContextObject) end


---Returns whether this game instance is stand alone (no networking).
---@param WorldContextObject UObject
---@return boolean
function KismetSystemLibrary.IsStandalone(WorldContextObject) end


---Returns whether this is a build that is packaged for distribution
---@return boolean
function KismetSystemLibrary.IsPackagedForDistribution() end


---Returns the platform specific unique device id
---@return string
function KismetSystemLibrary.GetUniqueDeviceId() end


---Returns the platform specific unique device id
---@return string
function KismetSystemLibrary.GetDeviceId() end


---Converts an interfance into an object
---@param Interface FScriptInterface
---@return UObject
function KismetSystemLibrary.Conv_InterfaceToObject(Interface) end


---将路径字符串转换为SoftObjectPath
---@param PathString string
---@return FSoftObjectPath  SoftObjectPath
function KismetSystemLibrary.MakeSoftObjectPath(PathString) end


---将SoftObjectPath转换为路径字符串
---@param InSoftObjectPath FSoftObjectPath
---@param PathString string
function KismetSystemLibrary.BreakSoftObjectPath(InSoftObjectPath, PathString) end


---将SoftClassPath转换为路径字符串
---@param InSoftClassPath FSoftClassPath
---@param PathString string
function KismetSystemLibrary.BreakSoftClassPath(InSoftClassPath, PathString) end


---SoftObjectPath是否有效
---@param SoftObjectReference UObject
---@return boolean  true为有效
function KismetSystemLibrary.IsValidSoftObjectReference(SoftObjectReference) end


---Converts a Soft Object Reference to a string. The other direction is not provided because it cannot be validated
---@param SoftObjectReference UObject
---@return string
function KismetSystemLibrary.Conv_SoftObjectReferenceToString(SoftObjectReference) end


---Returns true if the values are equal (A == B)
---@param A UObject
---@param B UObject
---@return boolean
function KismetSystemLibrary.EqualEqual_SoftObjectReference(A, B) end


---Returns true if the values are not equal (A != B)
---@param A UObject
---@param B UObject
---@return boolean
function KismetSystemLibrary.NotEqual_SoftObjectReference(A, B) end


---Returns true if the Soft Class Reference is not null
---@param SoftClassReference UClass
---@return boolean
function KismetSystemLibrary.IsValidSoftClassReference(SoftClassReference) end


---Converts a Soft Class Reference to a string. The other direction is not provided because it cannot be validated
---@param SoftClassReference UClass
---@return string
function KismetSystemLibrary.Conv_SoftClassReferenceToString(SoftClassReference) end


---Returns true if the values are equal (A == B)
---@param A UClass
---@param B UClass
---@return boolean
function KismetSystemLibrary.EqualEqual_SoftClassReference(A, B) end


---@param SoftClass UClass
---@return UClass
function KismetSystemLibrary.Conv_SoftClassReferenceToClass(SoftClass) end


---Returns true if the values are not equal (A != B)
---@param A UClass
---@param B UClass
---@return boolean
function KismetSystemLibrary.NotEqual_SoftClassReference(A, B) end


---@param SoftObject UObject
---@return UObject
function KismetSystemLibrary.Conv_SoftObjectReferenceToObject(SoftObject) end


---@param Object UObject
---@return UObject
function KismetSystemLibrary.Conv_ObjectToSoftObjectReference(Object) end


---@param Class UClass
---@return UClass
function KismetSystemLibrary.Conv_ClassToSoftClassReference(Class) end


---@param WorldContextObject UObject
---@param Asset UObject
---@param OnLoaded __Delegate
---@param LatentInfo FLatentActionInfo
function KismetSystemLibrary.LoadAsset(WorldContextObject, Asset, OnLoaded, LatentInfo) end


---@param WorldContextObject UObject
---@param AssetClass UClass
---@param OnLoaded __Delegate
---@param LatentInfo FLatentActionInfo
function KismetSystemLibrary.LoadAssetClass(WorldContextObject, AssetClass, OnLoaded, LatentInfo) end


---Creates a literal integer
---@param Value integer  value to set the integer to
---@return integer  The literal integer
function KismetSystemLibrary.MakeLiteralInt(Value) end


---Creates a literal integer
---@param Value integer  value to set the integer to
---@return integer  The literal integer
function KismetSystemLibrary.MakeLiteralInt64(Value) end


---Creates a literal float
---@param Value number  value to set the float to
---@return number  The literal float
function KismetSystemLibrary.MakeLiteralFloat(Value) end


---Creates a literal bool
---@param Value boolean  value to set the bool to
---@return boolean  The literal bool
function KismetSystemLibrary.MakeLiteralBool(Value) end


---Creates a literal name
---@param Value FName  value to set the name to
---@return FName  The literal name
function KismetSystemLibrary.MakeLiteralName(Value) end


---Creates a literal byte
---@param Value integer  value to set the byte to
---@return integer  The literal byte
function KismetSystemLibrary.MakeLiteralByte(Value) end


---Creates a literal string
---@param Value string  value to set the string to
---@return string  The literal string
function KismetSystemLibrary.MakeLiteralString(Value) end


---Creates a literal FText
---@param Value FText  value to set the FText to
---@return FText  The literal FText
function KismetSystemLibrary.MakeLiteralText(Value) end


---Prints a string to the log, and optionally, to the screen If Print To Log is true, it will be visible in the Output Log window. Otherwise it will be logged only as 'Verbose', so it generally won't show up.
---@param WorldContextObject UObject
---@param InString string  The string to log out
---@param bPrintToScreen boolean  Whether or not to print the output to the screen
---@param bPrintToLog boolean  Whether or not to print the output to the log
---@param TextColor FLinearColor  Whether or not to print the output to the console
---@param Duration number  The display duration (if Print to Screen is True). Using negative number will result in loading the duration time from the config.
function KismetSystemLibrary.PrintString(WorldContextObject, InString, bPrintToScreen, bPrintToLog, TextColor, Duration) end


---Prints text to the log, and optionally, to the screen If Print To Log is true, it will be visible in the Output Log window. Otherwise it will be logged only as 'Verbose', so it generally won't show up.
---@param WorldContextObject UObject
---@param InText FText  The text to log out
---@param bPrintToScreen boolean  Whether or not to print the output to the screen
---@param bPrintToLog boolean  Whether or not to print the output to the log
---@param TextColor FLinearColor  Whether or not to print the output to the console
---@param Duration number  The display duration (if Print to Screen is True). Using negative number will result in loading the duration time from the config.
function KismetSystemLibrary.PrintText(WorldContextObject, InText, bPrintToScreen, bPrintToLog, TextColor, Duration) end


---Prints a warning string to the log and the screen. Meant to be used as a way to inform the user that they misused the node. WARNING!! Don't change the signature of this function without fixing up all nodes using it in the compiler
---@param InString string  The string to log out
function KismetSystemLibrary.PrintWarning(InString) end


---Sets the game window title
---@param Title FText
function KismetSystemLibrary.SetWindowTitle(Title) end


---Executes a console command, optionally on a specific controller
---@param WorldContextObject UObject
---@param Command string  Command to send to the console
---@param SpecificPlayer APlayerController  If specified, the console command will be routed through the specified player
---@param bDisableCheck boolean
function KismetSystemLibrary.ExecuteConsoleCommand(WorldContextObject, Command, SpecificPlayer, bDisableCheck) end


---@param WorldContextObject UObject
---@param Command string
---@param SpecificPlayer APlayerController
function KismetSystemLibrary.ExecuteConsoleCommandDisableCheck(WorldContextObject, Command, SpecificPlayer) end


---Attempts to retrieve the value of the specified float console variable, if it exists.
---@param VariableName string  Name of the console variable to find.
---@return number  The value if found, 0 otherwise.
function KismetSystemLibrary.GetConsoleVariableFloatValue(VariableName) end


---Attempts to retrieve the value of the specified integer console variable, if it exists.
---@param VariableName string  Name of the console variable to find.
---@return integer  The value if found, 0 otherwise.
function KismetSystemLibrary.GetConsoleVariableIntValue(VariableName) end


---Evaluates, if it exists, whether the specified integer console variable has a non-zero value (true) or not (false).
---@param VariableName string  Name of the console variable to find.
---@return boolean  True if found and has a non-zero value, false otherwise.
function KismetSystemLibrary.GetConsoleVariableBoolValue(VariableName) end


---Exit the current game
---@param WorldContextObject UObject
---@param SpecificPlayer APlayerController  The specific player to quit the game. If not specified, player 0 will quit.
---@param QuitPreference integer
function KismetSystemLibrary.QuitGame(WorldContextObject, SpecificPlayer, QuitPreference) end


---Perform a latent action with a delay (specified in seconds). Calling again while it is counting down will be ignored.
---@param WorldContextObject UObject
---@param Duration number  length of delay (in seconds).
---@param LatentInfo FLatentActionInfo  The latent action.
function KismetSystemLibrary.Delay(WorldContextObject, Duration, LatentInfo) end


---Perform a latent action with a delay of one tick. Calling again while it is counting down will be ignored.
---@param WorldContextObject UObject
---@param LatentInfo FLatentActionInfo  The latent action.
function KismetSystemLibrary.DelayUntilNextTick(WorldContextObject, LatentInfo) end


---Perform a latent action with a delay (specified in seconds). Calling again while it is counting down will be ignored.
---@param WorldContextObject UObject
---@param Duration number  length of delay (in seconds).
---@param IsReplacePreDuration boolean  replace previous action Duration
---@param LatentInfo FLatentActionInfo  The latent action.
function KismetSystemLibrary.DelayReplacePreDuration(WorldContextObject, Duration, IsReplacePreDuration, LatentInfo) end


---Perform a latent action with a retriggerable delay (specified in seconds). Calling again while it is counting down will reset the countdown to Duration.
---@param WorldContextObject UObject
---@param Duration number  length of delay (in seconds).
---@param LatentInfo FLatentActionInfo  The latent action.
function KismetSystemLibrary.RetriggerableDelay(WorldContextObject, Duration, LatentInfo) end


---Interpolate a component to the specified relative location and rotation over the course of OverTime seconds.
---@param Component USceneComponent  Component to interpolate
---@param TargetRelativeLocation FVector  Relative target location
---@param TargetRelativeRotation FRotator  Relative target rotation
---@param bEaseOut boolean  if true we will ease out (ie end slowly) during interpolation
---@param bEaseIn boolean  if true we will ease in (ie start slowly) during interpolation
---@param OverTime number  duration of interpolation
---@param bForceShortestRotationPath boolean  if true we will always use the shortest path for rotation
---@param MoveAction integer  required movement behavior @see EMoveComponentAction
---@param LatentInfo FLatentActionInfo  The latent action
function KismetSystemLibrary.MoveComponentTo(Component, TargetRelativeLocation, TargetRelativeRotation, bEaseOut, bEaseIn, OverTime, bForceShortestRotationPath, MoveAction, LatentInfo) end


---Set a timer to execute delegate. Setting an existing timer will reset that timer with updated parameters.
---@param Delegate __Delegate
---@param Time number  How long to wait before executing the delegate, in seconds. Setting a timer to <= 0 seconds will clear it if it is set.
---@param bLooping boolean  True to keep executing the delegate every Time seconds, false to execute delegate only once.
---@return FTimerHandle  The timer handle to pass to other timer functions to manipulate this timer.
function KismetSystemLibrary.K2_SetTimerDelegate(Delegate, Time, bLooping) end


---Set a timer to execute a delegate next tick.
---@param Delegate __Delegate
function KismetSystemLibrary.K2_SetTimerForNextTickDelegate(Delegate) end


---Set a timer to execute delegate. Setting an existing timer will reset that timer with updated parameters.
---@param Delegate __Delegate
---@param Time number  How long to wait before executing the delegate, in seconds. Setting a timer to <= 0 seconds will clear it if it is set.
---@param InExeFirst boolean
---@return FTimerHandle  The timer handle to pass to other timer functions to manipulate this timer.
function KismetSystemLibrary.K2_SetTimerTickDelegate(Delegate, Time, InExeFirst) end


---Set a timer to execute delegate. Setting an existing timer will reset that timer with updated parameters.
---@param Delegate __Delegate
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param Time number  How long to wait before executing the delegate, in seconds. Setting a timer to <= 0 seconds will clear it if it is set.
---@param bLooping boolean  True to keep executing the delegate every Time seconds, false to execute delegate only once.
---@return FTimerHandle  The timer handle to pass to other timer functions to manipulate this timer.
function KismetSystemLibrary.K2_SetTimerDelegateForLua(Delegate, Object, Time, bLooping) end


---Clears a set timer.
---@param Delegate __Delegate
function KismetSystemLibrary.K2_ClearTimerDelegate(Delegate) end


---Pauses a set timer at its current elapsed time.
---@param Delegate __Delegate
function KismetSystemLibrary.K2_PauseTimerDelegate(Delegate) end


---Resumes a paused timer from its current elapsed time.
---@param Delegate __Delegate
function KismetSystemLibrary.K2_UnPauseTimerDelegate(Delegate) end


---Returns true if a timer exists and is active for the given delegate, false otherwise.
---@param Delegate __Delegate
---@return boolean  True if the timer exists and is active.
function KismetSystemLibrary.K2_IsTimerActiveDelegate(Delegate) end


---Returns true if a timer exists and is paused for the given delegate, false otherwise.
---@param Delegate __Delegate
---@return boolean  True if the timer exists and is paused.
function KismetSystemLibrary.K2_IsTimerPausedDelegate(Delegate) end


---Returns true is a timer for the given delegate exists, false otherwise.
---@param Delegate __Delegate
---@return boolean  True if the timer exists.
function KismetSystemLibrary.K2_TimerExistsDelegate(Delegate) end


---Returns elapsed time for the given delegate (time since current countdown iteration began).
---@param Delegate __Delegate
---@return number  How long has elapsed since the current iteration of the timer began.
function KismetSystemLibrary.K2_GetTimerElapsedTimeDelegate(Delegate) end


---Returns time until the timer will next execute its delegate.
---@param Delegate __Delegate
---@return number  How long is remaining in the current iteration of the timer.
function KismetSystemLibrary.K2_GetTimerRemainingTimeDelegate(Delegate) end


---Returns whether the timer handle is valid. This does not indicate that there is an active timer that this handle references, but rather that it once referenced a valid timer.
---@param Handle FTimerHandle  The handle of the timer to check validity of.
---@return boolean  Whether the timer handle is valid.
function KismetSystemLibrary.K2_IsValidTimerHandle(Handle) end


---Returns whether the timer handle is valid. This does not indicate that there is an active timer that this handle references, but rather that it once referenced a valid timer.
---@param Handle FTimerHandle  The handle of the timer to check validity of.
---@return FTimerHandle  Return the invalidated timer handle for convenience.
function KismetSystemLibrary.K2_InvalidateTimerHandle(Handle) end


---Clears a set timer.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to clear.
function KismetSystemLibrary.K2_ClearTimerHandle(WorldContextObject, Handle) end


---Clears a set timer.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to clear.
function KismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(WorldContextObject, Handle) end


---Pauses a set timer at its current elapsed time.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to pause.
function KismetSystemLibrary.K2_PauseTimerHandle(WorldContextObject, Handle) end


---Resumes a paused timer from its current elapsed time.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to unpause.
function KismetSystemLibrary.K2_UnPauseTimerHandle(WorldContextObject, Handle) end


---Returns true if a timer exists and is active for the given handle, false otherwise.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to check whether it is active.
---@return boolean  True if the timer exists and is active.
function KismetSystemLibrary.K2_IsTimerActiveHandle(WorldContextObject, Handle) end


---Returns true if a timer exists and is paused for the given handle, false otherwise.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to check whether it is paused.
---@return boolean  True if the timer exists and is paused.
function KismetSystemLibrary.K2_IsTimerPausedHandle(WorldContextObject, Handle) end


---Returns true is a timer for the given handle exists, false otherwise.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle to check whether it exists.
---@return boolean  True if the timer exists.
function KismetSystemLibrary.K2_TimerExistsHandle(WorldContextObject, Handle) end


---Returns elapsed time for the given handle (time since current countdown iteration began).
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to get the elapsed time of.
---@return number  How long has elapsed since the current iteration of the timer began.
function KismetSystemLibrary.K2_GetTimerElapsedTimeHandle(WorldContextObject, Handle) end


---Returns time until the timer will next execute its handle.
---@param WorldContextObject UObject
---@param Handle FTimerHandle  The handle of the timer to time remaining of.
---@return number  How long is remaining in the current iteration of the timer.
function KismetSystemLibrary.K2_GetTimerRemainingTimeHandle(WorldContextObject, Handle) end


---Set a timer to execute delegate. Setting an existing timer will reset that timer with updated parameters.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@param Time number  How long to wait before executing the delegate, in seconds. Setting a timer to <= 0 seconds will clear it if it is set.
---@param bLooping boolean  true to keep executing the delegate every Time seconds, false to execute delegate only once.
---@return FTimerHandle  The timer handle to pass to other timer functions to manipulate this timer.
function KismetSystemLibrary.K2_SetTimer(Object, FunctionName, Time, bLooping) end


---Set a timer to execute a delegate on the next tick.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
function KismetSystemLibrary.K2_SetTimerForNextTick(Object, FunctionName) end


---Clears a set timer.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
function KismetSystemLibrary.K2_ClearTimer(Object, FunctionName) end


---Pauses a set timer at its current elapsed time.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
function KismetSystemLibrary.K2_PauseTimer(Object, FunctionName) end


---Resumes a paused timer from its current elapsed time.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
function KismetSystemLibrary.K2_UnPauseTimer(Object, FunctionName) end


---Returns true if a timer exists and is active for the given delegate, false otherwise.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@return boolean  True if the timer exists and is active.
function KismetSystemLibrary.K2_IsTimerActive(Object, FunctionName) end


---Returns true if a timer exists and is paused for the given delegate, false otherwise.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@return boolean  True if the timer exists and is paused.
function KismetSystemLibrary.K2_IsTimerPaused(Object, FunctionName) end


---Returns true is a timer for the given delegate exists, false otherwise.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@return boolean  True if the timer exists.
function KismetSystemLibrary.K2_TimerExists(Object, FunctionName) end


---Returns elapsed time for the given delegate (time since current countdown iteration began).
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@return number  How long has elapsed since the current iteration of the timer began.
function KismetSystemLibrary.K2_GetTimerElapsedTime(Object, FunctionName) end


---Returns time until the timer will next execute its delegate.
---@param Object UObject  Object that implements the delegate function. Defaults to self (this blueprint)
---@param FunctionName string  Delegate function name. Can be a K2 function or a Custom Event.
---@return number  How long is remaining in the current iteration of the timer.
function KismetSystemLibrary.K2_GetTimerRemainingTime(Object, FunctionName) end


---Set an int32 property by name
---@param Object UObject
---@param PropertyName FName
---@param Value integer
function KismetSystemLibrary.SetIntPropertyByName(Object, PropertyName, Value) end


---Set an int64 property by name
---@param Object UObject
---@param PropertyName FName
---@param Value integer
function KismetSystemLibrary.SetInt64PropertyByName(Object, PropertyName, Value) end


---Set an uint64 property by name
---@param Object UObject
---@param PropertyName FName
---@param Value integer
function KismetSystemLibrary.SetUInt64PropertyByName(Object, PropertyName, Value) end


---Set an uint8 or enum property by name
---@param Object UObject
---@param PropertyName FName
---@param Value integer
function KismetSystemLibrary.SetBytePropertyByName(Object, PropertyName, Value) end


---Set a float property by name
---@param Object UObject
---@param PropertyName FName
---@param Value number
function KismetSystemLibrary.SetFloatPropertyByName(Object, PropertyName, Value) end


---Set a bool property by name
---@param Object UObject
---@param PropertyName FName
---@param Value boolean
function KismetSystemLibrary.SetBoolPropertyByName(Object, PropertyName, Value) end


---Set an OBJECT property by name
---@param Object UObject
---@param PropertyName FName
---@param Value UObject
function KismetSystemLibrary.SetObjectPropertyByName(Object, PropertyName, Value) end


---Set a CLASS property by name
---@param Object UObject
---@param PropertyName FName
---@param Value UClass
function KismetSystemLibrary.SetClassPropertyByName(Object, PropertyName, Value) end


---Set an INTERFACE property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FScriptInterface
function KismetSystemLibrary.SetInterfacePropertyByName(Object, PropertyName, Value) end


---Set a NAME property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FName
function KismetSystemLibrary.SetNamePropertyByName(Object, PropertyName, Value) end


---Set a SOFTOBJECT property by name
---@param Object UObject
---@param PropertyName FName
---@param Value UObject
function KismetSystemLibrary.SetSoftObjectPropertyByName(Object, PropertyName, Value) end


---Set a SOFTCLASS property by name
---@param Object UObject
---@param PropertyName FName
---@param Value UClass
function KismetSystemLibrary.SetSoftClassPropertyByName(Object, PropertyName, Value) end


---Set a STRING property by name
---@param Object UObject
---@param PropertyName FName
---@param Value string
function KismetSystemLibrary.SetStringPropertyByName(Object, PropertyName, Value) end


---Set a TEXT property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FText
function KismetSystemLibrary.SetTextPropertyByName(Object, PropertyName, Value) end


---Set a VECTOR property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FVector
function KismetSystemLibrary.SetVectorPropertyByName(Object, PropertyName, Value) end


---Set a ROTATOR property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FRotator
function KismetSystemLibrary.SetRotatorPropertyByName(Object, PropertyName, Value) end


---Set a LINEAR COLOR property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FLinearColor
function KismetSystemLibrary.SetLinearColorPropertyByName(Object, PropertyName, Value) end


---Set a TRANSFORM property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FTransform
function KismetSystemLibrary.SetTransformPropertyByName(Object, PropertyName, Value) end


---Set a CollisionProfileName property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FCollisionProfileName
function KismetSystemLibrary.SetCollisionProfileNameProperty(Object, PropertyName, Value) end


---Set a custom structure property by name
---@param Object UObject
---@param PropertyName FName
---@param Value FGenericStruct
function KismetSystemLibrary.SetStructurePropertyByName(Object, PropertyName, Value) end


---返回一组跟指定球体范围发生重叠的Actor
---@param WorldContextObject UObject  world上下文对象
---@param SpherePos FVector  球心位置
---@param SphereRadius number  球体半径
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ActorClassFilter UClass  对象类型过滤，只检测指定类型的Actor
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutActors AActor[]  输出的产生碰撞的Actor列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.SphereOverlapActors(WorldContextObject, SpherePos, SphereRadius, ObjectTypes, ActorClassFilter, ActorsToIgnore, OutActors) end


---返回一组跟指定球体范围发生重叠的Component
---@param WorldContextObject UObject  world上下文对象
---@param SpherePos FVector  球心位置
---@param SphereRadius number  球体半径
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ComponentClassFilter UClass  组件类型过滤，只检测指定类型的组件
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutComponents UPrimitiveComponent[]  输出的产生碰撞的组件列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.SphereOverlapComponents(WorldContextObject, SpherePos, SphereRadius, ObjectTypes, ComponentClassFilter, ActorsToIgnore, OutComponents) end


---检测指定Box范围是否发生重叠
---@param WorldContextObject UObject  world上下文对象
---@param BoxPos FVector  Box中心位置
---@param Rotator FRotator  Box旋转量
---@param BoxExtent FVector  Box范围
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ActorClassFilter UClass  对象类型过滤，只检测指定类型的Actor
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.BoxOverlapAnyTest(WorldContextObject, BoxPos, Rotator, BoxExtent, ObjectTypes, ActorClassFilter, ActorsToIgnore) end


---返回一组跟指定Box范围发生重叠的Actor
---@param WorldContextObject UObject  world上下文对象
---@param BoxPos FVector  Box中心位置
---@param BoxRotation FRotator
---@param BoxExtent FVector  Box范围
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ActorClassFilter UClass  对象类型过滤，只检测指定类型的Actor
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutActors AActor[]  输出的产生碰撞的Actor列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.BoxOverlapActors(WorldContextObject, BoxPos, BoxRotation, BoxExtent, ObjectTypes, ActorClassFilter, ActorsToIgnore, OutActors) end


---Returns an array of actors that overlap the given axis-aligned box.
---@param WorldContextObject UObject
---@param BoxPos FVector  Center of box.
---@param BoxRot FRotator  Rotator of box.
---@param BoxExtent FVector  Extents of box.
---@param ObjectTypes integer[]
---@param ActorClassFilter UClass
---@param ActorsToIgnore AActor[]  Ignore these actors in the list
---@param OutActors AActor[]  Returned array of actors. Unsorted.
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.BoxOverlapOBBActors(WorldContextObject, BoxPos, BoxRot, BoxExtent, ObjectTypes, ActorClassFilter, ActorsToIgnore, OutActors) end


---返回一组跟指定Box范围发生重叠的Component
---@param WorldContextObject UObject  world上下文对象
---@param BoxPos FVector  Box中心位置
---@param BoxRotation FRotator
---@param Extent FVector
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ComponentClassFilter UClass
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutComponents UPrimitiveComponent[]  输出的产生碰撞的组件列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.BoxOverlapComponents(WorldContextObject, BoxPos, BoxRotation, Extent, ObjectTypes, ComponentClassFilter, ActorsToIgnore, OutComponents) end


---Returns an array of components that overlap the given axis-aligned box.
---@param WorldContextObject UObject
---@param BoxPos FVector  Center of box.
---@param BoxRot FRotator  Rotator of box.
---@param Extent FVector
---@param ObjectTypes integer[]
---@param ComponentClassFilter UClass
---@param ActorsToIgnore AActor[]  Ignore these actors in the list
---@param OutComponents UPrimitiveComponent[]
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.BoxOverlapOBBComponents(WorldContextObject, BoxPos, BoxRot, Extent, ObjectTypes, ComponentClassFilter, ActorsToIgnore, OutComponents) end


---返回一组跟指定胶囊体范围发生重叠的Actor
---@param WorldContextObject UObject  world上下文对象
---@param CapsulePos FVector  胶囊体中心位置
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半高
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ActorClassFilter UClass  对象类型过滤，只检测指定类型的Actor
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutActors AActor[]  Returned array of actors. Unsorted.
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.CapsuleOverlapActors(WorldContextObject, CapsulePos, Radius, HalfHeight, ObjectTypes, ActorClassFilter, ActorsToIgnore, OutActors) end


---返回一组跟指定胶囊体范围发生重叠的Component
---@param WorldContextObject UObject  world上下文对象
---@param CapsulePos FVector  胶囊体中心位置
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半高
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ComponentClassFilter UClass
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutComponents UPrimitiveComponent[]  输出的产生碰撞的组件列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.CapsuleOverlapComponents(WorldContextObject, CapsulePos, Radius, HalfHeight, ObjectTypes, ComponentClassFilter, ActorsToIgnore, OutComponents) end


---返回一组跟指定Component发生重叠的Actor
---@param Component UPrimitiveComponent  Component对象
---@param ComponentTransform FTransform  Component的Transform
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ActorClassFilter UClass  对象类型过滤，只检测指定类型的Actor
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutActors AActor[]  输出的产生碰撞的Actor列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.ComponentOverlapActors(Component, ComponentTransform, ObjectTypes, ActorClassFilter, ActorsToIgnore, OutActors) end


---返回一组跟指定Component发生重叠的Component
---@param Component UPrimitiveComponent  Component对象
---@param ComponentTransform FTransform  Component的Transform
---@param ObjectTypes integer[]  将结果限制为仅静态或仅动态的选项
---@param ComponentClassFilter UClass
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param OutComponents UPrimitiveComponent[]  输出的产生碰撞的组件列表
---@return boolean  true if there was an overlap that passed the filters, false otherwise.
function KismetSystemLibrary.ComponentOverlapComponents(Component, ComponentTransform, ObjectTypes, ComponentClassFilter, ActorsToIgnore, OutComponents) end


---返回第一个跟射线碰撞的物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.LineTraceSingle(WorldContextObject, Start, End, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟射线碰撞的物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.LineTraceMulti(WorldContextObject, Start, End, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟球体沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.SphereTraceSingle(WorldContextObject, Start, End, Radius, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟球体沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.SphereTraceMulti(WorldContextObject, Start, End, Radius, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟Box沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.BoxTraceSingle(WorldContextObject, Start, End, HalfSize, Orientation, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟Box沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.BoxTraceMulti(WorldContextObject, Start, End, HalfSize, Orientation, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceSingle(WorldContextObject, Start, End, Radius, HalfHeight, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param TraceChannel integer  轨迹检测通道
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceMulti(WorldContextObject, Start, End, Radius, HalfHeight, TraceChannel, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟射线碰撞的物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.LineTraceSingleForObjects(WorldContextObject, Start, End, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---@param WorldContextObject UObject
---@param Start FVector
---@param End FVector
---@param ObjectTypes integer[]
---@param bTraceComplex boolean
---@param ActorsToIgnore AActor[]
---@param DrawDebugType integer
---@param OutHit FHitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean
function KismetSystemLibrary.LineTraceSingleByObjectType(WorldContextObject, Start, End, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟射线碰撞的物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.LineTraceMultiForObjects(WorldContextObject, Start, End, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟球体沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.SphereTraceSingleForObjects(WorldContextObject, Start, End, Radius, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟球体沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.SphereTraceMultiForObjects(WorldContextObject, Start, End, Radius, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟Box沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.BoxTraceSingleForObjects(WorldContextObject, Start, End, HalfSize, Orientation, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟Box沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.BoxTraceMultiForObjects(WorldContextObject, Start, End, HalfSize, Orientation, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceSingleForObjects(WorldContextObject, Start, End, Radius, HalfHeight, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息，只查询指定对象类型
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param ObjectTypes integer[]  对象类型列表
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceMultiForObjects(WorldContextObject, Start, End, Radius, HalfHeight, ObjectTypes, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟射线碰撞的物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.LineTraceSingleByProfile(WorldContextObject, Start, End, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟射线碰撞的物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.LineTraceMultiByProfile(WorldContextObject, Start, End, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟球体沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.SphereTraceSingleByProfile(WorldContextObject, Start, End, Radius, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟球体沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  球体半径
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.SphereTraceMultiByProfile(WorldContextObject, Start, End, Radius, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟Box沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.BoxTraceSingleByProfile(WorldContextObject, Start, End, HalfSize, Orientation, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟Box沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param HalfSize FVector  Box边的半长尺寸
---@param Orientation FRotator  Box的朝向
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.BoxTraceMultiByProfile(WorldContextObject, Start, End, HalfSize, Orientation, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回第一个跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHit FHitResult  输出的HitResult
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceSingleByProfile(WorldContextObject, Start, End, Radius, HalfHeight, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHit, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---返回所有跟胶囊体沿射线移动扫过区域碰撞物体的碰撞信息，按照指定碰撞预设查询
---@param WorldContextObject UObject
---@param Start FVector  射线检测起点
---@param End FVector  射线检测终点
---@param Radius number  胶囊体半径
---@param HalfHeight number  胶囊体半长高度
---@param ProfileName FName  预设名称
---@param bTraceComplex boolean  true为复杂碰撞检测，false为简单碰撞检测
---@param ActorsToIgnore AActor[]  需要忽略的Actor列表
---@param DrawDebugType integer
---@param OutHits FHitResult[]  输出的HitResult列表
---@param bIgnoreSelf boolean
---@param TraceColor FLinearColor
---@param TraceHitColor FLinearColor
---@param DrawTime number
---@return boolean  True if there was a blocking hit, false otherwise.
function KismetSystemLibrary.CapsuleTraceMultiByProfile(WorldContextObject, Start, End, Radius, HalfHeight, ProfileName, bTraceComplex, ActorsToIgnore, DrawDebugType, OutHits, bIgnoreSelf, TraceColor, TraceHitColor, DrawTime) end


---Returns an array of unique actors represented by the given list of components.
---@param ComponentList UPrimitiveComponent[]  List of components.
---@param ActorClassFilter UClass
---@param OutActorList AActor[]  Start of line segment.
function KismetSystemLibrary.GetActorListFromComponentList(ComponentList, ActorClassFilter, OutActorList) end


---@param InString string
---@param TextColor FLinearColor
---@param TextScale FVector2D
---@param Duration number
---@param bIsUGC boolean
function KismetSystemLibrary.PrintToScreen(InString, TextColor, TextScale, Duration, bIsUGC) end


function KismetSystemLibrary.FlushOnScreenDebugMessages() end


---Draw a debug line
---@param WorldContextObject UObject
---@param LineStart FVector
---@param LineEnd FVector
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugLine(WorldContextObject, LineStart, LineEnd, LineColor, Duration, Thickness) end


---Draw a debug circle!
---@param WorldContextObject UObject
---@param Center FVector
---@param Radius number
---@param NumSegments integer
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
---@param YAxis FVector
---@param ZAxis FVector
---@param bDrawAxis boolean
function KismetSystemLibrary.DrawDebugCircle(WorldContextObject, Center, Radius, NumSegments, LineColor, Duration, Thickness, YAxis, ZAxis, bDrawAxis) end


---Draw a debug point
---@param WorldContextObject UObject
---@param Position FVector
---@param Size number
---@param PointColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugPoint(WorldContextObject, Position, Size, PointColor, Duration) end


---Draw directional arrow, pointing from LineStart to LineEnd.
---@param WorldContextObject UObject
---@param LineStart FVector
---@param LineEnd FVector
---@param ArrowSize number
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugArrow(WorldContextObject, LineStart, LineEnd, ArrowSize, LineColor, Duration, Thickness) end


---Draw a debug box
---@param WorldContextObject UObject
---@param Center FVector
---@param Extent FVector
---@param LineColor FLinearColor
---@param Rotation FRotator
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugBox(WorldContextObject, Center, Extent, LineColor, Rotation, Duration, Thickness) end


---Draw a debug coordinate system.
---@param WorldContextObject UObject
---@param AxisLoc FVector
---@param AxisRot FRotator
---@param Scale number
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugCoordinateSystem(WorldContextObject, AxisLoc, AxisRot, Scale, Duration, Thickness) end


---Draw a debug sphere
---@param WorldContextObject UObject
---@param Center FVector
---@param Radius number
---@param Segments integer
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugSphere(WorldContextObject, Center, Radius, Segments, LineColor, Duration, Thickness) end


---Draw a debug cylinder
---@param WorldContextObject UObject
---@param Start FVector
---@param End FVector
---@param Radius number
---@param Segments integer
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugCylinder(WorldContextObject, Start, End, Radius, Segments, LineColor, Duration, Thickness) end


---Draw a debug cone
---@param WorldContextObject UObject
---@param Origin FVector
---@param Direction FVector
---@param Length number
---@param AngleWidth number
---@param AngleHeight number
---@param NumSides integer
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugCone(WorldContextObject, Origin, Direction, Length, AngleWidth, AngleHeight, NumSides, LineColor, Duration, Thickness) end


---Draw a debug cone Angles are specified in degrees
---@param WorldContextObject UObject
---@param Origin FVector
---@param Direction FVector
---@param Length number
---@param AngleWidth number
---@param AngleHeight number
---@param NumSides integer
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugConeInDegrees(WorldContextObject, Origin, Direction, Length, AngleWidth, AngleHeight, NumSides, LineColor, Duration, Thickness) end


---Draw a debug capsule
---@param WorldContextObject UObject
---@param Center FVector
---@param HalfHeight number
---@param Radius number
---@param Rotation FRotator
---@param LineColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugCapsule(WorldContextObject, Center, HalfHeight, Radius, Rotation, LineColor, Duration, Thickness) end


---Draw a debug string at a 3d world location.
---@param WorldContextObject UObject
---@param TextLocation FVector
---@param Text string
---@param TestBaseActor AActor
---@param TextColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugString(WorldContextObject, TextLocation, Text, TestBaseActor, TextColor, Duration) end


---Removes all debug strings.
---@param WorldContextObject UObject
function KismetSystemLibrary.FlushDebugStrings(WorldContextObject) end


---Draws a debug plane.
---@param WorldContextObject UObject
---@param PlaneCoordinates FPlane
---@param Location FVector
---@param Size number
---@param PlaneColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugPlane(WorldContextObject, PlaneCoordinates, Location, Size, PlaneColor, Duration) end


---Flush all persistent debug lines and shapes.
---@param WorldContextObject UObject
function KismetSystemLibrary.FlushPersistentDebugLines(WorldContextObject) end


---Draws a debug frustum.
---@param WorldContextObject UObject
---@param FrustumTransform FTransform
---@param FrustumColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugFrustum(WorldContextObject, FrustumTransform, FrustumColor, Duration, Thickness) end


---Draw a debug camera shape.
---@param CameraActor ACameraActor
---@param CameraColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugCamera(CameraActor, CameraColor, Duration) end


---Draws a 2D Histogram of size 'DrawSize' based FDebugFloatHistory struct, using DrawTransform for the position in the world.
---@param WorldContextObject UObject
---@param FloatHistory FDebugFloatHistory
---@param DrawTransform FTransform
---@param DrawSize FVector2D
---@param DrawColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugFloatHistoryTransform(WorldContextObject, FloatHistory, DrawTransform, DrawSize, DrawColor, Duration) end


---Draws a 2D Histogram of size 'DrawSize' based FDebugFloatHistory struct, using DrawLocation for the location in the world, rotation will face camera of first player.
---@param WorldContextObject UObject
---@param FloatHistory FDebugFloatHistory
---@param DrawLocation FVector
---@param DrawSize FVector2D
---@param DrawColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugFloatHistoryLocation(WorldContextObject, FloatHistory, DrawLocation, DrawSize, DrawColor, Duration) end


---@param Value number
---@param FloatHistory FDebugFloatHistory
---@return FDebugFloatHistory
function KismetSystemLibrary.AddFloatHistorySample(Value, FloatHistory) end


---绘制Actor名称
---@param Actor AActor
---@param Offset FVector
---@param LinearColor FLinearColor
---@param Duration number
function KismetSystemLibrary.DrawDebugActorName(Actor, Offset, LinearColor, Duration) end


---绘制Actor运动轨迹
---@param Actor AActor
---@param LinearColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugActorMoveTrack(Actor, LinearColor, Duration, Thickness) end


---绘制Self到Tartget的连线与距离
---@param WorldContextObject UObject
---@param Self FVector
---@param Target FVector
---@param LinearColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugDistance(WorldContextObject, Self, Target, LinearColor, Duration, Thickness) end


---绘制准心瞄准物体名称
---@param WorldContextObject UObject
---@param Length number
---@param DrawTime number
function KismetSystemLibrary.DrawDebugTargetAimedAt(WorldContextObject, Length, DrawTime) end


---绘制碰撞盒
---@param Actor AActor
---@param LinearColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugActorCollision(Actor, LinearColor, Duration, Thickness) end


---绘制Actor的包围盒
---@param Actor AActor
---@param LinearColor FLinearColor
---@param Duration number
---@param Thickness number
function KismetSystemLibrary.DrawDebugActorBounds(Actor, LinearColor, Duration, Thickness) end


---Mark as modified.
---@param ObjectToModify UObject
function KismetSystemLibrary.CreateCopyForUndoBuffer(ObjectToModify) end


---Get bounds
---@param Component USceneComponent
---@param Origin FVector
---@param BoxExtent FVector
---@param SphereRadius number
function KismetSystemLibrary.GetComponentBounds(Component, Origin, BoxExtent, SphereRadius) end


---@param Actor AActor
---@param Origin FVector
---@param BoxExtent FVector
function KismetSystemLibrary.GetActorBounds(Actor, Origin, BoxExtent) end


---Get the clamped state of r.DetailMode, see console variable help (allows for scalability, cannot be used in construction scripts) 0: low, show only object with DetailMode low or higher 1: medium, show all object with DetailMode medium or higher 2: high, show all objects
---@return integer
function KismetSystemLibrary.GetRenderingDetailMode() end


---Get the clamped state of r.MaterialQualityLevel, see console variable help (allows for scalability, cannot be used in construction scripts) 0: low 1: high 2: medium 3: ultimatehigh
---@return integer
function KismetSystemLibrary.GetRenderingMaterialQualityLevel() end


---Gets the list of support fullscreen resolutions.
---@param Resolutions FIntPoint[]
---@return boolean  true if successfully queried the device for available resolutions.
function KismetSystemLibrary.GetSupportedFullscreenResolutions(Resolutions) end


---Gets the list of windowed resolutions which are convenient for the current primary display size.
---@param Resolutions FIntPoint[]
---@return boolean  true if successfully queried the device for available resolutions.
function KismetSystemLibrary.GetConvenientWindowedResolutions(Resolutions) end


---Gets the smallest Y resolution we want to support in the UI, clamped within reasons
---@return integer  value in pixels
function KismetSystemLibrary.GetMinYResolutionForUI() end


---Gets the smallest Y resolution we want to support in the 3D view, clamped within reasons
---@return integer  value in pixels
function KismetSystemLibrary.GetMinYResolutionFor3DView() end


---@param URL string
function KismetSystemLibrary.LaunchURL(URL) end


---@param URL string
---@return boolean
function KismetSystemLibrary.CanLaunchURL(URL) end


---@param bFullPurge boolean
function KismetSystemLibrary.CollectGarbage(bFullPurge) end


---@return number
function KismetSystemLibrary.GetTimeSinceLastPendingKillPurge() end


---Will show an ad banner (iAd on iOS, or AdMob on Android) on the top or bottom of screen, on top of the GL view (doesn't resize the view) (iOS and Android only)
---@param AdIdIndex integer  The index of the ID to select for the ad to show
---@param bShowOnBottomOfScreen boolean  If true, the iAd will be shown at the bottom of the screen, top otherwise
function KismetSystemLibrary.ShowAdBanner(AdIdIndex, bShowOnBottomOfScreen) end


---Retrieves the total number of Ad IDs that can be selected between
---@return integer
function KismetSystemLibrary.GetAdIDCount() end


---Hides the ad banner (iAd on iOS, or AdMob on Android). Will force close the ad if it's open (iOS and Android only)
function KismetSystemLibrary.HideAdBanner() end


---Forces closed any displayed ad. Can lead to loss of revenue (iOS and Android only)
function KismetSystemLibrary.ForceCloseAdBanner() end


---Will load a fullscreen interstitial AdMob ad. Call this before using ShowInterstitialAd (Android only)
---@param AdIdIndex integer  The index of the ID to select for the ad to show
function KismetSystemLibrary.LoadInterstitialAd(AdIdIndex) end


---Returns true if the requested interstitial ad is loaded and ready (Android only)
---@return boolean
function KismetSystemLibrary.IsInterstitialAdAvailable() end


---Returns true if the requested interstitial ad has been successfully requested (false if load request fails) (Android only)
---@return boolean
function KismetSystemLibrary.IsInterstitialAdRequested() end


---Shows the loaded interstitial ad (loaded with LoadInterstitialAd) (Android only)
function KismetSystemLibrary.ShowInterstitialAd() end


---Displays the built-in leaderboard GUI (iOS and Android only; this function may be renamed or moved in a future release)
---@param CategoryName string
function KismetSystemLibrary.ShowPlatformSpecificLeaderboardScreen(CategoryName) end


---Displays the built-in achievements GUI (iOS and Android only; this function may be renamed or moved in a future release)
---@param SpecificPlayer APlayerController  Specific player's achievements to show. May not be supported on all platforms. If null, defaults to the player with ControllerId 0
function KismetSystemLibrary.ShowPlatformSpecificAchievementsScreen(SpecificPlayer) end


---Returns whether the player is logged in to the currently active online subsystem.
---@param SpecificPlayer APlayerController
---@return boolean
function KismetSystemLibrary.IsLoggedIn(SpecificPlayer) end


---Allows or inhibits screensaver
---@param bAllowScreenSaver boolean  If false, don't allow screensaver if possible, otherwise allow default behavior
function KismetSystemLibrary.ControlScreensaver(bAllowScreenSaver) end


---Allows or inhibits system default handling of volume up and volume down buttons (Android only)
---@param bEnabled boolean  If true, allow Android to handle volume up and down events
function KismetSystemLibrary.SetVolumeButtonsHandledBySystem(bEnabled) end


---Returns true if system default handling of volume up and volume down buttons enabled (Android only)
---@return boolean
function KismetSystemLibrary.GetVolumeButtonsHandledBySystem() end


---Resets the gamepad to player controller id assignments (Android only)
function KismetSystemLibrary.ResetGamepadAssignments() end


---Resets the gamepad assignment to player controller id (Android only)
---@param ControllerId integer
function KismetSystemLibrary.ResetGamepadAssignmentToController(ControllerId) end


---Returns true if controller id assigned to a gamepad (Android only)
---@param ControllerId integer
---@return boolean
function KismetSystemLibrary.IsControllerAssignedToGamepad(ControllerId) end


---Sets the state of the transition message rendered by the viewport. (The blue text displayed when the game is paused and so forth.)
---@param WorldContextObject UObject  World context
---@param bState boolean
function KismetSystemLibrary.SetSuppressViewportTransitionMessage(WorldContextObject, bState) end


---Returns an array of the user's preferred languages in order of preference
---@return string[]  An array of language IDs ordered from most preferred to least
function KismetSystemLibrary.GetPreferredLanguages() end


---Get the default language (for localization) used by this platform
---@return string  The language as an IETF language tag (eg, "zh-Hans-CN")
function KismetSystemLibrary.GetDefaultLanguage() end


---Get the default locale (for internationalization) used by this platform
---@return string  The locale as an IETF language tag (eg, "zh-Hans-CN")
function KismetSystemLibrary.GetDefaultLocale() end


---Returns the currency code associated with the device's locale
---@return string  the currency code associated with the device's locale
function KismetSystemLibrary.GetLocalCurrencyCode() end


---Returns the currency symbol associated with the device's locale
---@return string  the currency symbol associated with the device's locale
function KismetSystemLibrary.GetLocalCurrencySymbol() end


---Requests permission to send remote notifications to the user's device. (Android and iOS only)
function KismetSystemLibrary.RegisterForRemoteNotifications() end


---Requests Requests unregistering from receiving remote notifications to the user's device. (Android only)
function KismetSystemLibrary.UnregisterForRemoteNotifications() end


---Tells the engine what the user is doing for debug, analytics, etc.
---@param UserActivity FUserActivity
function KismetSystemLibrary.SetUserActivity(UserActivity) end


---Returns the command line that the process was launched with.
---@return string
function KismetSystemLibrary.GetCommandLine() end


---Returns the Object associated with a Primary Asset Id, this will only return a valid object if it is in memory, it will not load it
---@param PrimaryAssetId FPrimaryAssetId
---@return UObject
function KismetSystemLibrary.GetObjectFromPrimaryAssetId(PrimaryAssetId) end


---Returns the Blueprint Class associated with a Primary Asset Id, this will only return a valid object if it is in memory, it will not load it
---@param PrimaryAssetId FPrimaryAssetId
---@return UClass
function KismetSystemLibrary.GetClassFromPrimaryAssetId(PrimaryAssetId) end


---Returns the Object Id associated with a Primary Asset Id, this works even if the asset is not loaded
---@param PrimaryAssetId FPrimaryAssetId
---@return UObject
function KismetSystemLibrary.GetSoftObjectReferenceFromPrimaryAssetId(PrimaryAssetId) end


---Returns the Blueprint Class Id associated with a Primary Asset Id, this works even if the asset is not loaded
---@param PrimaryAssetId FPrimaryAssetId
---@return UClass
function KismetSystemLibrary.GetSoftClassReferenceFromPrimaryAssetId(PrimaryAssetId) end


---Returns the Primary Asset Id for an Object, this can return an invalid one if not registered
---@param Object UObject
---@return FPrimaryAssetId
function KismetSystemLibrary.GetPrimaryAssetIdFromObject(Object) end


---Returns the Primary Asset Id for a Class, this can return an invalid one if not registered
---@param Class UClass
---@return FPrimaryAssetId
function KismetSystemLibrary.GetPrimaryAssetIdFromClass(Class) end


---Returns the Primary Asset Id for a Soft Object Reference, this can return an invalid one if not registered
---@param SoftObjectReference UObject
---@return FPrimaryAssetId
function KismetSystemLibrary.GetPrimaryAssetIdFromSoftObjectReference(SoftObjectReference) end


---Returns the Primary Asset Id for a Soft Class Reference, this can return an invalid one if not registered
---@param SoftClassReference UClass
---@return FPrimaryAssetId
function KismetSystemLibrary.GetPrimaryAssetIdFromSoftClassReference(SoftClassReference) end


---Returns list of PrimaryAssetIds for a PrimaryAssetType
---@param PrimaryAssetType FPrimaryAssetType
---@param OutPrimaryAssetIdList FPrimaryAssetId[]
function KismetSystemLibrary.GetPrimaryAssetIdList(PrimaryAssetType, OutPrimaryAssetIdList) end


---Returns true if the Primary Asset Id is valid
---@param PrimaryAssetId FPrimaryAssetId
---@return boolean
function KismetSystemLibrary.IsValidPrimaryAssetId(PrimaryAssetId) end


---Converts a Primary Asset Id to a string. The other direction is not provided because it cannot be validated
---@param PrimaryAssetId FPrimaryAssetId
---@return string
function KismetSystemLibrary.Conv_PrimaryAssetIdToString(PrimaryAssetId) end


---Returns true if the values are equal (A == B)
---@param A FPrimaryAssetId
---@param B FPrimaryAssetId
---@return boolean
function KismetSystemLibrary.EqualEqual_PrimaryAssetId(A, B) end


---Returns true if the values are not equal (A != B)
---@param A FPrimaryAssetId
---@param B FPrimaryAssetId
---@return boolean
function KismetSystemLibrary.NotEqual_PrimaryAssetId(A, B) end


---Returns list of Primary Asset Ids for a PrimaryAssetType
---@param PrimaryAssetType FPrimaryAssetType
---@return boolean
function KismetSystemLibrary.IsValidPrimaryAssetType(PrimaryAssetType) end


---Converts a Primary Asset Type to a string. The other direction is not provided because it cannot be validated
---@param PrimaryAssetType FPrimaryAssetType
---@return string
function KismetSystemLibrary.Conv_PrimaryAssetTypeToString(PrimaryAssetType) end


---Returns true if the values are equal (A == B)
---@param A FPrimaryAssetType
---@param B FPrimaryAssetType
---@return boolean
function KismetSystemLibrary.EqualEqual_PrimaryAssetType(A, B) end


---Returns true if the values are not equal (A != B)
---@param A FPrimaryAssetType
---@param B FPrimaryAssetType
---@return boolean
function KismetSystemLibrary.NotEqual_PrimaryAssetType(A, B) end


---Unloads a primary asset, which allows it to be garbage collected if nothing else is referencing it
---@param PrimaryAssetId FPrimaryAssetId
function KismetSystemLibrary.UnloadPrimaryAsset(PrimaryAssetId) end


---Unloads a primary asset, which allows it to be garbage collected if nothing else is referencing it
---@param PrimaryAssetIdList FPrimaryAssetId[]
function KismetSystemLibrary.UnloadPrimaryAssetList(PrimaryAssetIdList) end


---Returns the list of loaded bundles for a given Primary Asset. This will return false if the asset is not loaded at all. If ForceCurrentState is true it will return the current state even if a load is in process
---@param PrimaryAssetId FPrimaryAssetId
---@param bForceCurrentState boolean
---@param OutBundles FName[]
---@return boolean
function KismetSystemLibrary.GetCurrentBundleState(PrimaryAssetId, bForceCurrentState, OutBundles) end


---Returns the list of assets that are in a given bundle state. Required Bundles must be specified If ExcludedBundles is not empty, it will not return any assets in those bundle states If ValidTypes is not empty, it will only return assets of those types If ForceCurrentState is true it will use the current state even if a load is in process
---@param RequiredBundles FName[]
---@param ExcludedBundles FName[]
---@param ValidTypes FPrimaryAssetType[]
---@param bForceCurrentState boolean
---@param OutPrimaryAssetIdList FPrimaryAssetId[]
function KismetSystemLibrary.GetPrimaryAssetsWithBundleState(RequiredBundles, ExcludedBundles, ValidTypes, bForceCurrentState, OutPrimaryAssetIdList) end


---Functions for Asset Redirect
---@param InPackageNameRemap table<FName, FName>
function KismetSystemLibrary.AddResMapping(InPackageNameRemap) end


---@param InPackagePathRemap table<string, string>
function KismetSystemLibrary.AddResPathMapping(InPackagePathRemap) end


---@param InARPaths table<string, boolean>
function KismetSystemLibrary.AddResARMapping(InARPaths) end


---@param InARRoot string
---@param InARPaths table<string, boolean>
function KismetSystemLibrary.IterateAddResARMapping(InARRoot, InARPaths) end


---@param InARRoot string
---@param InARPaths table<string, boolean>
function KismetSystemLibrary.IterateRemoveResARMapping(InARRoot, InARPaths) end


---@param InARPath string
---@return boolean
function KismetSystemLibrary.IsResARMapping(InARPath) end


---@param PathKeys string[]
function KismetSystemLibrary.RemoveResMapping(PathKeys) end


function KismetSystemLibrary.EmptyResMapping() end


---@param InPackageNames table<FName, boolean>
function KismetSystemLibrary.AddBlackResMapping(InPackageNames) end


---@param InPackageNames table<FName, boolean>
function KismetSystemLibrary.RemoveBlackResMapping(InPackageNames) end


function KismetSystemLibrary.EmptyBlackResMapping() end


function KismetSystemLibrary.BindPackageNameResolver() end


function KismetSystemLibrary.UnBindPackageNameResolver() end


---@return boolean
function KismetSystemLibrary.IsPackageNameResolverBinded() end


---@param InARPath string
---@return boolean
function KismetSystemLibrary.IsARPathActivated(InARPath) end


---@param Path FName
---@param OriginalPath FName
---@return boolean
function KismetSystemLibrary.GetOriginalPath(Path, OriginalPath) end


---@param InSourcePackagePath string
---@return string
function KismetSystemLibrary.GetDelegateResolvedPackagePath(InSourcePackagePath) end


