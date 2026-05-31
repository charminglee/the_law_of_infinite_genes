---@class UI3D_C:UUserWidget
---@field Icon UImage
---@field Title UTextBlock
--Edit Below--
local UI3D = { bInitDoOnce = false } 


function UI3D:Construct()
	self:LuaInit();
	
end


-- function UI3D:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI3D:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI3D:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.Title:BindingProperty("Text", self.Title_Text, self);
	self.Icon:BindingProperty("Brush", self.Icon_Brush, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function UI3D:Title_Text(ReturnValue)
	return "略有盈余";
end

function UI3D:Icon_Brush(ReturnValue)
	return {
        Brush = {
            ResourceObject=UE.LoadObject("MaterialInstanceConstant'/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_1.WealthTitle_1'")
        }
    };
end

-- [Editor Generated Lua] function define End;

return UI3D