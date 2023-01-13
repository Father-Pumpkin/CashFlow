-- Create an instance of ACE3
CashFlowAddon = LibStub("AceAddon-3.0"):NewAddon("CashFlow", "AceConsole-3.0", "AceEvent-3.0")

function CashFlowAddon:OnInitialize()
    self:Print("CashFlow has been initialized")
    self.db = LibStub("AceDB-3.0"):New("CashFlowDB")

  end

function CashFlowAddon:OnEnable()
    self:Print("CashFlow has been Enabled")
    self.db.char.goldThisSession = 0
    self.db.char.goldBeforeTransaction = tonumber(GetMoney())
    self:RegisterEvent("PLAYER_MONEY")
    self:RegisterChatCommand("cfreset", "CashFlowReset")
end

function CashFlowAddon:OnDisable()
end

function CashFlowAddon:CashFlowReset()
    self.db.char.goldThisSession = 0
    self:Print("Session gold has been reset to 0")
end

function CashFlowAddon:PLAYER_MONEY()
    -- will be called every time the player gains money
    currentMoney = tonumber(GetMoney())
    if currentMoney > self.db.char.goldBeforeTransaction then 
        self.db.char.goldThisSession = self.db.char.goldThisSession + (currentMoney - self.db.char.goldBeforeTransaction)
        self:Print("Money gained this session is: " .. math.floor((self.db.char.goldThisSession/10000)) .. "g " .. 
        (math.floor((self.db.char.goldThisSession/100))%100) .. "s " .. self.db.char.goldThisSession%100 .. "c")
    end
    self.db.char.goldBeforeTransaction = currentMoney
end
  