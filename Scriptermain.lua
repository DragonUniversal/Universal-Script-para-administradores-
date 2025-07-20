loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonUniversal/Dragon-Menu-/refs/heads/main/Library.lua"))()



MakeWindow({

    Hub = {

        Title = "Dragon Menu I Universal - v5.7",

        Animation = "by : Victorscript"

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


local fovAtivado = false
local fovValor = 70 -- valor padrão inicial
local fovPadrao = 70 -- valor para restaurar quando desativar

-- Função para aplicar o FOV
local function aplicarFov()
    local camera = workspace.CurrentCamera
    if camera then
        if fovAtivado then
            camera.FieldOfView = fovValor
        else
            camera.FieldOfView = fovPadrao
        end
    end
end

-- Atualiza FOV quando o personagem respawnar
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    aplicarFov()
end)

-- Slider para ajustar o FOV
AddSlider(Visuais, {
    Name = "Field of view",
    MinValue = 16,
    MaxValue = 120,
    Default = fovValor,
    Increase = 1,
    Callback = function(Value)
        fovValor = Value
        aplicarFov()
    end
})

-- Toggle para ativar/desativar o FOV
AddToggle(Visuais, {
    Name = "Field of view",
    Default = false,
    Callback = function(Value)
        fovAtivado = Value
        aplicarFov()
    end
})


local Players = game:GetService("Players") 
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local playerName = ""
local jogadorSelecionado = nil

-- Função para encontrar jogador
local function encontrarJogador(nome)
	local lowerName = nome:lower()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, #lowerName) == lowerName then
			return player
		end
	end
	return nil
end

-- Caixa de texto para digitar nome do jogador
AddTextBox(Player, {
	Name = "Enter player name",
	Default = "",
	Placeholder = "Nome do jogador aqui...",
	Callback = function(text)
		playerName = text
		jogadorSelecionado = encontrarJogador(playerName)
	end
})

-- Botão de teleporte
AddButton(Player, {
	Name = "Teleport",
	Callback = function()
		local jogador = encontrarJogador(playerName)
		if jogador and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
			local localChar = LocalPlayer.Character
			if localChar and localChar:FindFirstChild("HumanoidRootPart") then
				localChar.HumanoidRootPart.CFrame = jogador.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
				print("Teletransportado para " .. jogador.Name)
			else
				warn("Seu personagem não está disponível.")
			end
		else
			warn("Jogador inválido ou personagem não carregado.")
		end
	end
})


-- Botão de teleporte
AddButton(Player, {
	Name = "Teleport",
	Callback = function()
		local jogador = encontrarJogador(playerName)
		if jogador and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
			local localChar = LocalPlayer.Character
			if localChar and localChar:FindFirstChild("HumanoidRootPart") then
				localChar.HumanoidRootPart.CFrame = jogador.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
				print("Teletransportado para " .. jogador.Name)
			else
				warn("Seu personagem não está disponível.")
			end
		else
			warn("Jogador inválido ou personagem não carregado.")
		end
	end
})

local section = AddSection(Player, {"Teleport"})

-- Variável para guardar a posição salva
local savedCFrame = nil

-- Botão: Salvar posição
AddButton(Player, {
    Name = "Save position",
    Callback = function()
        print("Botão foi clicado! Salvando posição...")
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            savedCFrame = hrp.CFrame
            print("Posição salva:", tostring(savedCFrame))
        end)
    end
})

-- Botão: Teleportar para posição salva
AddButton(Player, {
    Name = "Teleport to position",
    Callback = function()
        print("Botão foi clicado! Teleportando...")
        pcall(function()
            if savedCFrame then
                local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = savedCFrame
                print("Teleportado com sucesso.")
            else
                warn("Nenhuma posição salva ainda!")
            end
        end)
    end
})

-- Botão: Copy
AddButton(Player, {
    Name = "Copy Position",
    Callback = function()
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            local code = string.format("game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(%.2f, %.2f, %.2f))", pos.X, pos.Y, pos.Z)
            setclipboard(code)
            print("Código copiado:", code)
        end
    end
})


-- Botão Rejoin
AddButton(Servidor, {
	Name = "Rejoin",
	Callback = function()
		local TeleportService = cloneref(game:GetService("TeleportService"))
		local Players = cloneref(game:GetService("Players"))
		local LocalPlayer = cloneref(Players.LocalPlayer)

		-- Reentra no mesmo lugar do Servidor
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
})


-- Serviços
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Notificação útil
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = "rbxassetid://137903795082783",
            Duration = 3
        })
    end)
end

-- Botão: Anti AFK
AddButton(Servidor, {
    Name = "Anti AFK",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
        Notify("Vitor Developer", "Anti AFK Enabled")
    end
})


-- Serviços
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Estado de ativação
local antiKickEnabled = false
local oldNamecallHook

-- Notificar apenas quando um kick for bloqueado
local function NotifyKickBlocked()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vitor Developer",
            Text = "Kick attempt blocked",
            Icon = "rbxassetid://137903795082783",
            Duration = 3
        })
    end)
end

-- Hook global
if not oldNamecallHook then
    oldNamecallHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if antiKickEnabled and typeof(method) == "string" and string.lower(method) == "kick" and self == LocalPlayer then
            NotifyKickBlocked()
            return wait(9e9)
        end
        return oldNamecallHook(self, ...)
    end))
end

-- Toggle Anti Kick
AddToggle(Servidor, {
    Name = "Anti Kick",
    Default = false,
    Callback = function(state)
        antiKickEnabled = state
    end
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local antiSeatEnabled = false
local seatedConnection = nil
local characterConnection = nil
local seatWatcher = nil
local ignoreSeats = {}

-- Impede o personagem de sentar
local function preventSitting(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	if seatedConnection then
		seatedConnection:Disconnect()
	end

	seatedConnection = humanoid.Seated:Connect(function(isSeated)
		if isSeated and antiSeatEnabled then
			humanoid.Sit = false
		end
	end)

	if humanoid.Sit then
		humanoid.Sit = false
	end
end

-- Torna todos os assentos não interativos
local function disableSeatTouch()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
			if not ignoreSeats[obj] then
				ignoreSeats[obj] = obj.CanTouch
				obj.CanTouch = false
			end
		end
	end
end

-- Restaura os assentos
local function restoreSeats()
	for seat, original in pairs(ignoreSeats) do
		if seat and seat:IsDescendantOf(workspace) then
			seat.CanTouch = original
		end
	end
	ignoreSeats = {}
end

-- Observa novos assentos adicionados
local function watchNewSeats()
	if seatWatcher then seatWatcher:Disconnect() end
	seatWatcher = workspace.DescendantAdded:Connect(function(desc)
		if antiSeatEnabled and (desc:IsA("Seat") or desc:IsA("VehicleSeat")) then
			task.wait(0.1)
			if desc:IsDescendantOf(workspace) then
				ignoreSeats[desc] = desc.CanTouch
				desc.CanTouch = false
			end
		end
	end)
end

-- Toggle Anti Sit
AddToggle(Servidor, {
	Name = "Anti Sit",
	Default = false,
	Callback = function(Value)
		antiSeatEnabled = Value

		if Value then
			if LocalPlayer.Character then
				preventSitting(LocalPlayer.Character)
			end

			if characterConnection then
				characterConnection:Disconnect()
			end
			characterConnection = LocalPlayer.CharacterAdded:Connect(preventSitting)

			disableSeatTouch()
			watchNewSeats()
		else
			if seatedConnection then
				seatedConnection:Disconnect()
				seatedConnection = nil
			end
			if characterConnection then
				characterConnection:Disconnect()
				characterConnection = nil
			end
			if seatWatcher then
				seatWatcher:Disconnect()
				seatWatcher = nil
			end

			restoreSeats()
		end
	end
})


AddButton(Config, {
    Name = "FPS Boost",
    Callback = function()
        print("Botão foi clicado!")

        pcall(function()
            -- Otimiza todas as partes para reduzir o impacto gráfico
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    v.Material = Enum.Material.SmoothPlastic -- Remove texturas complexas
                    v.Reflectance = 0 -- Remove reflexos
                    v.CastShadow = false -- Desativa sombras
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1 -- Oculta texturas e decals
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    v:Destroy() -- Remove efeitos que consomem desempenho
                end
            end

            -- Ajusta configurações para melhorar o FPS
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 -- Reduz qualidade gráfica
                workspace.GlobalShadows = false -- Remove sombras globais

                if game:FindFirstChild("Lighting") then
                    local lighting = game.Lighting
                    lighting.FogEnd = 1e10 -- Remove neblina
                    lighting.GlobalShadows = false
                    lighting.Brightness = 2
                end
            end)
        end)
    end
})


AddToggle(Config, {
    Name = "FPS",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer

        local connection

        local function createFPSCounter()
            local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")

            -- Remover contador existente para evitar duplicações
            local existingGui = playerGui:FindFirstChild("FPSCounter")
            if existingGui then
                existingGui:Destroy()
            end

            -- Criar novo ScreenGui
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "FPSCounter"
            screenGui.ResetOnSpawn = false
            screenGui.Parent = playerGui

            -- Criar FPS Label
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(0, 80, 0, 25)
            fpsLabel.Position = UDim2.new(1, -290, 0, 1)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fpsLabel.TextSize = 14
            fpsLabel.Font = Enum.Font.Code
            fpsLabel.Text = "FPS: 0"
            fpsLabel.Parent = screenGui
            fpsLabel.Active = true
            fpsLabel.Draggable = true
            fpsLabel.TextStrokeTransparency = 0.6
            fpsLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

            -- FPS Calculation
            local lastTime = tick()
            local frameCount = 0

            connection = RunService.RenderStepped:Connect(function()
                frameCount = frameCount + 1
                local currentTime = tick()
                if currentTime - lastTime >= 1 then
                    fpsLabel.Text = "FPS: " .. frameCount
                    frameCount = 0
                    lastTime = currentTime
                end
            end)

            -- Atualizar após respawn
            player.CharacterAdded:Connect(function()
                task.wait(1)
                createFPSCounter()
            end)
        end

        if Value then
            createFPSCounter()
        else
            -- Remover GUI e desconectar a atualização
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                local existingGui = playerGui:FindFirstChild("FPSCounter")
                if existingGui then
                    existingGui:Destroy()
                end
            end
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})


local Lighting = game:GetService("Lighting")  

-- Armazena configurações originais
local originalSettings = {
	Brightness = Lighting.Brightness,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows
}

local fullBrightEnabled = false
local connections = {}

-- Ativa o modo manhã com iluminação suave
local function enableMorningLight()
	fullBrightEnabled = true

	Lighting.Brightness = 1.5
	Lighting.Ambient = Color3.fromRGB(180, 180, 160) -- tom suave
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 170)
	Lighting.ClockTime = 7 -- manhã cedo
	Lighting.FogEnd = 1e9
	Lighting.GlobalShadows = true

	-- Protege propriedades de alterações externas
	table.insert(connections, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
		if fullBrightEnabled then Lighting.ClockTime = 7 end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
		if fullBrightEnabled then Lighting.Ambient = Color3.fromRGB(180, 180, 160) end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
		if fullBrightEnabled then Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 170) end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
		if fullBrightEnabled then Lighting.Brightness = 1.5 end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
		if fullBrightEnabled then Lighting.GlobalShadows = true end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
		if fullBrightEnabled then Lighting.FogEnd = 1e9 end
	end))

	print("Lighting ativado.")
end

-- Restaura os valores originais
local function disableMorningLight()
	fullBrightEnabled = false

	for _, conn in ipairs(connections) do
		if conn.Disconnect then
			conn:Disconnect()
		end
	end
	connections = {}

	for prop, value in pairs(originalSettings) do
		Lighting[prop] = value
	end

	print("Lighting desativardo.")
end

-- Toggle de iluminação
AddToggle(Config, {
	Name = "Lighting",
	Default = false,
	Callback = function(state) 
		if state then 
			enableMorningLight()
		else
			disableMorningLight()
		end
	end
})


local Players = game:GetService("Players")

local StarterGui = game:GetService("StarterGui")

local notificacaoAtivada = false

-- Função para exibir notificações
local function notify(title, text)
    if notificacaoAtivada then
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end
end

-- Notifica quando um jogador entra no jogo
Players.PlayerAdded:Connect(function(player)
    notify(player.Name, "entered the game,")
end)

-- Notifica quando um jogador sai do jogo
Players.PlayerRemoving:Connect(function(player)
    notify(player.Name, "left the game.")
end)

-- Toggle para ativar/desativar notificações (sem aviso ao ativar)
AddToggle(Config, {
    Name = "Player Notifications",
    Default = false,
    Callback = function(Value)
        notificacaoAtivada = Value
    end
})

