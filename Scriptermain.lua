loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Dragon-Menu-/refs/heads/main/Library.lua"))()



MakeWindow({

    Hub = {

        Title = "Dragon Menu I Universal - v5.7",

        Animation = "by Administrators"

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
local RunService = game:GetService("RunService")

-- Variáveis principais
local velocidadeAtivada = false
local velocidadeValor = 25

local jumpAtivado = false
local jumpPowerSelecionado = 40
local jumpPowerPadrao = 50

local gravidadeAtivada = false
local gravidadeSelecionada = 196.2
local gravidadePadrao = 196.2

-- Atualiza
local function aplicarAtributos()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:WaitForChild("Humanoid", 3)
    if humanoid then
        -- Speed
        if velocidadeAtivada then
            humanoid.WalkSpeed = velocidadeValor
        else
            humanoid.WalkSpeed = 16
        end

        -- Jump
        humanoid.UseJumpPower = true
        if jumpAtivado then
            humanoid.JumpPower = jumpPowerSelecionado
        else
            humanoid.JumpPower = jumpPowerPadrao
        end
    end

    -- Gravity
    if gravidadeAtivada then
        workspace.Gravity = gravidadeSelecionada
    else
        workspace.Gravity = gravidadePadrao
    end
end

-- Executa ao spawnar
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    aplicarAtributos()
end)

-- SPEED
AddSlider(Main, {
    Name = "Speed",
    MinValue = 16,
    MaxValue = 250,
    Default = 25,
    Increase = 1,
    Callback = function(Value)
        velocidadeValor = Value
        if velocidadeAtivada and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = velocidadeValor
            end
        end
    end
})

AddToggle(Main, {
    Name = "Speed",
    Default = false,
    Callback = function(Value)
        velocidadeAtivada = Value
        aplicarAtributos()
    end
})

-- SUPER JUMP
AddSlider(Main, {
    Name = "Super Jump",
    MinValue = 10,
    MaxValue = 900,
    Default = 40,
    Increase = 1,
    Callback = function(Value)
        jumpPowerSelecionado = Value
        if jumpAtivado then
            aplicarAtributos()
        end
    end
})

AddToggle(Main, {
    Name = "Super Jump",
    Default = false,
    Callback = function(Value)
        jumpAtivado = Value
        aplicarAtributos()
    end
})

-- GRAVITY
AddSlider(Main, {
    Name = "Gravity",
    MinValue = 0,
    MaxValue = 500,
    Default = 196.2,
    Increase = 1,
    Callback = function(Value)
        gravidadeSelecionada = Value
        if gravidadeAtivada then
            workspace.Gravity = gravidadeSelecionada
        end
    end
})

AddToggle(Main, {
    Name = "Gravity",
    Default = false,
    Callback = function(Value)
        gravidadeAtivada = Value
        aplicarAtributos()
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

-- Variável global para controlar o estado do ESP
local espAtivado = false

-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Função para aplicar o Highlight
local function aplicarHighlight(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if character and not character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- Cor branca
        highlight.FillTransparency = 1 -- Centro totalmente transparente
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Cor branca
        highlight.OutlineTransparency = 0 -- Contorno totalmente opaco
        highlight.Parent = character
    end
end

-- Função para remover o Highlight
local function removerHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Loop de atualização contínua
RunService.RenderStepped:Connect(function()
    if espAtivado then
        for _, player in ipairs(Players:GetPlayers()) do
            aplicarHighlight(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            removerHighlight(player)
        end
    end
end)

-- Monitorar novos jogadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espAtivado then
            aplicarHighlight(player)
        end
    end)
end)

-- Toggle para ativar/desativar o ESP
AddToggle(Visuais, {
    Name = "ESP Box",
    Default = false,
    Callback = function(Value)
        espAtivado = Value
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local linhas = {}
local espConnections = {}
local espLinhaAtivado = false
local corVermelha = Color3.fromRGB(255, 0, 0)

local function criarLinha(player)
    if player == LocalPlayer then return end

    if linhas[player] then
        linhas[player]:Remove()
        linhas[player] = nil
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end

    local linha = Drawing.new("Line")
    linha.Thickness = 2
    linha.Transparency = 1
    linha.Visible = false
    linha.Color = corVermelha
    linhas[player] = linha

    espConnections[player] = RunService.RenderStepped:Connect(function()
        if not espLinhaAtivado then
            linha.Visible = false
            return
        end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then
            linha.Visible = false
            return
        end

        local cam = workspace.CurrentCamera
        local screenSize = cam.ViewportSize
        local headPos, onScreen = cam:WorldToViewportPoint(head.Position)

        if onScreen then
            linha.From = Vector2.new(screenSize.X / 2, 0)
            linha.To = Vector2.new(headPos.X, headPos.Y)
            linha.Visible = true
        else
            linha.Visible = false
        end
    end)

    player.CharacterAdded:Connect(function()
        wait(1)
        if espLinhaAtivado then
            criarLinha(player)
        end
    end)
end

function ativarESP()
    for _, p in ipairs(Players:GetPlayers()) do
        criarLinha(p)
    end
    espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
        wait(1)
        criarLinha(p)
    end)
end

function desativarESP()
    for _, linha in pairs(linhas) do
        if linha then linha:Remove() end
    end
    linhas = {}
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
end

AddToggle(Visuais, {
    Name = "ESP Line",
    Default = false,
    Callback = function(Value)
        espLinhaAtivado = Value
        if espLinhaAtivado then
            ativarESP()
        else
            desativarESP()
        end
    end
})
