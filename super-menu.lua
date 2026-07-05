-- =============================================================================
-- [SUPER CORE]: MOTOR NEXUS MULTI-ROLES v6.1 - PREMIUM DARK TECH (FIXED)
-- DESCRIPCIÓN: Administrador central de roles, idiomas, y mapeo dinámico de HUD.
-- =============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =============================================================================
-- MÓDULO NATIVO DE IDIOMAS (SISTEMA DE LOCALIZACIÓN UNIVERSAL)
-- =============================================================================
local IdiomaActual = "ES" -- "ES" para Español, "EN" para Inglés
local Diccionario = {
    ES = {
        Cargando = "INICIANDO MATRIZ NEXUS...",
        TituloMain = "NEXUS // MENÚ PRINCIPAL",
        Vacio = "[-] NO SE ENCONTRARON ROLES\nPANEL VACÍO // PRÓXIMAMENTE...",
        GuiaTitulo = "// GUÍA DE CONTROLES",
        GuiaContenido = "• SELECTOR: Explora e inyecta los roles disponibles.\n• TECLA [ ` ]: Oculta o muestra este panel por completo.\n• HABILIDADES: Configura las variables de cada rol en sus submenús.",
        VolverRoles = "< ROLES",
        VolverAtras = "< VOLVER",
        ModoEdicionActivo = "MODO EDICIÓN: Arrastra botones. Click en Core para guardar.",
        BotonPC = "MODO: PC (TECLADO)",
        BotonMovil = "MODO: MÓVIL (TÁCTIL)",
        EditarHUD = "[ REUBICAR BOTONES HUD ]",
        Creditos = "SISTEMA NEXUS CORE // POR ALONIXZ-GROUP"
    },
    EN = {
        Cargando = "INITIALIZING NEXUS MATRIX...",
        TituloMain = "NEXUS // MAIN MENU",
        Vacio = "[-] NO ROLES FOUND\nEMPTY PANEL // COMING SOON...",
        GuiaTitulo = "// CONTROLS GUIDE",
        GuiaContenido = "• SELECTOR: Explore and inject available roles.\n• KEY [ ` ]: Hide or show this panel completely.\n• SKILLS: Configure each role's variables in its submenus.",
        VolverRoles = "< ROLES",
        VolverAtras = "< BACK",
        ModoEdicionActivo = "EDIT MODE: Drag buttons. Click on Core to save.",
        BotonPC = "MODE: PC (KEYBOARD)",
        BotonMovil = "MODE: MOBILE (TOUCH)",
        EditarHUD = "[ REPOSITION HUD BUTTONS ]",
        Creditos = "NEXUS CORE SYSTEM // BY ALONIXZ-GROUP"
    }
}

local function T(clave)
    return Diccionario[IdiomaActual][clave] or clave
end

-- [CONFIGURACIÓN GLOBAL DEL NÚCLEO]
local CoreConfig = {
    ColorTema = Color3.fromRGB(0, 160, 255), 
    ColorFondo = Color3.fromRGB(12, 14, 18),
    ColorTarjetas = Color3.fromRGB(20, 24, 30),
    RolesRegistrados = {},
    ModoDispositivo = "PC", 
    ModModoEdicionHUD = false
}

-- Contenedor de Pantalla Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_CoreMaster"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- =============================================================================
-- ANIMACIÓN DE CARGA CORREGIDA (PREMIUM LOADING)
-- =============================================================================
local function SecuenciaDeCarga()
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 9, 12)
    LoadingFrame.ZIndex = 100
    LoadingFrame.Parent = ScreenGui

    local TextoCarga = Instance.new("TextLabel")
    TextoCarga.Size = UDim2.new(1, 0, 0, 40)
    TextoCarga.Position = UDim2.new(0, 0, 0.45, 0)
    TextoCarga.BackgroundTransparency = 1
    TextoCarga.Font = Enum.Font.RobotoMono -- CORREGIDO: Fuente universal estable
    TextoCarga.Text = T("Cargando")
    TextoCarga.TextColor3 = CoreConfig.ColorTema
    TextoCarga.TextSize = 14
    TextoCarga.Parent = LoadingFrame

    local BarraFondo = Instance.new("Frame")
    BarraFondo.Size = UDim2.new(0, 200, 0, 4)
    BarraFondo.Position = UDim2.new(0.5, -100, 0.52, 0)
    BarraFondo.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    BarraFondo.BorderSizePixel = 0
    BarraFondo.Parent = LoadingFrame

    local BarraProgreso = Instance.new("Frame")
    BarraProgreso.Size = UDim2.new(0, 0, 1, 0)
    BarraProgreso.BackgroundColor3 = CoreConfig.ColorTema
    BarraProgreso.BorderSizePixel = 0
    BarraProgreso.Parent = BarraFondo

    Instance.new("UICorner", BarraFondo).CornerRadius = UDim.new(1, 0)
    Instance.new("UICorner", BarraProgreso).CornerRadius = UDim.new(1, 0)

    TweenService:Create(BarraProgreso, TweenInfo.new(0.6, Enum.EasingStyle.QuadOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.7)
    
    local desaparecer = TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.QuadIn), {BackgroundTransparency = 1})
    desaparecer:Play()
    TweenService:Create(TextoCarga, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(BarraFondo, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarraProgreso, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    desaparecer.Completed:Connect(function() LoadingFrame:Destroy() end)
end

-- =============================================================================
-- INTERFAZ PRINCIPAL (DISEÑO PREMIUM DARK TECH)
-- =============================================================================
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 320, 0, 460)
MainPanel.Position = UDim2.new(0.04, 0, 0.2, 0)
MainPanel.BackgroundColor3 = CoreConfig.ColorFondo
MainPanel.BorderSizePixel = 0
MainPanel.ClipsDescendants = true
MainPanel.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainPanel

local LineaBrillo = Instance.new("Frame")
LineaBrillo.Size = UDim2.new(1, 0, 0, 3)
LineaBrillo.BackgroundColor3 = CoreConfig.ColorTema
LineaBrillo.BorderSizePixel = 0
LineaBrillo.Parent = MainPanel

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(0.6, 0, 0, 45)
MenuTitle.Position = UDim2.new(0, 16, 0, 3)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = T("TituloMain")
MenuTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.TextSize = 14
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.Parent = MainPanel

-- BOTONES SUPERIORES (MINIMIZAR / PURGAR)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 8)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(140, 145, 155)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = MainPanel

local PurgeBtn = Instance.new("TextButton")
PurgeBtn.Size = UDim2.new(0, 30, 0, 30)
PurgeBtn.Position = UDim2.new(1, -40, 0, 8)
PurgeBtn.BackgroundTransparency = 1
PurgeBtn.Text = "✕"
PurgeBtn.TextColor3 = Color3.fromRGB(240, 90, 90)
PurgeBtn.Font = Enum.Font.SourceSansBold
PurgeBtn.TextSize = 16
PurgeBtn.Parent = MainPanel

-- Zona táctil invisible para restaurar el menú
local InvisibleTrigger = Instance.new("TextButton")
InvisibleTrigger.Size = UDim2.new(0, 40, 0, 40)
InvisibleTrigger.Position = UDim2.new(0, 0, 0, 0)
InvisibleTrigger.BackgroundTransparency = 1
InvisibleTrigger.Text = ""
InvisibleTrigger.Visible = false
InvisibleTrigger.Parent = ScreenGui

-- =============================================================================
-- CAPAS DE NAVEGACIÓN INTERNA
-- =============================================================================
-- Capa 1: Selección de Roles (Home)
local SuperHomeView = Instance.new("ScrollingFrame")
SuperHomeView.Size = UDim2.new(1, -32, 0, 200)
SuperHomeView.Position = UDim2.new(0, 16, 0, 50)
SuperHomeView.BackgroundTransparency = 1
SuperHomeView.ScrollBarThickness = 0
SuperHomeView.Parent = MainPanel

local SuperHomeLayout = Instance.new("UIListLayout")
SuperHomeLayout.Padding = UDim.new(0, 8)
SuperHomeLayout.Parent = SuperHomeView

local IdleLabel = Instance.new("TextLabel")
IdleLabel.Size = UDim2.new(1, 0, 0, 50)
IdleLabel.BackgroundTransparency = 1
IdleLabel.Text = T("Vacio")
IdleLabel.TextColor3 = Color3.fromRGB(100, 110, 125)
IdleLabel.Font = Enum.Font.SourceSansItalic
IdleLabel.TextSize = 12
IdleLabel.Parent = SuperHomeView

-- Capa 2: Vista de Habilidades del Rol Seleccionado
local RoleView = Instance.new("Frame")
RoleView.Size = UDim2.new(1, -32, 0, 200)
RoleView.Position = UDim2.new(1, 20, 0, 50)
RoleView.BackgroundTransparency = 1
RoleView.Parent = MainPanel

local RoleTitle = Instance.new("TextLabel")
RoleTitle.Size = UDim2.new(0.7, 0, 0, 25)
RoleTitle.BackgroundTransparency = 1
RoleTitle.TextColor3 = CoreConfig.ColorTema
RoleTitle.Font = Enum.Font.SourceSansBold
RoleTitle.TextSize = 13
RoleTitle.TextXAlignment = Enum.TextXAlignment.Left
RoleTitle.Parent = RoleView

local BackToHomeBtn = Instance.new("TextButton")
BackToHomeBtn.Size = UDim2.new(0, 65, 0, 24)
BackToHomeBtn.Position = UDim2.new(1, -65, 0, 0)
BackToHomeBtn.BackgroundColor3 = CoreConfig.ColorTarjetas
BackToHomeBtn.Text = T("VolverRoles")
BackToHomeBtn.TextColor3 = Color3.fromRGB(200, 205, 215)
BackToHomeBtn.Font = Enum.Font.SourceSansBold
BackToHomeBtn.TextSize = 11
BackToHomeBtn.Parent = RoleView
Instance.new("UICorner", BackToHomeBtn).CornerRadius = UDim.new(0, 4)

local RoleContentScroll = Instance.new("ScrollingFrame")
RoleContentScroll.Size = UDim2.new(1, 0, 1, -30)
RoleContentScroll.Position = UDim2.new(0, 0, 0, 30)
RoleContentScroll.BackgroundTransparency = 1
RoleContentScroll.ScrollBarThickness = 0
RoleContentScroll.Parent = RoleView

local RoleLayout = Instance.new("UIListLayout")
RoleLayout.Padding = UDim.new(0, 6)
RoleLayout.Parent = RoleContentScroll

-- Capa 3: Submenú de Ajustes de la Habilidad
local SubMenuView = Instance.new("Frame")
SubMenuView.Size = UDim2.new(1, -32, 0, 200)
SubMenuView.Position = UDim2.new(1, 20, 0, 50)
SubMenuView.BackgroundTransparency = 1
SubMenuView.Parent = MainPanel

local SubMenuTitle = Instance.new("TextLabel")
SubMenuTitle.Size = UDim2.new(0.7, 0, 0, 25)
SubMenuTitle.BackgroundTransparency = 1
SubMenuTitle.TextColor3 = CoreConfig.ColorTema
SubMenuTitle.Font = Enum.Font.SourceSansBold
SubMenuTitle.TextSize = 13
SubMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
SubMenuTitle.Parent = SubMenuView

local BackToRoleBtn = Instance.new("TextButton")
BackToRoleBtn.Size = UDim2.new(0, 65, 0, 24)
BackToRoleBtn.Position = UDim2.new(1, -65, 0, 0)
BackToRoleBtn.BackgroundColor3 = CoreConfig.ColorTarjetas
BackToRoleBtn.Text = T("VolverAtras")
BackToRoleBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
BackToRoleBtn.Font = Enum.Font.SourceSansBold
BackToRoleBtn.TextSize = 11
BackToRoleBtn.Parent = SubMenuView
Instance.new("UICorner", BackToRoleBtn).CornerRadius = UDim.new(0, 4)

local SubMenuContent = Instance.new("ScrollingFrame")
SubMenuContent.Size = UDim2.new(1, 0, 1, -30)
SubMenuContent.Position = UDim2.new(0, 0, 0, 30)
SubMenuContent.BackgroundTransparency = 1
SubMenuContent.ScrollBarThickness = 0
SubMenuContent.Parent = SubMenuView

local SubLayout = Instance.new("UIListLayout")
SubLayout.Padding = UDim.new(0, 6)
SubLayout.Parent = SubMenuContent

-- =============================================================================
-- PANEL DE CONFIGURACIÓN DEL HUD
-- =============================================================================
local PanelControlHUD = Instance.new("Frame")
PanelControlHUD.Size = UDim2.new(1, -32, 0, 75)
PanelControlHUD.Position = UDim2.new(0, 16, 0, 260)
PanelControlHUD.BackgroundColor3 = CoreConfig.ColorTarjetas
PanelControlHUD.BorderSizePixel = 0
PanelControlHUD.Parent = MainPanel
Instance.new("UICorner", PanelControlHUD).CornerRadius = UDim.new(0, 8)

local DispositivoBtn = Instance.new("TextButton")
DispositivoBtn.Size = UDim2.new(0.46, 0, 0, 30)
DispositivoBtn.Position = UDim2.new(0, 8, 0, 8)
DispositivoBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 42)
DispositivoBtn.Text = T("BotonPC")
DispositivoBtn.TextColor3 = Color3.fromRGB(180, 200, 255)
DispositivoBtn.Font = Enum.Font.SourceSansBold
DispositivoBtn.TextSize = 11
DispositivoBtn.Parent = PanelControlHUD
Instance.new("UICorner", DispositivoBtn).CornerRadius = UDim.new(0, 5)

local SwitchIdiomaBtn = Instance.new("TextButton")
SwitchIdiomaBtn.Size = UDim2.new(0.46, 0, 0, 30)
SwitchIdiomaBtn.Position = UDim2.new(0.54, -8, 0, 8)
SwitchIdiomaBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 42)
SwitchIdiomaBtn.Text = "IDIOMA: " .. IdiomaActual
SwitchIdiomaBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
SwitchIdiomaBtn.Font = Enum.Font.SourceSansBold
SwitchIdiomaBtn.TextSize = 11
SwitchIdiomaBtn.Parent = PanelControlHUD
Instance.new("UICorner", SwitchIdiomaBtn).CornerRadius = UDim.new(0, 5)

local EditarHUDBtn = Instance.new("TextButton")
EditarHUDBtn.Size = UDim2.new(1, -16, 0, 26)
EditarHUDBtn.Position = UDim2.new(0, 8, 0, 42)
EditarHUDBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
EditarHUDBtn.Text = T("EditarHUD")
EditarHUDBtn.TextColor3 = Color3.fromRGB(0, 220, 140)
EditarHUDBtn.Font = Enum.Font.SourceSansBold
EditarHUDBtn.TextSize = 11
EditarHUDBtn.Parent = PanelControlHUD
Instance.new("UICorner", EditarHUDBtn).CornerRadius = UDim.new(0, 5)

-- Contenedor donde se alojarán los botones en pantalla de forma libre
local ContenedorBotonesHUD = Instance.new("Frame")
ContenedorBotonesHUD.Size = UDim2.new(0, 300, 0, 300)
ContenedorBotonesHUD.Position = UDim2.new(0.75, 0, 0.5, -150)
ContenedorBotonesHUD.BackgroundTransparency = 1
ContenedorBotonesHUD.Parent = ScreenGui

-- Guía informativa y créditos inferiores
local GuideFrame = Instance.new("Frame")
GuideFrame.Size = UDim2.new(1, -32, 0, 75)
GuideFrame.Position = UDim2.new(0, 16, 0, 345)
GuideFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
GuideFrame.Parent = MainPanel
Instance.new("UICorner", GuideFrame).CornerRadius = UDim.new(0, 8)

local GuideTitle = Instance.new("TextLabel")
GuideTitle.Size = UDim2.new(1, -12, 0, 20)
GuideTitle.Position = UDim2.new(0, 8, 0, 2)
GuideTitle.BackgroundTransparency = 1
GuideTitle.Text = T("GuiaTitulo")
GuideTitle.TextColor3 = CoreConfig.ColorTema
GuideTitle.Font = Enum.Font.SourceSansBold
GuideTitle.TextSize = 11
GuideTitle.TextXAlignment = Enum.TextXAlignment.Left
GuideTitle.Parent = GuideFrame

local GuideContent = Instance.new("TextLabel")
GuideContent.Size = UDim2.new(1, -16, 1, -22)
GuideContent.Position = UDim2.new(0, 8, 0, 22)
GuideContent.BackgroundTransparency = 1
GuideContent.Text = T("GuiaContenido")
GuideContent.TextColor3 = Color3.fromRGB(140, 145, 155)
GuideContent.Font = Enum.Font.SourceSans
GuideContent.TextSize = 11
GuideContent.TextXAlignment = Enum.TextXAlignment.Left
GuideContent.TextYAlignment = Enum.TextYAlignment.Top
GuideContent.TextWrapped = true
GuideContent.Parent = GuideFrame

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 0, 20)
CreditsLabel.Position = UDim2.new(0, 0, 1, -20)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = T("Creditos")
CreditsLabel.TextColor3 = Color3.fromRGB(75, 80, 95)
CreditsLabel.Font = Enum.Font.SourceSans
CreditsLabel.TextSize = 10
CreditsLabel.Parent = MainPanel

-- =============================================================================
-- LOGICA ARRASTRE Y SOPORTE DE EDICIÓN HUD
-- =============================================================================
local function HacerBotonArrastrableYConfigurable(boton, dataHabilidad)
    local arrastrando = false
    local entradaObj, posInicial, posInicialBoton
    
    boton.InputBegan:Connect(function(input)
        if not CoreConfig.ModModoEdicionHUD then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            arrastrando = true
            entradaObj = input
            posInicial = input.Position
            posInicialBoton = boton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    arrastrando = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if arrastrando and input == entradaObj and CoreConfig.ModModoEdicionHUD then
            local delta = input.Position - posInicial
            boton.Position = UDim2.new(
                posInicialBoton.X.Scale, 
                posInicialBoton.X.Offset + delta.X, 
                posInicialBoton.Y.Scale, 
                posInicialBoton.Y.Offset + delta.Y
            )
        end
    end)
end

-- =============================================================================
-- GESTIÓN DE IDIOMAS
-- =============================================================================
local function ActualizarIdiomaInterfaz()
    MenuTitle.Text = T("TituloMain")
    IdleLabel.Text = T("Vacio")
    GuideTitle.Text = T("GuiaTitulo")
    GuideContent.Text = T("GuiaContenido")
    BackToHomeBtn.Text = T("VolverRoles")
    BackToRoleBtn.Text = T("VolverAtras")
    EditarHUDBtn.Text = T("EditarHUD")
    CreditsLabel.Text = T("Creditos")
    DispositivoBtn.Text = CoreConfig.ModoDispositivo == "PC" and T("BotonPC") or T("BotonMovil")
    SwitchIdiomaBtn.Text = "IDIOMA: " .. IdiomaActual
end

SwitchIdiomaBtn.MouseButton1Click:Connect(function()
    IdiomaActual = IdiomaActual == "ES" and "EN" or "ES"
    ActualizarIdiomaInterfaz()
end)

-- =============================================================================
-- NAVEGACIÓN Y CONFIGURACIÓN DISPOSITIVO
-- =============================================================================
DispositivoBtn.MouseButton1Click:Connect(function()
    CoreConfig.ModoDispositivo = CoreConfig.ModoDispositivo == "PC" and "MOVIL" or "PC"
    DispositivoBtn.Text = CoreConfig.ModoDispositivo == "PC" and T("BotonPC") or T("BotonMovil")
    
    for _, btn in ipairs(ContenedorBotonesHUD:GetChildren()) do
        if btn:IsA("TextButton") and btn:FindFirstChild("AtajoRef") then
            btn.AtajoRef.Visible = (CoreConfig.ModoDispositivo == "PC")
        end
    end
end)

EditarHUDBtn.MouseButton1Click:Connect(function()
    CoreConfig.ModModoEdicionHUD = not CoreConfig.ModModoEdicionHUD
    if CoreConfig.ModModoEdicionHUD then
        EditarHUDBtn.Text = T("ModoEdicionActivo")
        EditarHUDBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 60)
    else
        EditarHUDBtn.Text = T("EditarHUD")
        EditarHUDBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    end
end)

local function AbrirMenuDelRol(datosRol)
    RoleTitle.Text = "ROLE // " .. string.upper(datosRol.Nombre)
    MainPanel.BorderColor3 = datosRol.ColorHitech or CoreConfig.ColorTema
    LineaBrillo.BackgroundColor3 = datosRol.ColorHitech or CoreConfig.ColorTema
    
    for _, child in ipairs(RoleContentScroll:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
    
    if datosRol.Habilidades then
        datosRol.Habilidades(RoleContentScroll, function(nombreHabilidad, callbackConfig, dataHabilidadExtra)
            local HabBtn = Instance.new("TextButton")
            HabBtn.Size = UDim2.new(1, 0, 0, 36)
            HabBtn.BackgroundColor3 = CoreConfig.ColorTarjetas
            HabBtn.BorderSizePixel = 0
            HabBtn.Text = "  ⚡  " .. nombreHabilidad
            HabBtn.TextColor3 = Color3.fromRGB(200, 210, 220)
            HabBtn.Font = Enum.Font.SourceSansBold
            HabBtn.TextSize = 12
            HabBtn.TextXAlignment = Enum.TextXAlignment.Left
            HabBtn.Parent = RoleContentScroll
            Instance.new("UICorner", HabBtn).CornerRadius = UDim.new(0, 6)
            
            if dataHabilidadExtra and dataHabilidadExtra.RequiereBotonHUD then
                local BotonHUD = Instance.new("TextButton")
                BotonHUD.Name = nombreHabilidad .. "_HUD"
                BotonHUD.Size = UDim2.new(0, 50, 0, 50)
                BotonHUD.Position = UDim2.new(0, (#ContenedorBotonesHUD:GetChildren() * 55) % 200, 0, 50)
                BotonHUD.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
                BotonHUD.BorderColor3 = datosRol.ColorHitech or CoreConfig.ColorTema
                BotonHUD.BorderSizePixel = 1
                BotonHUD.Text = dataHabilidadExtra.IconoTexto or nombreHabilidad:sub(1,3):upper()
                BotonHUD.TextColor3 = Color3.fromRGB(240, 240, 240)
                BotonHUD.Font = Enum.Font.SourceSansBold
                BotonHUD.TextSize = 12
                BotonHUD.Parent = ContenedorBotonesHUD
                Instance.new("UICorner", BotonHUD).CornerRadius = UDim.new(1, 0)
                
                local AtajoText = Instance.new("TextLabel")
                AtajoText.Name = "AtajoRef"
                AtajoText.Size = UDim2.new(0, 16, 0, 16)
                AtajoText.Position = UDim2.new(1, -14, 0, -2)
                AtajoText.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
                AtajoText.Text = dataHabilidadExtra.TeclaAtajo or "E"
                AtajoText.TextColor3 = Color3.fromRGB(255, 255, 255)
                AtajoText.Font = Enum.Font.SourceSansBold
                AtajoText.TextSize = 9
                AtajoText.Visible = (CoreConfig.ModoDispositivo == "PC")
                AtajoText.Parent = BotonHUD
                Instance.new("UICorner", AtajoText).CornerRadius = UDim.new(0, 4)
                
                HacerBotonArrastrableYConfigurable(BotonHUD, dataHabilidadExtra)
                
                BotonHUD.MouseButton1Click:Connect(function()
                    if not CoreConfig.ModModoEdicionHUD and dataHabilidadExtra.AlPresionarHabilidad then
                        dataHabilidadExtra.AlPresionarHabilidad()
                    end
                end)
            end
            
            HabBtn.MouseButton1Click:Connect(function()
                for _, child in ipairs(SubMenuContent:GetChildren()) do
                    if not child:IsA("UIListLayout") then child:Destroy() end
                end
                SubMenuTitle.Text = "SET // " .. string.upper(nombreHabilidad)
                if callbackConfig then callbackConfig(SubMenuContent) end
                
                TweenService:Create(RoleView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(-1, -20, 0, 50)}):Play()
                TweenService:Create(SubMenuView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(0, 16, 0, 50)}):Play()
            end)
        end)
    end
    
    TweenService:Create(SuperHomeView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(-1, -20, 0, 50)}):Play()
    TweenService:Create(RoleView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(0, 16, 0, 50)}):Play()
end

BackToHomeBtn.MouseButton1Click:Connect(function()
    MainPanel.BorderColor3 = CoreConfig.ColorTema
    LineaBrillo.BackgroundColor3 = CoreConfig.ColorTema
    TweenService:Create(SuperHomeView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(0, 16, 0, 50)}):Play()
    TweenService:Create(RoleView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(1, 20, 0, 50)}):Play()
end)

BackToRoleBtn.MouseButton1Click:Connect(function()
    TweenService:Create(RoleView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(0, 16, 0, 50)}):Play()
    TweenService:Create(SubMenuView, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(1, 20, 0, 50)}):Play()
end)

-- LOGICA VISUAL MINIMIZADO FANTASMA
local PanelAbierto = true
local function AlternarVisibilidad()
    PanelAbierto = not PanelAbierto
    if PanelAbierto then
        MainPanel.Visible = true
        InvisibleTrigger.Visible = false
        ContenedorBotonesHUD.Visible = true
        TweenService:Create(MainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.04, 0, 0.2, 0)}):Play()
    else
        local anim = TweenService:Create(MainPanel, TweenInfo.new(0.3, Enum.EasingStyle.QuadIn), {Position = UDim2.new(0.04, 0, -1, 0)})
        anim:Play()
        ContenedorBotonesHUD.Visible = false
        anim.Completed:Connect(function()
            if not PanelAbierto then MainPanel.Visible = false InvisibleTrigger.Visible = true end
        end)
    end
end

MinimizeBtn.MouseButton1Click:Connect(AlternarVisibilidad)
InvisibleTrigger.MouseButton1Click:Connect(AlternarVisibilidad)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Backquote then AlternarVisibilidad() end
end)

-- =============================================================================
-- API MAESTRA DE INYECCIÓN DE ROLES COMPATIBLE
-- =============================================================================
_G.RegistrarNuevoRolEngine = function(data)
    IdleLabel.Visible = false
    table.insert(CoreConfig.RolesRegistrados, data)
    
    local RoleBtn = Instance.new("TextButton")
    RoleBtn.Size = UDim2.new(1, 0, 0, 40)
    RoleBtn.BackgroundColor3 = CoreConfig.ColorTarjetas
    RoleBtn.BorderSizePixel = 0
    RoleBtn.Text = "  ⚜️  " .. string.upper(data.Nombre)
    RoleBtn.TextColor3 = Color3.fromRGB(210, 220, 235)
    RoleBtn.Font = Enum.Font.SourceSansBold
    RoleBtn.TextSize = 13
    RoleBtn.TextXAlignment = Enum.TextXAlignment.Left
    RoleBtn.Parent = SuperHomeView
    Instance.new("UICorner", RoleBtn).CornerRadius = UDim.new(0, 6)
    
    local colorDestaco = data.ColorHitech or CoreConfig.ColorTema
    RoleBtn.MouseEnter:Connect(function()
        TweenService:Create(RoleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 34, 42), TextColor3 = colorDestaco}):Play()
    end)
    RoleBtn.MouseLeave:Connect(function()
        TweenService:Create(RoleBtn, TweenInfo.new(0.2), {BackgroundColor3 = CoreConfig.ColorTarjetas, TextColor3 = Color3.fromRGB(210, 220, 235)}):Play()
    end)
    
    RoleBtn.MouseButton1Click:Connect(function()
        AbrirMenuDelRol(data)
    end)
end

-- CONTROLADOR DE PURGA CENTRAL
PurgeBtn.MouseButton1Click:Connect(function()
    _G.RegistrarNuevoRolEngine = nil
    ScreenGui:Destroy()
end)

-- Inicialización Ejecutable
SecuenciaDeCarga()
