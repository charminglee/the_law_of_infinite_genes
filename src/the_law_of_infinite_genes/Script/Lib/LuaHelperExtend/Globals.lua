---@meta

---查找对象。
---@param UClass UClass
---@param UPackage UObject
---@param ObjectName string
---@param bExactClass boolean
---@return UObject
function StaticFindObject(UClass, UPackage, ObjectName, bExactClass) end


---查找对象。
---@param UClass UClass
---@param UPackage UObject
---@param ObjectName string
---@param bExactClass boolean
---@return UObject
function StaticFindObjectFast(UClass, UPackage, ObjectName, bExactClass) end


---检查对象是否有效。
---@param Object UObject
---@return boolean
function IsValid(Object) end


---@param path string
---@return table|nil
function CreateStruct(path) end


---创建UI对象。
---@param bp_lua any @当前bp_lua对象
---@param ClassFullPath string @UI类全路径
---@return any
function CreateUIWidget(bp_lua, ClassFullPath) end


---创建UI对象。
---@param bp_lua any @当前的bp_lua对象
---@param Class UClass @对象类UClass*
---@return any
function CreateUIWidgetWithClass(bp_lua, Class) end


---加载对象。
---UE全局API封装：T* LoadObject(...)
---@param ObjectFullPath string @对象全路径
---@return UObject
function LoadObject(ObjectFullPath) end


---加载类。
---UE全局API封装：T* LoadClass(...)
---@param ClassFullPath string @类全路径
---@return UClass
function LoadClass(ClassFullPath) end


---判断传入值是否为UObject对象。
---@param Object any @检查的数据
---@param bEvenNullptr boolean @是否将nullptr视作UObject
---@return boolean
function IsObject(Object, bEvenNullptr) end


---获取Object的ClassName。
---@param Object UObject
---@return string
function GetClassName(Object) end


---创建弱指针对象指向Object。
---@param Object UObject
---@return any
function WeakObjectPtr(Object) end


---类型C++的check(): SHIPPING版空执行返回true; Dev版本flag为false时弹窗提示返回false，为true返回true。
---@param flag boolean
---@return boolean
function CheckData(flag) end


---辅助 WorldContext 参数：需要此参数的地方可使用该接口返回值传入。
---@param InObj UObject @指定的WorldContect, 有效则返回InObj, 无效返回一个通用的WorldContext对象(目前为 GameFrontHUD)
---@return UObject
function GetWorldContext(InObj) end


---调试功能; 显示系统弹窗。
---主要用于开发模式下的提示，Shipping版本调用为空逻辑。
---@param Title string
---@param Message string
function ShowPlatformMessageBox(Title, Message) end


---调试功能; 主要用于将 UStruct/TArray/TMap/TSet 转为table类型，然后打印输出进行数据查看。
---Dev版本：支持全部结构体/容器的转换；Shipping版本：仅支持容器的转换。
---@param Data any
---@return table
function totable(Data) end
