loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Dragon-Menu-/refs/heads/main/Library.lua"))()



MakeWindow({

    Hub = {

        Title = "Dragon Menu I Universal - v5.7",

        Animation = "by : Victorscript "

    },

    

    Key = {

        KeySystem = false,

        Title = "Sistema de Chave",

        Description = "Digite a chave correta para continuar.",

        KeyLink = "https://seusite.com/chave",

        Keys = {"1234", "28922"},

        Notifi = {

            Notifications = true,

            CorrectKey = "Chave correta! Iniciando script...",

            Incorrectkey = "Chave incorreta, tente novamente.",

            CopyKeyLink = "Link copiado!"

        }

    }

})



MinimizeButton({

    Image = "rbxassetid://137903795082783",

    Size = {40, 40},

    Color = Color3.fromRGB(10, 10, 10),

    Corner = true,

    CornerRadius = UDim.new(0.5, 0),

    Stroke = true,  -- Ativa a borda

    StrokeColor = Color3.fromRGB(255, 0, 0)

})


-- Criação da aba principal



local Main = MakeTab({Name = "Main"})
local Player = MakeTab({Name = "Player"})
local Visuais = MakeTab({Name = "Visuals"})
local Servidor = MakeTab({Name = "Server"})
local Config = MakeTab({Name = "Settings"})


MakeNotifi({
  Title = "Dragon Menu",
  Text = "Script Loaded Successfully",
  Time = 5
})


AddButton(Main, {
    Name = "Fly GUI v4",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Fly-v4/refs/heads/main/main.lua"))()
        end)
    end
})


-- Noclip
local noclipConnection

function toggleNoclip(enable)
    if enable then
        if not noclipConnection then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Toggle para ativar/desativar colisão
AddToggle(Main, {
    Name = "Disable Collisions", 
    Default = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})


-- Infinite Jump
local jumpConnection
local function toggleInfiniteJump(enable)
    if enable then
        if not jumpConnection then
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

-- Toggle para ativar/desativar pulo infinito
local Toggle = AddToggle(Main, {
    Name = "Infinite jumps",
    Default = false,
    Callback = function(Value)
        toggleInfiniteJump(Value)
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Estado atual
local velocidadeAtivada = false
local velocidadeValor = 25

local jumpAtivado = false
local jumpPowerSelecionado = 40
local jumpPowerPadrao = 50

local gravidadeAtivada = false
local gravidadeSelecionada = 196.2
local gravidadePadrao = 196.2

-- Função para aplicar velocidade
local function aplicarVelocidade(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and velocidadeAtivada then
		humanoid.WalkSpeed = velocidadeValor
	elseif humanoid then
		humanoid.WalkSpeed = 16
	end
end

-- Função para aplicar super pulo
local function aplicarJumpPower(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = jumpAtivado and jumpPowerSelecionado or jumpPowerPadrao
	end
end

-- Aplica toda vez que o personagem renasce
LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	task.wait(0.1)
	aplicarVelocidade(character)
	aplicarJumpPower(character)

	if gravidadeAtivada then
		Workspace.Gravity = gravidadeSelecionada
	else
		Workspace.Gravity = gravidadePadrao
	end
end)


-- Velocidade
AddSlider(Main, {
	Name = "Speed",
	MinValue = 16,
	MaxValue = 250,
	Default = 25,
	Increase = 1,
	Callback = function(Value)
		velocidadeValor = Value
		if velocidadeAtivada and LocalPlayer.Character then
			aplicarVelocidade(LocalPlayer.Character)
		end
	end
})

AddToggle(Main, {
	Name = "Speed",
	Default = false,
	Callback = function(Value)
		velocidadeAtivada = Value
		if LocalPlayer.Character then
			aplicarVelocidade(LocalPlayer.Character)
		end
	end
})

-- Super Jump
AddSlider(Main, {
	Name = "Super Jump",
	MinValue = 10,
	MaxValue = 900,
	Default = 40,
	Increase = 1,
	Callback = function(Value)
		jumpPowerSelecionado = Value
		if jumpAtivado and LocalPlayer.Character then
			aplicarJumpPower(LocalPlayer.Character)
		end
	end
})

AddToggle(Main, {
	Name = "Super Jump",
	Default = false,
	Callback = function(Value)
		jumpAtivado = Value
		if LocalPlayer.Character then
			aplicarJumpPower(LocalPlayer.Character)
		end
	end
})

-- Gravidade
AddSlider(Main, {
	Name = "Gravity",
	MinValue = 0,
	MaxValue = 500,
	Default = 196.2,
	Increase = 1,
	Callback = function(Value)
		gravidadeSelecionada = Value
		if gravidadeAtivada then
			Workspace.Gravity = gravidadeSelecionada
		end
	end
})

AddToggle(Main, {
	Name = "Gravity",
	Default = false,
	Callback = function(Value)
		gravidadeAtivada = Value
		Workspace.Gravity = Value and gravidadeSelecionada or gravidadePadrao
	end
})

