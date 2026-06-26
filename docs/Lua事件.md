# Lua事件

事件的监听与触发使用 `Lib.EventSystem.Listen()` 与 `Lib.EventSystem.Emit()` 实现。

### 监听示例

对于实例方法：

```lua
local UGCPlayerController = {}

function UGCPlayerController:ReceiveBeginPlay()
    Lib.EventSystem.Listen("OnCardEquipAfter", self.OnCardEquipAfter, self)
end

function UGCPlayerController:OnCardEquipAfter(fromSlot, toSlot, card)
    -- 处理逻辑
end
```

对于非实例方法（普通函数）：

```lua
local function OnCardEquipAfter(fromSlot, toSlot, card)
    -- 处理逻辑
end

Lib.EventSystem.Listen("OnCardEquipAfter", OnCardEquipAfter)
```

### 触发示例

```lua
Lib.EventSystem.Emit("OnCardEquipAfter", fromSlot, toSlot, card)
```

## 事件列表

### OnCardShopRefreshAfter

【双端】刷新卡牌商店后触发。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | shop | table | 刷新后的卡牌列表，每个元素为 `{cardId, star}` |

### OnCardEquipAfter

【双端】装备卡牌后触发（仓库 → 卡牌槽）。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | fromSlot | number | 仓库槽位索引 |
    | 2 | toSlot | number | 卡牌槽位索引 |
    | 3 | card | table | 装备的卡牌 `{cardId, star}` |

### OnCardUnequipAfter

【双端】卸下卡牌后触发（卡牌槽 → 仓库）。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | fromSlot | number | 卡牌槽位索引 |
    | 2 | toSlot | number | 仓库槽位索引 |
    | 3 | card | table | 卸下的卡牌 `{cardId, star}` |

### OnCardPurchaseAfter

【双端】购买卡牌后触发（商店 → 仓库）。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | fromSlot | number | 商店槽位索引 |
    | 2 | toSlot | number | 仓库槽位索引 |
    | 3 | card | table | 购买的卡牌 `{cardId, star}` |
    | 4 | cost | number | 花费的资源点数量 |

### OnCardSellAfter

【双端】出售卡牌后触发。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | from | string | 出售来源：`"store"`（仓库）或 `"equipped"`（卡牌槽） |
    | 2 | slot | number | 出售槽位索引 |
    | 3 | card | table | 出售的卡牌 `{cardId, star}` |
    | 4 | refund | number | 返还的资源点数量 |

### OnCoinChangeAfter

【双端】货币数量变化后触发。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | id | number | 货币ID |
    | 2 | old | number | 变化前的数量 |
    | 3 | new | number | 变化后的数量 |

### OnTitleEquipAfter

【双端】佩戴或卸下称号后触发。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | title | Title \| nil | 当前佩戴的称号；`nil` 表示卸下 |

### OnTitleUnlockAfter

【双端】解锁称号后触发。

- 参数：

    | 序号 | 参数 | 类型 | 说明 |
    | --- | --- | --- | --- |
    | 1 | title | Title | 解锁的称号 |
