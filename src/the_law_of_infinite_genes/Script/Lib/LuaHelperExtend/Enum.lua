---@diagnostic disable-next-line: annotation-usage-error
---@enum ESlateVisibility
---@field Visible number @Default widget visibility - visible and can interact with the cursor
---@field Collapsed number @Not visible and takes up no space in the layout; can never be clicked on because it takes up no space.
---@field Hidden number @Not visible, but occupies layout space. Not interactive for obvious reasons.
---@field HitTestInvisible number @Visible to the user, but only as art. The cursors hit tests will never see this widget.
---@field SelfHitTestInvisible number @Same as HitTestInvisible, but doesn't apply to child widgets.
ESlateVisibility = {}