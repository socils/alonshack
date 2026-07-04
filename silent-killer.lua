local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AlonshackCore"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 310, 0, 410)
Panel.Position = UDim2.new(0.5, -155, -0.6, 0)
Panel.BackgroundColor3 = Color3.fromRGB(10, 16, 16)
Panel.BorderColor3 = Color3.fromRGB(0, 255, 150)
Panel.BorderSizePixel = 2
Panel.Active = true
Panel.Draggable = true
Panel.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 25, 25)
Title.BorderColor3 = Color3.fromRGB(0, 255, 150)
Title.BorderSizePixel = 1
Title.Text = "  💀 CORE SYSTEM v2.5"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Panel

local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(0, 120, 1, 0)
Credits.Position = UDim2.new(1, -125, 0, 0)
Credits.BackgroundTransparency = 1
Credits.Text = "by ALONSHACK"
Credits.TextColor3 = Color3.fromRGB(0, 255, 255)
Credits.Font = Enum.Font.RobotoMono
Credits.TextSize = 11
Credits.TextXAlignment = Enum.TextXAlignment.Right
Credits.Parent = Title

local BtnMinimizar = Instance.new("TextButton")
BtnMinimizar.Size = UDim2.new(0, 25, 0, 25)
BtnMinimizar.Position = UDim2.new(1, -28, 0, 2)
BtnMinimizar.BackgroundTransparency = 1
BtnMinimizar.Text = "[-]"
BtnMinimizar.TextColor3 = Color3.fromRGB(0, 255, 150)
BtnMinimizar.Font = Enum.Font.RobotoMono
BtnMinimizar.TextSize = 14
BtnMinimizar.Parent = Panel

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, 0, 1, -30)
ButtonContainer.Position = UDim2.new(0, 0, 0, 30)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 520)
ButtonContainer.ScrollBarThickness = 4
ButtonContainer.Parent = Panel

local function CrearBoton(texto, pos, parent, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 32)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(15, 25, 25)
	btn.BorderColor3 = color
	btn.BorderSizePixel = 1
	btn.Text = texto
	btn.TextColor3 = color
	btn.Font = Enum.Font.RobotoMono
	btn.TextSize = 11
	btn.Parent = parent
	return btn
end

local BtnVision = CrearBoton("SISTEMA: APAGADO", UDim2.new(0.05, 0, 0.02, 0), ButtonContainer, Color3.fromRGB(0, 255, 150))
local BtnToggleFOV = CrearBoton("MOSTRAR FOV: SI", UDim2.new(0.05, 0, 0.10, 0), ButtonContainer, Color3.fromRGB(0, 200, 255))
local BtnToggleDist = CrearBoton("LINEA DISTANCIA: SI (⚠️ LAG)", UDim2.new(0.05, 0, 0.18, 0), ButtonContainer, Color3.fromRGB(255, 150, 0))
local BtnToggleRadar = CrearBoton("ALERTA PROXIMIDAD: SI", UDim2.new(0.05, 0, 0.26, 0), ButtonContainer, Color3.fromRGB(255, 0, 255))
local BtnToggleAuto = CrearBoton("[BETA] AUTO-ATAQUE: NO", UDim2.new(0.05, 0, 0.34, 0), ButtonContainer, Color3.fromRGB(255, 50, 50))
local BtnColorChg = CrearBoton("CAMBIAR COLOR VISUALIZADOR", UDim2.new(0.05, 0, 0.42, 0), ButtonContainer, Color3.fromRGB(255, 255, 255))
local BtnDetalles = CrearBoton("[+] MOSTRAR MANUAL DETALLADO", UDim2.new(0.05, 0, 0.50, 0), ButtonContainer, Color3.fromRGB(0, 255, 255))

local InfoBox = Instance.new("TextLabel")
InfoBox.Size = UDim2.new(0.9, 0, 0, 0)
InfoBox.Position = UDim2.new(0.05, 0, 0.58, 0)
InfoBox.BackgroundColor3 = Color3.fromRGB(12, 20, 20)
InfoBox.BorderColor3 = Color3.fromRGB(0, 255, 150)
InfoBox.Text = " CONFIGURACIÓN Y OPERACIONES DEL SISTEMA:\n\n * SISTEMA PRINCIPAL:\n   Controla el escaneo base de entornos y mapeo de hilos.\n\n * VECTOR FOV:\n   Calcula de forma predictiva los vectores de visión frontal del objetivo basándose en su orientación craneal.\n\n * PROTOCOLO DISTANCIA (⚠️ ALTO LAG):\n   Traza de forma síncrona puentes de studs tridimensionales. Desactívelo si nota pérdida severa de fotogramas.\n\n * SENSOR BACKUP PROXIMIDAD:\n   Mapea un anillo dinámico de 25 studs. Si falla el rastreo por CFrame del jugador, conmuta inmediatamente a rastreo de silueta activa en la jerarquía del workspace para mantener el bucle de alerta.\n\n * ENFOQUE DE ATAQUE AUTOMÁTICO:\n   Fuerza el alineamiento angular del CFrame con el objetivo y simula la pulsación del ítem primario o activo del inventario."
InfoBox.TextColor3 = Color3.fromRGB(200, 255, 220)
InfoBox.Font = Enum.Font.RobotoMono
InfoBox.TextSize = 9
InfoBox.TextXAlignment = Enum.TextXAlignment.Left
InfoBox.TextYAlignment = Enum.TextYAlignment.Top
InfoBox.ClipsDescendants = true
InfoBox.Visible = false
InfoBox.Parent = ButtonContainer

TweenService:Create(Panel, TweenInfo.new(0.9, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -155, 0.5, -205)}):Play()

local PanelMinimizado = false
BtnMinimizar.MouseButton1Click:Connect(function()
	PanelMinimizado = not PanelMinimizado
	if PanelMinimizado then
		ButtonContainer.Visible = false
		TweenService:Create(Panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 310, 0, 30)}):Play()
		BtnMinimizar.Text = "[+]"
	else
		TweenService:Create(Panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 310, 0, 410)}):Play()
		task.wait(0.15)
		ButtonContainer.Visible = true
		BtnMinimizar.Text = "[-]"
	end
end)

local ManualAbierto = false
BtnDetalles.MouseButton1Click:Connect(function()
	ManualAbierto = not ManualAbierto
	if ManualAbierto then
		BtnDetalles.Text = "[-] OCULTAR MANUAL DETALLADO"
		InfoBox.Visible = true
		TweenService:Create(InfoBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0.9, 0, 0, 260)}):Play()
		ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 780)
	else
		BtnDetalles.Text = "[+] MOSTRAR MANUAL DETALLADO"
		local t = TweenService:Create(InfoBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0.9, 0, 0, 0)})
		t:Play()
		t.Completed:Connect(function()
			if not ManualAbierto then InfoBox.Visible = false end
		end)
		ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 520)
	end
end)

local EscanerActivo = false
local MostrarFOVActivo = true
local MostrarDistActiva = true
local AlertaRadarActiva = true
local AutoAtaqueActivo = false

local ColoresDisponibles = {
	Color3.fromRGB(0, 255, 150),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(255, 0, 100),
	Color3.fromRGB(255, 200, 0)
}
local ColorActualIndex = 1
local ColorVisualizador = ColoresDisponibles[ColorActualIndex]

BtnColorChg.MouseButton1Click:Connect(function()
	ColorActualIndex = ColorActualIndex + 1
	if ColorActualIndex > #ColoresDisponibles then ColorActualIndex = 1 end
	ColorVisualizador = ColoresDisponibles[ColorActualIndex]
	BtnColorChg.TextColor3 = ColorVisualizador
	BtnColorChg.BorderColor3 = ColorVisualizador
end)

BtnToggleFOV.MouseButton1Click:Connect(function()
	MostrarFOVActivo = not MostrarFOVActivo
	BtnToggleFOV.Text = "MOSTRAR FOV: " .. (MostrarFOVActivo and "SI" or "NO")
	BtnToggleFOV.TextColor3 = MostrarFOVActivo and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(100, 100, 100)
end)

BtnToggleDist.MouseButton1Click:Connect(function()
	MostrarDistActiva = not MostrarDistActiva
	BtnToggleDist.Text = "LINEA DISTANCIA: " .. (MostrarDistActiva and "SI (⚠️ LAG)" or "NO")
	BtnToggleDist.TextColor3 = MostrarDistActiva and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(100, 100, 100)
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
