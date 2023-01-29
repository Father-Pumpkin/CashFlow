-- Create an instance of ACE3
CashFlowAddon = LibStub("AceAddon-3.0"):NewAddon("CashFlow", "AceConsole-3.0", "AceEvent-3.0")
local CashFlowAddon = _G.CashFlowAddon
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local string_format = string.format
local string_match = string.match
local string_lower = string.lower
local math_floor = math.floor
local math_fmod = math.fmod


local options = { 
	name = "CashFlow",
	handler = CashFlowAddon,
	type = "group",
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
	},
}

function CashFlowAddon:CreateFrame()
    self:Print("Creating the Frame")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("CashFlow")
    frame:SetStatusText("CashFlow Income Tracker")
    frame:SetLayout("List")
    local resetButton = AceGUI:Create("Button")
    resetButton:SetText("RESET")
    resetButton:SetWidth(200)
    resetButton:SetCallback("OnClick", function() CashFlowAddon:CashFlowReset() end)
    frame:AddChild(resetButton)
    self:Print("Reset Button Created")
    local reportButton = AceGUI:Create("Button")
    reportButton:SetText("Report")
    reportButton:SetWidth(200)
    reportButton:SetCallback("OnClick", function() CashFlowAddon:CashFlowReport() end)
    frame:AddChild(reportButton)
    self:Print("Report Button Created")
end

function CashFlowAddon:GetMessage(info)
	return self.message
end

function CashFlowAddon:SetMessage(info, value)
	self.message = value
end

function CashFlowAddon:OnInitialize()
    self:Print("CashFlow has been Initialized")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("CashFlow", options, nil)
    self.db = LibStub("AceDB-3.0"):New("CashFlowDB")
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CashFlow", "CashFlow")
    self:RegisterCommands()
    
  end

function CashFlowAddon:OnEnable()
    self:Print("CashFlow has been Enabled")
    self:CreateFrame()
    self.db.char.goldThisSession = 0
    self.db.char.goldBeforeTransaction = tonumber(GetMoney())
    if self.db.char.goldAllTime == nil then self.db.char.goldAllTime = 0 end
    self:RegisterEvent("PLAYER_MONEY")
    
end

function CashFlowAddon:RegisterCommands()
    self:RegisterChatCommand("cf", "CashFlowChatCommandManager")
    self:RegisterChatCommand("cfreset", "CashFlowReset")
    self:RegisterChatCommand("cfhelp", "CashFlowHelp")
    self:RegisterChatCommand("cfreport", "CashFlowReport")
end

function CashFlowAddon:OnDisable()
end

function CashFlowAddon:CashFlowChatCommandManager(input)
    if input == nil or input == "" or input == "help" then
        self:CashFlowHelp()
    elseif input == "reset" then
        self:CashFlowReset()
    elseif input == "reset all" then
        self:CashFlowReset("all")
    elseif input == "report" then
        self:CashFlowReport()
    elseif input == "report all" then
        self:CashFlowReport("all")
    else
        self:Print(input .. " is not a valid option. Type \"/cf help\" for more info.")
    end
end

function CashFlowAddon:CashFlowReset(input)
    if input == "" or input == nil then
        self.db.char.goldThisSession = 0
        self:Print("Session gold has been reset to 0")
    elseif input == "all" then
        self.db.char.goldAllTime = 0
        self:Print("Character all-time gold has been reset to 0")
    else
        self:Print(input .. " is not a valid option. Type /cfhelp for more info.")
    end
end

function CashFlowAddon:CashFlowReport(input)
    if input == "" or input == nil then
        self:Print("Money gained this session is: " .. math.floor((self.db.char.goldThisSession/10000)) .. "g " .. 
        (math.floor((self.db.char.goldThisSession/100))%100) .. "s " .. self.db.char.goldThisSession%100 .. "c")
    elseif input == "all" then
        self:Print("Money gained all time is: " .. math.floor((self.db.char.goldAllTime/10000)) .. "g " .. 
        (math.floor((self.db.char.goldAllTime/100))%100) .. "s " .. self.db.char.goldAllTime%100 .. "c")
    else
        self:Print(input .. " is not a valid option. Type /cfhelp for more info.")
    end
end

function CashFlowAddon:CashFlowHelp(input)
    if input == "" or input == nil then
        self:Print("Possible Chat commands are:\n cfreset\n cfreset all\n cfhelp")
    elseif input == "cfreset" then
        self:Print("Options available to cfreset are blank for session reset or all for alltime reset.")
    else
        self:Print(input .. " is not a valid option. Type /cfhelp for more info.")
    end
end

function CashFlowAddon:PLAYER_MONEY()
    -- will be called every time the player gains money
    currentMoney = tonumber(GetMoney())
    if currentMoney > self.db.char.goldBeforeTransaction then 
        self.db.char.goldThisSession = self.db.char.goldThisSession + (currentMoney - self.db.char.goldBeforeTransaction)
        self.db.char.goldAllTime = self.db.char.goldAllTime + (currentMoney - self.db.char.goldBeforeTransaction)
        self:Print("Money gained this session is: " .. math.floor((self.db.char.goldThisSession/10000)) .. "g " .. 
        (math.floor((self.db.char.goldThisSession/100))%100) .. "s " .. self.db.char.goldThisSession%100 .. "c")
    end
    self.db.char.goldBeforeTransaction = currentMoney
end