---@meta


---@class UE
local UE = {}


---检查对象是否为指定类的实例。
---UObject成员API封装：bool IsA(OtherClassType SomeBase);
---@param Object UObject @对象
---@param Class UClass @类型Class
---@return boolean
function UE.IsA(Object, Class) end


---查找对象。
---全局API封装: UObject* StaticFindObject( UClass*, UObject*, TCHAR*, bool);
---@param UClass UClass
---@param UPackage UObject
---@param ObjectName string
---@param bExactClass boolean
---@return UObject
function UE.FindObject(UClass, UPackage, ObjectName, bExactClass) end


---查找对象。
---全局API封装: UObject* StaticFindObjectFast(UClass*, UObject*, FName, bool, ...);
---@param UClass UClass
---@param UPackage UObject
---@param ObjectName string
---@param bExactClass boolean
---@return UObject
function UE.FindObjectFast(UClass, UPackage, ObjectName, bExactClass) end


---等价 _G.LoadObject。
---@param ObjectFullPath string
---@return UObject
function UE.LoadObject(ObjectFullPath) end


---加载对象。
---全局API封装: UObject* StaticLoadObject(UClass*, UObject*, TCHAR*, ...);
---@param UClass UClass
---@param Outer UObject
---@param ObjectName string
---@return UObject
function UE.StaticLoadObject(UClass, Outer, ObjectName) end


---等价 _G.LoadClass。
---@param ClassFullPath string
---@return UClass
function UE.LoadClass(ClassFullPath) end


---访问对象名字。
---UObject成员API封装：FString GetName();
---@param Object UObject
---@return string
function UE.GetName(Object) end


---访问对象名字。
---UObject成员API封装：FString GetFullName();
---@param Object UObject
---@return string
function UE.GetFullName(Object) end


---访问对象名字。
---UObject成员API封装：FString LuaGetPathName();
---@param Object UObject
---@return string
function UE.LuaGetPathName(Object) end


---访问对象Outer。
---UObject成员API封装：UObject* GetOuter();
---@param Object UObject
---@return UObject
function UE.GetOuter(Object) end


---检查对象是否有效。
---全局API封装：bool IsValid(const UObject*);
---@param Object UObject
---@return boolean
function UE.IsValid(Object) end


---检查UObject是否为空指针; 辅助 _G.IsValid()。
---@param Object UObject @UObject数据
---@return boolean
function UE.IsObject(Object) end


---将结构体/容器转为table; 辅助 _G.totable。
---@param Data any
---@return table
function UE.ToTable(Data) end
