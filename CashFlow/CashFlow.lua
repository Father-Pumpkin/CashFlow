-- Create an instance of ACE3
MyCashFlowAddon = LibStub("AceAddon-3.0"):NewAddon("CashFlow", "AceConsole-3.0", "AceEvent-3.0")

-- Register Chat Commands for CashFlow
--MyAddon:RegisterChatCommand("cfreport", "CashFlowReport")

function MyCashFlowAddon:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    --self.db = LibStub("AceDB-3.0"):New("CashFlowDB")
    self:Print("CashFlow has been initialized")

    -- TODO: update to be usable across more than 1 session
    --local moneyThisSession = 0
    --local currentMoney = GetMoney()
  end

function MyCashFlowAddon:OnEnable()
    self:Print("CashFlow has been Enabled")
    self:RegisterEvent("PLAYER_MONEY")
end

function MyCashFlowAddon:OnDisable()
end

function MyCashFlowAddon:PLAYER_MONEY()
    -- will be called every time the player gains money
    local currentMoney = GetMoney()
    self:Print(currentMoney)
end
--[[
function MyCashFlowAddon:CashFlowReport(input)
    -- Process the slash command ('input' contains whatever follows the slash command)
    self:Print(print(("I have earned %dg %ds %dc"):format(moneyThisSession / 100 / 100, (moneyThisSession / 100) % 100, moneyThisSession % 100));)
  end
  ]]
  

  
