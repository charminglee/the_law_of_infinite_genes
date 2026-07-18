
RecruitManager = RecruitManager or
{
    MainUI = nil;
    MainClass = nil;
    TeamInfo = {
        SelectedIndex = nil,
        HasTeam = false,
        TeamId = nil,
    };
    TeamList  = {
        [1] = {
            name='张三的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [2] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [3] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [4] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [5] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [6] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [7] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [8] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [9] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [10] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [11] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [12] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [13] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        },
        [14] = {
            name='李四的队伍',
            RoomConfig = {
                MapId = 1,
                Rating = 1,
            },
            member={
                [1] = {name='李四', UID=100},
                [2] = {name='王五', UID=200},
                [3] = nil,
                [4] = nil
            }
        }

    }
}

function RecruitManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function RecruitManager:RegisterMainUI(MainUI)

    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function RecruitManager:UnregisterMainUI()
    self.MainUI = nil;
end

function RecruitManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Visible);
end

function RecruitManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:SetVisibility(ESlateVisibility.Collapsed);
end

function RecruitManager:GetMainUI()
    return self.MainUI;
end
