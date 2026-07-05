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
    UltimoAviso = 0,
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
    TweenService:Create(FrameNotif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0.85, 0)}):Play()
    
    task.spawn(function()
        task.wait(3.5)
        -- Animación de salida
        local tOut = TweenService:Create(FrameNotif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.85, 0)})
        tOut:Play()
        tOut.Completed:Connect(function()
            FrameNotif:Destroy()
        end)
    end)
end

-- [BOTÓN DE MINIMIZADO ESTILIZADO "A"]
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
DashBtn.Position = UDim2.new(0.85, 0, 0.7, 0) 
DashBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 25)
DashBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
DashBtn.BorderSizePixel = 2
DashBtn.Text = "DASH"
DashBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
DashBtn.Font = Enum.Font.RobotoMono
DashBtn.TextSize = 16
DashBtn.Parent = ScreenGui

local DashCorner = Instance.new("UICorner")
DashCorner.CornerRadius = UDim.new(1, 0) 
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

-- [GENERADOR DE BOTONES INTERACTIVOS]
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
local BtnColorConfig = InsertarBotonMenu("CONFIGURAR COLORES SECCIÓN", 3, Color3.fromRGB(255, 255, 255))

-- [MANIPULACIÓN DE MINIMIZADO CON ANIMACIONES]
local MenuAbierto = true

local function DesplegarHUD()
    MiniBtn.Visible = false
    MainDashboard.Visible = true
    TweenService:Create(MainDashboard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.03, 0, 0.05, 0)}):Play()
    MenuAbierto = true
end

local function ColapsarHUD()
    local Anim = TweenService:Create(MainDashboard, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.03, 0, -1, 0)})
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
        EnviarNotificacion("SISTEMA", "Motores de combate desactivados.")
    end
end)

-- [EJECUCIÓN FISICA DEL MECHANISM DASH (ESQUIVE)]
local function EjecutarDash()
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if RootPart then
        RootPart.CFrame = RootPart.CFrame + (RootPart.CFrame.LookVector * Settings.DashDist)
        EnviarNotificacion("MECÁNICA", "Dash ejecutado (" .. tostring(Settings.DashDist) .. " Studs)", Color3.fromRGB(255, 50, 50))
    end
end
DashBtn.MouseButton1Click:Connect(EjecutarDash)

-- [MÓDULO DE RENDERIZADO DE ALTA VISIBILIDAD PARA ENTORNO]
local function InyectarGraficosPersonaje(Char, Enm)
    local Carpeta = Char:FindFirstChild("AlonshackRenderCore")
    if not Carpeta then
        Carpeta = Instance.new("Folder")
        Carpeta.Name = "AlonshackRenderCore"
        Carpeta.Parent = Char

        local Head = Char:FindFirstChild("Head")
        local Root = Char:FindFirstChild("HumanoidRootPart")
        if Head and Root then
            local CajaWireframe = Instance.new("BoxHandleAdornment")
            CajaWireframe.Name = "HitboxVisualizer"
            CajaWireframe.Size = Char:GetExtentsSize() or Vector3.new(2, 5, 2)
            CajaWireframe.Color3 = Settings.Colors.Hitbox
            CajaWireframe.AlwaysOnTop = true
            CajaWireframe.Transparency = 0.4
            CajaWireframe.ZIndex = 5
            CajaWireframe.Adornee = Root
            CajaWireframe.Parent = Carpeta

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
            TxtLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) 
            TxtLabel.TextStrokeTransparency = 0 
            TxtLabel.Parent = BGui

            BGui.Parent = Carpeta
        end
    else
        local Box = Carpeta:FindFirstChild("HitboxVisualizer")
        if Box then Box.Color3 = Settings.Colors.Hitbox end
        
        local Tag = Carpeta:FindFirstChild("HighVisibilityTag")
        if Tag and Tag:FindFirstChildOfClass("TextLabel") then
            Tag:FindFirstChildOfClass("TextLabel").TextColor3 = Settings.Colors.Etiquetas
        end
    end
end

local function DibujarLineasYDistancia(EnmChar, MiRoot, SuRoot)
    local Carpeta = EnmChar:FindFirstChild("AlonshackRenderCore")
    if not Carpeta then return end

    local ContenedorLineas = Carpeta:FindFirstChild("LineaDistanciaFolder")
    if not ContenedorLineas then
        ContenedorLineas = Instance.new("Folder")
        ContenedorLineas.Name = "LineaDistanciaFolder"
        ContenedorLineas.Parent = Carpeta
    end
    ContenedorLineas:ClearAllChildren()

    local p1 = MiRoot.Position
    local p2 = SuRoot.Position
    local ray = (p2 - p1)
    local dist = math.floor(ray.Magnitude)

    -- Renderizar nodos en la línea de trayectoria matemática (3 studs de separación)
    local numPuntos = math.floor(dist / 3)
    for i = 1, numPuntos do
        local pos = p1 + (ray.Unit * (i * 3))
        local pPart = Instance.new("Part")
        pPart.Size = Vector3.new(0.2, 0.2, 0.2)
        pPart.CFrame = CFrame.new(pos)
        pPart.Anchored = true
        pPart.CanCollide = false
        pPart.Transparency = 1
        pPart.Parent = ContenedorLineas
        
        local adorn = Instance.new("BoxHandleAdornment")
        adorn.Size = Vector3.new(0.15, 0.15, 0.4)
        adorn.Color3 = Settings.Colors.Distancia
        adorn.AlwaysOnTop = true
        adorn.Transparency = 0.3
        adorn.ZIndex = 8
        adorn.Adornee = pPart
        adorn.CFrame = CFrame.lookAt(pos, p2)
        adorn.Parent = pPart
    end

    -- Billboard flotante en el centro de la línea de distancia
    local bGuiD = Instance.new("BillboardGui")
    bGuiD.Name = "TagDist"
    bGuiD.Size = UDim2.new(0, 80, 0, 20)
    bGuiD.AlwaysOnTop = true
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = tostring(dist) .. " STUDS"
    lbl.TextColor3 = Settings.Colors.Distancia
    lbl.Font = Enum.Font.RobotoMono
    lbl.TextSize = 11
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0
    lbl.Parent = bGuiD
    
    local pMid = Instance.new("Part")
    pMid.Size = Vector3.new(0.1, 0.1, 0.1)
    pMid.CFrame = CFrame.new(p1 + (ray / 2))
    pMid.Anchored = true
    pMid.CanCollide = false
    pMid.Transparency = 1
    pMid.Parent = ContenedorLineas
    
    bGuiD.Adornee = pMid
    bGuiD.Parent = ContenedorLineas
end

local function LimpiarGraficosServidor()
    for _, Enm in ipairs(Players:GetPlayers()) do
        if Enm.Character then
            local Carpeta = Enm.Character:FindFirstChild("AlonshackRenderCore")
            if Carpeta then Carpeta:Destroy() end
        end
    end
end

-- BUCLE DE REFRESCO SÍNCRONO MANDATORIO (Evita fugas de memoria)
task.spawn(function()
    while true do
        task.wait(60)
        if Settings.EscanerActivo then
            LimpiarGraficosServidor()
        end
    end
end)

-- [SISTEMA LÓGICO CENTRAL DE INTERACCIÓN CORTA/LARGA Y ENFOQUE]
RunService.RenderStepped:Connect(function()
    -- Desactivar colisiones internas del personaje propio para evitar atascos físicos
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

    if not Settings.EscanerActivo then
        LimpiarGraficosServidor()
        return 
    end

    local MiCharacter = LocalPlayer.Character
    local MiRoot = MiCharacter and MiCharacter:FindFirstChild("HumanoidRootPart")
    local MiHumanoid = MiCharacter and MiCharacter:FindFirstChildOfClass("Humanoid")

    if not MiRoot then return end

    local ObjetivoActual = nil
    local DistanciaRecord = 999999
    local EnemigoObjetivo = nil

    -- Escaneo e Inyección Gráfica General
    for _, Enemigo in ipairs(Players:GetPlayers()) do
        if Enemigo ~= LocalPlayer and Enemigo.Character then
            InyectarGraficosPersonaje(Enemigo.Character, Enemigo)

            local SuRoot = Enemigo.Character:FindFirstChild("HumanoidRootPart")
            if SuRoot then
                DibujarLineasYDistancia(Enemigo.Character, MiRoot, SuRoot)
                
                local ModuloDistancia = (SuRoot.Position - MiRoot.Position).Magnitude
                if ModuloDistancia < DistanciaRecord then
                    DistanciaRecord = ModuloDistancia
                    ObjetivoActual = SuRoot
                    EnemigoObjetivo = Enemigo
                end
            end
        end
    end

    -- Alertas de Proximidad por Radar Crítico (Cooldown de 5 segundos)
    if ObjetivoActual and DistanciaRecord < 25 then
        if tick() - Settings.UltimoAviso > 5 then
            Settings.UltimoAviso = tick()
            task.spawn(EnviarNotificacion, "PROXIMIDAD", "ENEMIGO DETECTADO: " .. EnemigoObjetivo.Name:upper(), Color3.fromRGB(255, 50, 50))
        end
    end

    -- Máquina de Ejecución de TargetModes (FOLLOW / COMBAT)
    if ObjetivoActual and Settings.TargetMode ~= "OFF" then
        -- Asegurar enfoque direccional CFrame Vector Lock en el plano horizontal (Y congelado)
        MiRoot.CFrame = CFrame.lookAt(MiRoot.Position, Vector3.new(ObjetivoActual.Position.X, MiRoot.Position.Y, ObjetivoActual.Position.Z))

        if Settings.TargetMode == "COMBAT" then
            -- Forzar aproximación cerrada si la distancia supera el umbral crítico de ataque
            if DistanciaRecord > 4 then
                MiRoot.CFrame = MiRoot.CFrame + (MiRoot.CFrame.LookVector * (DistanciaRecord - 3.8))
            end

            -- Manejo automático de inventario y activación de herramientas (Auto-Atacante)
            local Tool = MiCharacter:FindFirstChildOfClass("Tool")
            if not Tool and LocalPlayer:FindFirstChild("Backpack") then
                local Arma = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if Arma and MiHumanoid then
                    MiHumanoid:EquipTool(Arma)
                    Tool = Arma
                end
            end
            if Tool then 
                Tool:Activate() 
            end
        end
    end
end)
