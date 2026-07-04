3.fromRGB(255, 150, 0) or Color3.fromRGB(100, 100, 100)
end)

BtnToggleRadar.MouseButton1Click:Connect(function()
	AlertaRadarActiva = not AlertaRadarActiva
	BtnToggleRadar.Text = "ALERTA PROXIMIDAD: " .. (AlertaRadarActiva and "SI" or "NO")
	BtnToggleRadar.TextColor3 = AlertaRadarActiva and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(100, 100, 100)
end)

BtnToggleAuto.MouseButton1Click:Connect(function()
	AutoAtaqueActivo = not AutoAtaqueActivo
	BtnToggleAuto.Text = "[BETA] AUTO-ATAQUE: " .. (AutoAtaqueActivo and "SI" or "NO")
	BtnToggleAuto.TextColor3 = AutoAtaqueActivo and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 100, 100)
end)

local function CrearNotificacion(msg)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0, 220, 0, 35)
	notif.Position = UDim2.new(1, 20, 0.8, 0)
	notif.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
	notif.BorderColor3 = Color3.fromRGB(255, 0, 50)
	notif.BorderSizePixel = 1
	notif.Text = "ALERT: " .. msg
	notif.TextColor3 = Color3.fromRGB(255, 50, 50)
	notif.Font = Enum.Font.RobotoMono
	notif.TextSize = 10
	notif.Parent = ScreenGui
	TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -240, 0.8, 0)}):Play()
	task.wait(2.5)
	if notif then
		TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.8, 0)}):Play()
		task.wait(0.4)
		notif:Destroy()
	end
end

local function CrearBloqueAvatar(parte, tamano, color, esCara)
	local adornment = Instance.new("BoxHandleAdornment")
	adornment.Name = "ClassicWireframe"
	adornment.Size = tamano
	adornment.Color3 = color
	adornment.AlwaysOnTop = true
	adornment.ZIndex = esCara and 12 or 10
	adornment.Transparency = esCara and 0.1 or 0.35
	adornment.Adornee = parte
	adornment.Parent = parte
	return adornment
end

local function CrearLineaFOV(parte, cfOffset, longitud)
	local adornment = Instance.new("CylinderHandleAdornment")
	adornment.Name = "ClassicFOVLine"
	adornment.Radius = 0.04
	adornment.Height = longitud
	adornment.Color3 = Color3.fromRGB(0, 255, 255)
	adornment.AlwaysOnTop = true
	adornment.ZIndex = 9
	adornment.Transparency = 0.5
	adornment.CFrame = cfOffset * CFrame.new(0, 0, -longitud/2)
	adornment.Adornee = parte
	adornment.Parent = parte
	return adornment
end

local function EscanearEnemigoPalitos(char, enemigo)
	if not char:FindFirstChild("AlonixzClassicEsqueleto") then
		local esqFolder = Instance.new("Folder")
		esqFolder.Name = "AlonixzClassicEsqueleto"
		esqFolder.Parent = char
		
		local faceColor = Color3.fromRGB(0, 255, 255)
		
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				if part.Name == "Head" then
					CrearBloqueAvatar(part, Vector3.new(1.2, 1.2, 1.2), ColorVisualizador, false)
					local cara = CrearBloqueAvatar(part, Vector3.new(1.25, 0.4, 0.4), faceColor, true)
					cara.CFrame = CFrame.new(0, 0, -0.5)
					
					CrearLineaFOV(part, CFrame.Angles(0, math.rad(40), 0), 16)
					CrearLineaFOV(part, CFrame.Angles(0, math.rad(-40), 0), 16)
				elseif string.find(part.Name, "Torso") or part.Name == "UpperTorso" or part.Name == "LowerTorso" then
					CrearBloqueAvatar(part, Vector3.new(2.1, 2.1, 1.1), ColorVisualizador, false)
				elseif string.find(part.Name, "Arm") or string.find(part.Name, "Hand") then
					CrearBloqueAvatar(part, Vector3.new(1.02, 2.02, 1.02), ColorVisualizador, false)
				elseif string.find(part.Name, "Leg") or string.find(part.Name, "Foot") then
					CrearBloqueAvatar(part, Vector3.new(1.02, 2.02, 1.02), ColorVisualizador, false)
				end
			end
		end
		
		local head = char:FindFirstChild("Head")
		if head then
			local bGui = Instance.new("BillboardGui")
			bGui.Name = "EtiquetaClasica"
			bGui.Size = UDim2.new(0, 200, 0, 30)
			bGui.AlwaysOnTop = true
			bGui.MaxDistance = 500
			bGui.StudsOffset = Vector3.new(0, 3.5, 0)
			bGui.Adornee = head
			
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, 0, 1, 0)
			Frame.BackgroundTransparency = 1
			Frame.Parent = bGui
			
			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = string.upper(enemigo.Name)
			TextLabel.TextColor3 = ColorVisualizador
			TextLabel.Font = Enum.Font.RobotoMono
			TextLabel.TextSize = 11
			TextLabel.Parent = Frame
			
			bGui.Parent = esqFolder
		end
	else
		for _, item in ipairs(char.AlonixzClassicEsqueleto:GetDescendants()) do
			if item:IsA("BoxHandleAdornment") and item.ZIndex == 10 then
				item.Color3 = ColorVisualizador
			elseif item:IsA("TextLabel") then
				item.TextColor3 = ColorVisualizador
			end
		end
	end
	
	local head = char:FindFirstChild("Head")
	if head then
		for _, item in ipairs(char.AlonixzClassicEsqueleto:GetDescendants()) do
			if item.Name == "ClassicFOVLine" then
				item.Transparency = MostrarFOVActivo and 0.5 or 1
			end
		end
		
		local lineaDistFolder = char.AlonixzClassicEsqueleto:FindFirstChild("LineaDistanciaFolder")
		if not lineaDistFolder then
			lineaDistFolder = Instance.new("Folder")
			lineaDistFolder.Name = "LineaDistanciaFolder"
			lineaDistFolder.Parent = char.AlonixzClassicEsqueleto
		end
		
		lineaDistFolder:ClearAllChildren()
		
		if MostrarDistActiva and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local p1 = LocalPlayer.Character.HumanoidRootPart.Position
			local p2 = head.Position
			local ray = (p2 - p1)
			local dist = math.floor(ray.Magnitude)
			
			local numPuntos = math.floor(dist / 3)
			for i = 1, numPuntos do
				local pos = p1 + (ray.Unit * (i * 3))
				local pPart = Instance.new("Part")
				pPart.Size = Vector3.new(0.2, 0.2, 0.2)
				pPart.CFrame = CFrame.new(pos)
				pPart.Anchored = true
				pPart.CanCollide = false
				pPart.Transparency = 1
				pPart.Parent = lineaDistFolder
				
				local adorn = Instance.new("BoxHandleAdornment")
				adorn.Size = Vector3.new(0.15, 0.15, 0.4)
				adorn.Color3 = ColorVisualizador
				adorn.AlwaysOnTop = true
				adorn.Transparency = 0.3
				adorn.ZIndex = 8
				adorn.Adornee = pPart
				adorn.CFrame = CFrame.lookAt(pos, p2)
				adorn.Parent = pPart
			end
			
			local bGuiD = Instance.new("BillboardGui")
			bGuiD.Name = "TagDist"
			bGuiD.Size = UDim2.new(0, 80, 0, 20)
			bGuiD.AlwaysOnTop = true
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = tostring(dist) .. " STUDS"
			lbl.TextColor3 = ColorVisualizador
			lbl.Font = Enum.Font.RobotoMono
			lbl.TextSize = 10
			lbl.Parent = bGuiD
			
			local pMid = Instance.new("Part")
			pMid.Size = Vector3.new(0.1, 0.1, 0.1)
			pMid.CFrame = CFrame.new(p1 + (ray / 2))
			pMid.Anchored = true
			pMid.CanCollide = false
			pMid.Transparency = 1
			pMid.Parent = lineaDistFolder
			
			bGuiD.Adornee = pMid
			bGuiD.Parent = lineaDistFolder
		end
	end
end

local function LimpiarEscaneo()
	for _, enemigo in ipairs(Players:GetPlayers()) do
		if enemigo.Character then
			local esq = enemigo.Character:FindFirstChild("AlonixzClassicEsqueleto")
			if esq then esq:Destroy() end
		end
	end
end

local UltimoAviso = 0
RunService.RenderStepped:Connect(function()
	pcall(function()
		local myChar = LocalPlayer.Character
		if myChar then
			for _, v in ipairs(myChar:GetDescendants()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
					v.CanCollide = false
				end
			end
		end
	end)

	if EscanerActivo then
		local objetivoCercano = nil
		local distanciaMinima = 25
		
		pcall(function()
			local miRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			
			for _, enemigo in ipairs(Players:GetPlayers()) do
				if enemigo ~= LocalPlayer and enemigo.Character then
					EscanearEnemigoPalitos(enemigo.Character, enemigo)
					
					local enemigoRoot = enemigo.Character:FindFirstChild("HumanoidRootPart")
					
					if not enemigoRoot then
						local esq = enemigo.Character:FindFirstChild("AlonixzClassicEsqueleto")
						if esq then
							local box = esq:FindFirstChildOfClass("BoxHandleAdornment")
							if box and box.Adornee then
								enemigoRoot = box.Adornee
							end
						end
					end
					
					if miRoot and enemigoRoot then
						local dist = (enemigoRoot.Position - miRoot.Position).Magnitude
						if dist < distanciaMinima then
							distanciaMinima = dist
							objetivoCercano = enemigoRoot
							
							if AlertaRadarActiva and (tick() - UltimoAviso > 5) then
								UltimoAviso = tick()
								task.spawn(CrearNotificacion, "SILUETA DETECTADA: " .. enemigo.Name:upper())
							end
						end
					end
				end
			end
			
			if AutoAtaqueActivo and objetivoCercano and LocalPlayer.Character then
				local miRoot2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if miRoot2 then
					miRoot2.CFrame = CFrame.lookAt(miRoot2.Position, Vector3.new(objetivoCercano.Position.X, miRoot2.Position.Y, objectiveCercano.Position.Z))
				end
				
				local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if not t and LocalPlayer:FindFirstChild("Backpack") then
					local firstItem = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
					if firstItem and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
						LocalPlayer.Character.Humanoid:EquipTool(firstItem)
						t = firstItem
					end
				end
				if t then t:Activate() end
			end
		end)
	else
		LimpiarEscaneo()
	end
end)

task.spawn(function()
	while true do
		task.wait(60)
		if EscanerActivo then
			LimpiarEscaneo()
		end
	end
end)

BtnVision.MouseButton1Click:Connect(function()
	EscanerActivo = not EscanerActivo
	if EscanerActivo then
		BtnVision.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
		BtnVision.TextColor3 = Color3.fromRGB(10, 16, 16)
		BtnVision.Text = "SISTEMA: ENCENDIDO"
	else
		BtnVision.BackgroundColor3 = Color3.fromRGB(15, 25, 25)
		BtnVision.TextColor3 = Color3.fromRGB(0, 255, 150)
		BtnVision.Text = "SISTEMA: APAGADO"
		LimpiarEscaneo()
	end
end)
-- =============================================================================
-- ALONSHACK // SILENT KILLER HUD v4.0 PRO (FULL PRODUCTION CODE)
-- =============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [ESTADOS Y CONFIGURACIÓN CENTRAL]
local Settings = {
    EscanerActivo = false,
    TargetMode = "OFF", -- "OFF", "FOLLOW" (Mirar y Perseguir), "COMBAT" (Mirar y Atacar a 4 studs)
    DashDist = 8,
    UltimoObjetivoNotificado = "",
    Colors = {
        Hitbox = Color3.fromRGB(0, 255, 150),
        Distancia = Color3.fromRGB(255, 150, 0),
        Etiquetas = Color3.fromRGB(255, 255, 255)
    }
}

-- [CONTENEDOR PRINCIPAL DE LA INTERFAZ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AlonshackCore_v4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- [SISTEMA DE NOTIFICACIONES VISUALES]
local function EnviarNotificacion(titulo, mensaje, colorBorde)
    colorBorde = colorBorde or Color3.fromRGB(0, 255, 150)
    
    local FrameNotif = Instance.new("Frame")
    FrameNotif.Size = UDim2.new(0, 280, 0, 65)
    FrameNotif.Position = UDim2.new(1, 20, 0.85, 0) -- Inicia fuera de la pantalla (Derecha)
    FrameNotif.BackgroundColor3 = Color3.fromRGB(10, 12, 12)
    FrameNotif.BorderColor3 = colorBorde
    FrameNotif.BorderSizePixel = 2
    FrameNotif.Parent = ScreenGui

    local CornerN = Instance.new("UICorner")
    CornerN.CornerRadius = UDim.new(0, 6)
    CornerN.Parent = FrameNotif

    local TextoNotif = Instance.new("TextLabel")
    TextoNotif.Size = UDim2.new(0.9, 0, 0.9, 0)
    TextoNotif.Position = UDim2.new(0.05, 0, 0.05, 0)
    TextoNotif.BackgroundTransparency = 1
    TextoNotif.Text = "[" .. titulo .. "]\n" .. mensaje
    TextoNotif.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextoNotif.Font = Enum.Font.RobotoMono
    TextoNotif.TextSize = 12
    TextoNotif.TextXAlignment = Enum.TextXAlignment.Left
    TextoNotif.Parent = FrameNotif

    -- Animación de entrada
    TweenService:Create(FrameNotif, TweenInfo.new(0.4, Enum.EasingStyle.QuadOut), {Position = UDim2.new(1, -300, 0.85, 0)}):Play()
    
    task.spawn(function()
        task.wait(3.5)
        -- Animación de salida
        local tOut = TweenService:Create(FrameNotif, TweenInfo.new(0.4, Enum.EasingStyle.QuadIn), {Position = UDim2.new(1, 20, 0.85, 0)})
        tOut:Play()
        tOut.Completed:Connect(function()
            FrameNotif:Destroy()
        end)
    end)
end

-- [BOTÓN DE MINIMIZADO ESTILIZADO "A"]
-- Corregido: Se posiciona en el centro izquierdo de la pantalla para evitar colisiones con el header/créditos
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 55, 0, 55)
MiniBtn.Position = UDim2.new(0.02, 0, 0.45, 0) 
MiniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MiniBtn.BorderColor3 = Color3.fromRGB(0, 255, 150)
MiniBtn.BorderSizePixel = 2
MiniBtn.Text = "A"
MiniBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
MiniBtn.Font = Enum.Font.SpecialElite
MiniBtn.TextSize = 28
MiniBtn.Visible = false
MiniBtn.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 10)
MiniCorner.Parent = MiniBtn

-- [BOTÓN FLOTANTE: DASH (ESQUIVE)]
local DashBtn = Instance.new("TextButton")
DashBtn.Size = UDim2.new(0, 75, 0, 75)
DashBtn.Position = UDim2.new(0.85, 0, 0.7, 0) -- Ubicación óptima para pulgar en móviles
DashBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 25)
DashBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
DashBtn.BorderSizePixel = 2
DashBtn.Text = "DASH"
DashBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
DashBtn.Font = Enum.Font.RobotoMono
DashBtn.TextSize = 16
DashBtn.Parent = ScreenGui

local DashCorner = Instance.new("UICorner")
DashCorner.CornerRadius = UDim.new(1, 0) -- Botón circular estilo nativo móvil
DashCorner.Parent = DashBtn

-- [INTERFAZ PRINCIPAL (DASHBOARD)]
local MainDashboard = Instance.new("Frame")
MainDashboard.Size = UDim2.new(0.94, 0, 0.9, 0)
MainDashboard.Position = UDim2.new(0.03, 0, 0.05, 0)
MainDashboard.BackgroundColor3 = Color3.fromRGB(8, 10, 10)
MainDashboard.BackgroundTransparency = 0.1
MainDashboard.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainDashboard.BorderSizePixel = 2
MainDashboard.Parent = ScreenGui

local DashCornerMain = Instance.new("UICorner")
DashCornerMain.CornerRadius = UDim.new(0, 12)
DashCornerMain.Parent = MainDashboard

-- Encabezado de la interfaz
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(14, 18, 18)
Header.BorderSizePixel = 0
Header.Parent = MainDashboard

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ALONSHACK V4 // CONTROL DE EJECUCIÓN"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -50, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Font = Enum.Font.RobotoMono
CloseBtn.TextSize = 20
CloseBtn.Parent = Header

-- Créditos fijos en la zona inferior
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 0, 25)
CreditsLabel.Position = UDim2.new(0, 0, 1, -25)
CreditsLabel.BackgroundColor3 = Color3.fromRGB(12, 14, 14)
CreditsLabel.Text = "DEVELOPED BY ALONIXZ-GROUP // DESIGN SYSTEM CORE"
CreditsLabel.TextColor3 = Color3.fromRGB(100, 120, 120)
CreditsLabel.Font = Enum.Font.Code
CreditsLabel.TextSize = 10
CreditsLabel.Parent = MainDashboard

-- Paneles contenedores (Grid de Dos Columnas)
local LeftContainer = Instance.new("ScrollingFrame")
LeftContainer.Size = UDim2.new(0.48, 0, 0.8, -10)
LeftContainer.Position = UDim2.new(0.01, 0, 0.12, 0)
LeftContainer.BackgroundTransparency = 1
LeftContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
LeftContainer.ScrollBarThickness = 4
LeftContainer.Parent = MainDashboard

local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0.48, 0, 0.8, -10)
RightContainer.Position = UDim2.new(0.51, 0, 0.12, 0)
RightContainer.BackgroundColor3 = Color3.fromRGB(12, 15, 15)
RightContainer.BorderColor3 = Color3.fromRGB(0, 255, 150)
RightContainer.Parent = MainDashboard

local DiagnosticText = Instance.new("TextLabel")
DiagnosticText.Size = UDim2.new(0.94, 0, 0.94, 0)
DiagnosticText.Position = UDim2.new(0.03, 0, 0.03, 0)
DiagnosticText.BackgroundTransparency = 1
DiagnosticText.Text = "ESTADO DE LOS MÓDULOS:\n\n" ..
    "[-] AUTOMÁTICO DE REFRESCADO LABELS: ACTIVO (1 MIN)\n" ..
    "[-] RANGO DE ESCANEO DE ENTIDADES: ILIMITADO\n" ..
    "[-] DISTANCIA DE COMBATE EXIGIDA: 4 STUDS\n" ..
    "[-] VECTOR LOCK DE MIRADA: ENLAZADO\n\n" ..
    "Sugerencia: Abre la paleta de colores interna para personalizar el contraste de las hitboxes y etiquetas sobre el entorno."
DiagnosticText.TextColor3 = Color3.fromRGB(0, 200, 255)
DiagnosticText.Font = Enum.Font.RobotoMono
DiagnosticText.TextSize = 11
DiagnosticText.TextXAlignment = Enum.TextXAlignment.Left
DiagnosticText.TextYAlignment = Enum.TextYAlignment.Top
DiagnosticText.TextWrapped = true
DiagnosticText.Parent = RightContainer

-- [SUBPANEL INTERNO EXTRA: PALETA DE COLORES INDEPENDIENTES]
local ColorPanel = Instance.new("Frame")
ColorPanel.Size = UDim2.new(0, 260, 0, 220)
ColorPanel.Position = UDim2.new(0.5, -130, 0.5, -110)
ColorPanel.BackgroundColor3 = Color3.fromRGB(16, 20, 20)
ColorPanel.BorderColor3 = Color3.fromRGB(0, 255, 150)
ColorPanel.BorderSizePixel = 2
ColorPanel.Visible = false
ColorPanel.ZIndex = 15
ColorPanel.Parent = MainDashboard

local ColorPanelTitle = Instance.new("TextLabel")
ColorPanelTitle.Size = UDim2.new(1, 0, 0, 35)
ColorPanelTitle.BackgroundColor3 = Color3.fromRGB(22, 28, 28)
ColorPanelTitle.Text = " SELECCIÓN DE COLORES"
ColorPanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPanelTitle.Font = Enum.Font.RobotoMono
ColorPanelTitle.TextSize = 12
ColorPanelTitle.ZIndex = 15
ColorPanelTitle.Parent = ColorPanel

local ColorPanelClose = Instance.new("TextButton")
ColorPanelClose.Size = UDim2.new(0, 35, 0, 35)
ColorPanelClose.Position = UDim2.new(1, -35, 0, 0)
ColorPanelClose.BackgroundTransparency = 1
ColorPanelClose.Text = "✕"
ColorPanelClose.TextColor3 = Color3.fromRGB(255, 100, 100)
ColorPanelClose.Font = Enum.Font.RobotoMono
ColorPanelClose.TextSize = 14
ColorPanelClose.ZIndex = 16
ColorPanelClose.Parent = ColorPanel

-- Función auxiliar para inyectar selectores dentro del Subpanel de Colores
local function CrearFilaColor(texto, yPos, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 0, 30)
    lbl.Position = UDim2.new(0.05, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.RobotoMono
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 15
    lbl.Parent = ColorPanel

    local btnVerde = Instance.new("TextButton")
    btnVerde.Size = UDim2.new(0, 30, 0, 25)
    btnVerde.Position = UDim2.new(0.5, 0, 0, yPos)
    btnVerde.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    btnVerde.Text = ""
    btnVerde.ZIndex = 15
    btnVerde.Parent = ColorPanel

    local btnAzul = Instance.new("TextButton")
    btnAzul.Size = UDim2.new(0, 30, 0, 25)
    btnAzul.Position = UDim2.new(0.5, 35, 0, yPos)
    btnAzul.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    btnAzul.Text = ""
    btnAzul.ZIndex = 15
    btnAzul.Parent = ColorPanel

    local btnRojo = Instance.new("TextButton")
    btnRojo.Size = UDim2.new(0, 30, 0, 25)
    btnRojo.Position = UDim2.new(0.5, 70, 0, yPos)
    btnRojo.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btnRojo.Text = ""
    btnRojo.ZIndex = 15
    btnRojo.Parent = ColorPanel

    btnVerde.MouseButton1Click:Connect(function() callback(Color3.fromRGB(0, 255, 150)) end)
    btnAzul.MouseButton1Click:Connect(function() callback(Color3.fromRGB(0, 200, 255)) end)
    btnRojo.MouseButton1Click:Connect(function() callback(Color3.fromRGB(255, 50, 50)) end)
end

CrearFilaColor("HITBOXES:", 50, function(c) Settings.Colors.Hitbox = c EnviarNotificacion("COLOR", "Hitboxes actualizadas.", c) end)
CrearFilaColor("DISTANCIA:", 95, function(c) Settings.Colors.Distancia = c EnviarNotificacion("COLOR", "Líneas de distancia actualizadas.", c) end)
CrearFilaColor("ETIQUETAS:", 140, function(c) Settings.Colors.Etiquetas = c EnviarNotificacion("COLOR", "Diseño de etiquetas actualizado.", c) end)

ColorPanelClose.MouseButton1Click:Connect(function() ColorPanel.Visible = false end)

-- [GENERADOR DE BOTONES INTERACTIVOS (CSS ASINCRONO STYLE)]
local function InsertarBotonMenu(texto, index, colorBorde)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.96, 0, 0, 42)
    Btn.Position = UDim2.new(0.02, 0, 0, (index - 1) * 50)
    Btn.BackgroundColor3 = Color3.fromRGB(12, 16, 16)
    Btn.BorderColor3 = colorBorde
    Btn.BorderSizePixel = 1
    Btn.Text = "  " .. texto
    Btn.TextColor3 = colorBorde
    Btn.Font = Enum.Font.RobotoMono
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = LeftContainer

    local CornerB = Instance.new("UICorner")
    CornerB.CornerRadius = UDim.new(0, 4)
    CornerB.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 26, 26)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12, 16, 16)}):Play()
    end)

    return Btn
end

local BtnEscaner = InsertarBotonMenu("SISTEMA GENERAL: APAGADO", 1, Color3.fromRGB(0, 255, 150))
local BtnModoAtaque = InsertarBotonMenu("MODO COMBATE/SEGUIMIENTO: OFF", 2, Color3.fromRGB(255, 200, 0))
-- Nuevo: Abre el subpanel interno de configuración cromática
local BtnColorConfig = InsertarBotonMenu("CONFIGURAR COLORES SECCIÓN", 3, Color3.fromRGB(255, 255, 255))

-- [MANIPULACIÓN DE MINIMIZADO CON ANIMACIONES DE INTERFAZ]
local MenuAbierto = true

local function DesplegarHUD()
    MiniBtn.Visible = false
    MainDashboard.Visible = true
    TweenService:Create(MainDashboard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.03, 0, 0.05, 0)}):Play()
    MenuAbierto = true
end

local function ColapsarHUD()
    local Anim = TweenService:Create(MainDashboard, TweenInfo.new(0.4, Enum.EasingStyle.QuadIn), {Position = UDim2.new(0.03, 0, -1, 0)})
    Anim:Play()
    MenuAbierto = false
    Anim.Completed:Connect(function()
        if not MenuAbierto then
            MainDashboard.Visible = false
            MiniBtn.Visible = true
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(ColapsarHUD)
MiniBtn.MouseButton1Click:Connect(DesplegarHUD)
BtnColorConfig.MouseButton1Click:Connect(function() ColorPanel.Visible = not ColorPanel.Visible end)

-- Alternar el interruptor del escáner visual básico
BtnEscaner.MouseButton1Click:Connect(function()
    Settings.EscanerActivo = not Settings.EscanerActivo
    if Settings.EscanerActivo then
        BtnEscaner.Text = "  SISTEMA GENERAL: ENCENDIDO"
        BtnEscaner.TextColor3 = Color3.fromRGB(10, 10, 10)
        BtnEscaner.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        EnviarNotificacion("CORE", "Rastreador de servidores inicializado.")
    else
        BtnEscaner.Text = "  SISTEMA GENERAL: APAGADO"
        BtnEscaner.TextColor3 = Color3.fromRGB(0, 255, 150)
        BtnEscaner.BackgroundColor3 = Color3.fromRGB(12, 16, 16)
        EnviarNotificacion("CORE", "Rastreador en reposo.")
    end
end)

-- Máquina de estados cíclica para los modos combinados de tracking/hit
BtnModoAtaque.MouseButton1Click:Connect(function()
    if Settings.TargetMode == "OFF" then
        Settings.TargetMode = "FOLLOW"
        BtnModoAtaque.Text = "  MODO COMBATE/SEGUIMIENTO: FOLLOW"
        BtnModoAtaque.TextColor3 = Color3.fromRGB(0, 200, 255)
        EnviarNotificacion("SISTEMA", "Modo Persecución y Enfoque de Mirada Activado.", Color3.fromRGB(0, 200, 255))
    elseif Settings.TargetMode == "FOLLOW" then
        Settings.TargetMode = "COMBAT"
        BtnModoAtaque.Text = "  MODO COMBATE/SEGUIMIENTO: COMBAT"
        BtnModoAtaque.TextColor3 = Color3.fromRGB(255, 50, 50)
        EnviarNotificacion("SISTEMA", "Modo Autohit Corto (4 Studs) Activado.", Color3.fromRGB(255, 50, 50))
    else
        Settings.TargetMode = "OFF"
        BtnModoAtaque.Text = "  MODO COMBATE/SEGUIMIENTO: OFF"
        BtnModoAtaque.TextColor3 = Color3.fromRGB(255, 200, 0)
        Settings.UltimoObjetivoNotificado = ""
        EnviarNotificacion("SISTEMA", "Motores de combate desactivados.")
    end
end)

-- [EJECUCIÓN FISICA DEL MECHANISM DASH (ESQUIVE)]
local function EjecutarDash()
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if RootPart then
        -- Mueve el CFrame limpiamente respetando la dirección de la cámara
        RootPart.CFrame = RootPart.CFrame + (RootPart.CFrame.LookVector * Settings.DashDist)
        EnviarNotificacion("MECÁNICA", "Dash ejecutado (" .. tostring(Settings.DashDist) .. " Studs)", Color3.fromRGB(255, 50, 50))
    end
end
DashBtn.MouseButton1Click:Connect(EjecutarDash)

-- [MÓDULO DE RENDERIZADO DE ALTA VISIBILIDAD PARA ENTORNO (ANTI-MEZCLA)]
local function InyectarGraficosPersonaje(Char, Enm)
    if not Char:FindFirstChild("AlonshackRenderCore") then
        local CarpetaContenedora = Instance.new("Folder")
        CarpetaContenedora.Name = "AlonshackRenderCore"
        CarpetaContenedora.Parent = Char

        local Head = Char:FindFirstChild("Head")
        if Head then
            -- Adornment estructural (Hitbox visible)
            local CajaWireframe = Instance.new("BoxHandleAdornment")
            CajaWireframe.Name = "HitboxVisualizer"
            CajaWireframe.Size = Char:GetExtentsSize() or Vector3.new(2, 5, 2)
            CajaWireframe.Color3 = Settings.Colors.Hitbox
            CajaWireframe.AlwaysOnTop = true
            CajaWireframe.Transparency = 0.4
            CajaWireframe.ZIndex = 5
            CajaWireframe.Adornee = Char:FindFirstChild("HumanoidRootPart") or Head
            CajaWireframe.Parent = CarpetaContenedora

            -- Etiqueta flotante de alta visibilidad (No se mezcla con el mapa gracias al stroke sólido)
            local BGui = Instance.new("BillboardGui")
            BGui.Name = "HighVisibilityTag"
            BGui.Size = UDim2.new(0, 180, 0, 35)
            BGui.AlwaysOnTop = true
            BGui.StudsOffset = Vector3.new(0, 3.5, 0)
            BGui.Adornee = Head

            local TxtLabel = Instance.new("TextLabel")
            TxtLabel.Size = UDim2.new(1, 0, 1, 0)
            TxtLabel.BackgroundTransparency = 1
            TxtLabel.Text = string.upper(Enm.Name)
            TxtLabel.TextColor3 = Settings.Colors.Etiquetas
            TxtLabel.Font = Enum.Font.Code
            TxtLabel.TextSize = 13
            TxtLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Contorno negro absoluto para romper camuflaje del mapa
            TxtLabel.TextStrokeTransparency = 0 -- Opaco al 100%
            TxtLabel.Parent = BGui

            BGui.Parent = CarpetaContenedora
        end
    else
        -- Actualización dinámica en tiempo real por si cambian colores desde el panel interno
        local Carpeta = Char:FindFirstChild("AlonshackRenderCore")
        if Carpeta then
            local Box = Carpeta:FindFirstChild("HitboxVisualizer")
            if Box then Box.Color3 = Settings.Colors.Hitbox end
            
            local Tag = Carpeta:FindFirstChildOfClass("BillboardGui")
            if Tag and Tag:FindFirstChildOfClass("TextLabel") then
                Tag:FindFirstChildOfClass("TextLabel").TextColor3 = Settings.Colors.Etiquetas
            end
        end
    end
end

local function LimpiarGraficosServidor()
    for _, Enm in ipairs(Players:GetPlayers()) do
        if Enm.Character then
            local Carpeta = Enm.Character:FindFirstChild("AlonshackRenderCore")
            if Carpeta then Carpeta:Destroy() end
        end
    end
end

-- BUCLE DE REFRESCO SÍNCRONO MANDATORIO (Evita saturación de memoria y limpia desincronizaciones de tags)
task.spawn(function()
    while true do
        task.wait(60)
        if Settings.EscanerActivo then
            LimpiarGraficosServidor()
        end
    end
end)

-- [SISTEMA LOGICO CENTRAL DE INTERACCIÓN CORTA/LARGA Y ENFOQUE]
RunService.RenderStepped:Connect(function()
    local MiCharacter = LocalPlayer.Character
    local MiRoot = MiCharacter and MiCharacter:FindFirstChild("HumanoidRootPart")
    local MiHumanoid = MiCharacter and MiCharacter:FindFirstChildOfClass("Humanoid")

    if not Settings.EscanerActivo or not MiRoot then
        LimpiarGraficosServidor()
        return 
    end

    local ObjetivoActual = nil
    local DistanciaRecord = 999999

    -- Escaneo unificado de posiciones relativas
    for _, Enemigo in ipairs(Players:GetPlayers()) do
        if Enemigo ~= LocalPlayer and Enemigo.Character then
            InyectarGraficosPersonaje(Enemigo.Character, Enemigo)

            local SuRoot = Enemigo.Character:FindFirstChild("HumanoidRootPart")
            if SuRoot then
                local ModuloDistancia = (SuRoot.Position - MiRoot.Position).Magnitude
                if ModuloDistancia < DistanciaRecord then
                    DistanciaRecord = ModuloDistancia
                    ObjetivoActual = SuRoot
                end
            end
     
