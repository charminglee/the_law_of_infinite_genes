# Lua代码规范

## 命名规范

编写Lua时需遵循以下命名规范（引擎提供的接口除外）：

- 全局变量：大驼峰（ `GlobalVariable` ）
- 局部变量：小驼峰（ `localVariable` ）
- 私有变量：单下划线前缀+小驼峰（ `_privateVariable` ）
- 常量：全大写+下划线分隔（ `CONSTANT_NAME` ）
- 函数：小驼峰（ `functionName` ）
- 类：大驼峰（ `ClassName` ）
- 文件/目录：大驼峰（ `FileName` ）

此外，对于不同的分类，还可以在名称前加上分类前缀，以下划线分隔，如 `Monster_SpeedInfected` 、 `Boss_RottenArmor` 。

## 编码规范

### 调用父类方法

必须通过当前类名获取 `SuperClass` ，而不是 `self` 。

✅

```lua
function UGCGameState:ReceiveBeginPlay()
    UGCGameState.SuperClass.ReceiveBeginPlay(self)
end
```

❌

```lua
function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
end
```

### 属性初始化

所有类/实例中出现的属性必须在类定义中显式指定一个默认值，即使它默认为 `nil` 。

✅

```lua
local UGCGameState = {
    comp = nil
}

function UGCGameState:getComp()
    if self.comp == nil then
        self.comp = GetComponentByClass(class)
    end
    return self.comp
end
```

❌

```lua
local UGCGameState = {}

function UGCGameState:getComp()
    if self.comp == nil then
        self.comp = GetComponentByClass(class)
    end
    return self.comp
end
```

或在注释中指定通过蓝图设置的属性字段。

```lua
---@field comp Component_C
local UGCGameState = {}
```

### 模块级函数/单例方法

模块级函数/单例方法的定义和调用统一使用 `.` 运算符，而不是 `:` 。

✅

```lua
function TweenManager.initialize()
    TweenManager.inited = true
end
```

❌

```lua
function TweenManager:initialize()
    self.inited = true
end
```

## 注释

对于公共接口，需在函数定义上方编写 LDoc 风格的文档注释。若函数无返回值，可省略 `@return` 。

```lua
---函数描述
---@param param1 参数类型 参数描述
---@param param2 参数类型 参数描述
---@return 返回值类型 返回值描述
function UGCGameState:doSomething(param1, param2)
end
```
