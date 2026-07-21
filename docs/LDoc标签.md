# LDoc 标签

本项目采用 **LDoc 风格的文档注释** 。注释以 `---` （三个连字符）开头，标签以 `@` 引导。这些注释可被 [LDoc](https://stevedonovan.github.io/ldoc/) 、 [EmmyLua](https://github.com/EmmyLua/EmmyLuaDoc) 与 [lua-language-server（sumneko）](https://github.com/LuaLS/lua-language-server) 等工具识别，用于生成 API 文档与提供编辑器智能提示。

> 本项目实际使用的是 **LuaCATS 三横线语法** （ `---@tag` ）。它向下兼容经典 LDoc 语法（ `@tag` ），功能更强大，是当前 Lua 生态的主流规范。本文以 LuaCATS 语法为主进行说明，并在末尾列出经典 LDoc 标签作为补充。

## 基础语法

- 文档注释必须以 `---` 开头，普通注释为 `--` 。
- 标签紧贴 `---` ：`---@tag` 或 `--- @tag` （中间可有空格，建议无空格）。
- 标签作用于其 **下方紧邻** 的代码元素（函数、变量、table 等），两者之间不能有任何其他代码。

```lua
---函数的简要描述，以句号结尾。
---@param x number 第一个数
---@param y number 第二个数
---@return number 两数之和
function add(x, y)
    return x + y
end
```

## 函数标签

### `@param`

声明函数参数。

**语法：** `---@param name type description`

```lua
---触发指定事件。
---@param eventName string 事件名
---@param emitType number 触发方式，请使用EventSystem.EmitType枚举值
---@param ... any 回调参数
function EventSystem.Emit(eventName, emitType, ...)
end
```

- `...` 表示可变参数。
- 在形参名后加 `?` 表示可选参数。

---

### `@return`

声明函数返回值，函数无返回值时可省略。

**语法：** `---@return type description`

```lua
---判断当前环境是否是服务端。
---@return boolean 是否是服务端
function Lib.IsServer()
end
```

多个返回值写多行 `@return`：

```lua
---@return number 最大值
---@return number 最小值
function minmax(arr) 
end
```

## 类型/类标签

### `@class`

声明一个类（或自定义类型）。可声明继承关系与所在命名空间。

**语法：** `---@class name[:parent] [@namespace]`

```lua
---@class UGCPlayerState_C:BP_UGCPlayerState_C
local UGCPlayerState = {}
```

---

### `@field`

声明类/结构体的字段。

**语法：** `---@field [scope] name type [description]`

```lua
---@class Lib
---@field EventSystem EventSystem
Lib = { EventSystem = ... }
```

`scope`（可选）控制可见性，取值为 `public` / `protected` / `private`：

```lua
---@class Account
---@field public id number 账户ID
---@field private _password string 密码
local Account = {}
```

---

### `@type`

声明变量/字段的类型。常用于标注局部变量或表字段。

**语法：** `---@type type [description]`

```lua
---@type number 最大重试次数
local MAX_RETRY = 3
```

---

### `@enum`

声明枚举表。

**语法：** `---@enum name`

```lua
---@enum UGCNativeGameAttributeType
UGCNativeGameAttributeType = {
    MaxHealth = 1,
    MoveSpeed = 2,
}
```

---

### `@alias`

为类型起别名，常用于简化复杂类型。

**语法：** `---@alias name type`

```lua
---@alias Card number[]
---@alias CardEquipCallback fun(fromSlot: number, toSlot: number, card: Card)

---@param callback CardEquipCallback 回调函数
function ListenForCardEquipEvent(callback) 
end

---@param callback CardEquipCallback 回调函数
function UnlistenForCardEquipEvent(callback) 
end
```

## 可见性与作用域标签

### `@within` / `@private` / `@protected` / `@public`

控制元素在编辑器补全与文档中的可见范围。

| 标签 | 含义 |
| --- | --- |
| `@public` | 公开（默认） |
| `@protected` | 受保护，子类可见 |
| `@private` | 私有，仅当前类/模块可见 |

```lua
---@class Service
local Service = {}

---@within Service
---@private
function Service._helper() -- 仅模块内部可见，外部补全不会提示
end   
```

## 文档增强标签

### 描述文本

任何 `---@` 标签上方的 `---` 段落即为摘要描述，可写多行：

```lua
---触发指定事件。
---根据触发方式决定事件是否跨端传播。
---@param eventName string 事件名
function EventSystem.Emit(eventName, ...)
end
```

---

### `@see`

引用其他符号、模块或 URL，用于交叉链接。

```lua
---@see EventSystem.Listen
---@see EventSystem.Emit
function EventSystem.Unlisten() 
end
```

---

### `@usage` / `@example`

提供用法示例代码，文档中会高亮显示。

```lua
---添加监听。
---@usage
---```lua
---Lib.EventSystem.Listen("OnCardEquipAfter", self.OnCardEquipAfter, self)
---```
function EventSystem.Listen() 
end
```

---

### `@deprecated`

标记元素已弃用，调用时编辑器会显示删除线提示。

---

### `@todo` / `@fixme` / `@warning` / `@note`

标注待办、已知问题、警告等（多用于生成文档时归类）。

## 元/高级标签

### `@meta`

声明一个文件为类型定义文件，其中的全局声明只用于智能提示，不会被当作真实运行时代码。

```lua
---@meta

---@class LobbyTabs
---@field TabID int32
---@field TabName FString
---@field TabDesc FString
```

---

### `@operator`

为类型声明运算符重载的语义，便于补全。

```lua
---@class Vec2
---@operator add(Vec2): Vec2
local Vec2 = {}
```

---

### `@overload`

为函数声明额外的签名重载（编辑器会按重载提示参数）。

```lua
---@overload fun(id: number): PlayerState
---@overload fun(name: string): PlayerState
---@param key number|string 查找键
function GetPlayer(key) 
end
```

---

### `@generic`

声明泛型函数/类型。

```lua
---@generic T
---@param arr T[]
---@return T
function First(arr) 
    return arr[1] 
end
```

---

### `@async`

标记函数为异步（协程），编辑器在补全返回值时按协程处理。

```lua
---@async
---@return string
function Fetch() 
end
```

---

### `@nodiscard`

提示调用者必须使用返回值，忽略返回值会报警告。

```lua
---@nodiscard
---@return number
function Compute()
end
```

---

### `@cast`

强制转换变量类型（用于纠正推断不准确的场景）。

**语法：** `---@cast name type`

```lua
local obj = GetSomething()
---@cast obj UGCPlayerController_C
obj:ReceiveBeginPlay()
```

## 类型标注速查

`@param` / `@return` / `@field` / `@type` 等标签中的 `type` 均可使用以下类型写法：

| 类型 | 含义 | 示例 | 等价写法 |
| --- | --- | --- | --- |
| `number` / `string` / `boolean` / `function` / `table` / `any` | 基础类型 | | |
| `nil` | 空值 | | |
| `MyType` | 自定义类型（需先用 `@class` 、 `@enum` 等标签声明） | | |
| `T[]` | 元素类型为 `T` 的数组 | `number[]` | `table<T>` |
| `T?` | 可空类型（值可能为 `nil` ） | `number?` | `T\|nil` |
| `T1\|T2\|...\|Tn` | 联合类型（取值可为 `T1` 、 `T2` 等） | `number\|string` | |
| `[T1, T2, ..., Tn]` | 元组类型，表示有 `n` 个元素的元组，元素类型分别为 `T1, T2, ..., Tn` | `[number, string]` | |
| `table<KT, VT>` | 键类型为 `KT` ，值类型为 `VT` 的表 | `table<string, number>` | |
| `{k1: VT1, k2: VT2, ..., kn: VTn}` | 类型化表，显式表示表的键名 | `{x: number, y: number, z: number}` | |
| `fun(arg1: T1, arg2: T2, ..., argn: Tn): RT` | 函数签名 | `fun(a: number, b: number): number` | |
