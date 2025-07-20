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


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espNomeAtivado = false
local espDistAtivado = false
local connections = {}

-- Cor customizável
local espCor = Color3.fromRGB(255, 0, 0)

local function criarESP(player)
    if player == LocalPlayer then return end

    task.spawn(function()
        while (espNomeAtivado or espDistAtivado) and player and player.Character do
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            lcal humanoid = char:FindFirstChild("Humanoid")

            if humanoid and humanoid.Health > 0 then
                -- ESP NOME
                if espNomeAtivado and head and not head:FindFirstChild("ESP_Name") then
                    local espNome = Instance.new("BillboardGui")
                    espNome.Name = "ESP_Name"
                    espNome.Adornee = head
                    espNome.Size = UDim2.new(0, 100, 0, 18)
                    espNome.StudsOffset = Vector3.new(0, 1.5, 0)
                    espNome.AlwaysOnTop = true

                    local texto = Instance.new("TextLabel")
                    texto.Name = "Texto"
                    texto.Size = UDim2.new(1, 0, 1, 0)
                    texto.BackgroundTransparency = 1
                    texto.TextColor3 = espCor
                    texto.TextStrokeTransparency = 0.4
                    texto.TextStrokeColor3 = Color3.new(0, 0, 0)
                    texto.Font = Enum.Font.Gotham
                    texto.TextSize = 10
                    texto.Text = player.Name
                    texto.Parent = espNome

                    espNome.Parent = head

                    humanoid.Died:Connect(function()
                        espNome:Destroy()
                    end)
                end

                -- ESP DISTÂNCIA
                if espDistAtivado and root and not root:FindFirstChild("ESP_Distancia") then
                    local espDist = Instance.new("BillboardGui")
                    espDist.Name = "ESP_Distancia"
                    espDist.Adornee = root
                    espDist.Size = UDim2.new(0, 100, 0, 18)
                    espDist.StudsOffset = Vector3.new(0, -3, 0)
                    espDist.AlwaysOnTop = true

                    local textoDist = Instance.new("TextLabel")
                    textoDist.Name = "Texto"
                    textoDist.Size = UDim2.new(1, 0, 1, 0)
                    textoDist.BackgroundTransparency = 1
                    textoDist.TextColor3 = espCor
                    textoDist.TextStrokeTransparency = 0.4
                    textoDist.TextStrokeColor3 = Color3.new(0, 0, 0)
                    textoDist.Font = Enum.Font.Gotham
                    textoDist.TextSize = 10
                    textoDist.Text = ""
                    textoDist.Parent = espDist

                    espDist.Parent = root

                    humanoid.Died:Connect(function()
                        espDist:Destroy()
                    end)
                end

                -- Atualizar texto e cor
                if root then
                    local distGui = root:FindFirstChild("ESP_Distancia")
                    if distGui and distGui:FindFirstChild("Texto") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                        local distancia = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        distGui.Texto.Text = math.floor(distancia) .. "m"
                        distGui.Texto.TextColor3 = espCor
                    end
                end
                if head then
                    local nomeGui = head:FindFirstChild("ESP_Name")
                    if nomeGui and nomeGui:FindFirstChild("Texto") then
                        nomeGui.Texto.TextColor3 = espCor
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

local function monitorarPlayer(player)
    if connections[player] then
        connections[player]:Disconnect()
    end

    connections[player] = player.CharacterAdded:Connect(function()
        task.wait(1)
        if espNomeAtivado or espDistAtivado then
            criarESP(player)
        end
    end)

    if player.Character then
        criarESP(player)
    end
end

local function limparESP()
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            if head and head:FindFirstChild("ESP_Name") then
                head.ESP_Name:Destroy()
            end
            if root and root:FindFirstChild("ESP_Distancia") then
                root.ESP_Distancia:Destroy()
            end
        end
    end
end

-- BOTÃO: ESP NOME
AddToggle(Visuais, {
    Name = "ESP Name",
    Default = false,
    Callback = function(Value)
        espNomeAtivado = Value

        if espNomeAtivado then
            for _, player in ipairs(Players:GetPlayers()) do
                monitorarPlayer(player)
            end
            if not connections["PlayerAdded"] then
                connections["PlayerAdded"] = Players.PlayerAdded:Connect(monitorarPlayer)
            end
        else
            limparESP()
        end
    end
})

-- BOTÃO: ESP DISTÂNCIA
AddToggle(Visuais, {
    Name = "ESP Distance",
    Default = false,
    Callback = function(Value)
        espDistAtivado = Value

        if espDistAtivado then
            for _, player in ipairs(Players:GetPlayers()) do
                monitorarPlayer(player)
            end
            if not connections["PlayerAdded"] then
                connections["PlayerAdded"] = Players.PlayerAdded:Connect(monitorarPlayer)
            end
        else
            limparESP()
        end
    end
})

-- COLOR
AddColorPicker(Visuais, {
    Name = "Change Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        espCor = Value
    end
})
