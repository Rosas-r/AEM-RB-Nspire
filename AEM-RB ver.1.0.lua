    DISPOSITIVO_ID = platform.getDeviceID()
    DISPOSITIVO_ID = ""
    USUARIO_ID = ""     
    PROGRAMA_ACTIVO = DISPOSITIVO_ID == USUARIO_ID and true or false
end

function on.activate()
    
    var.store("analisis",0)
    
    estructuraMenu = {
        {nombre = "Crear estruct.", estado = true, icono = nil, opciones = {
            {nombre = "Generar nodo", estado = true, icono = nil, accion = nodos},
            {nombre = "Generar barra", estado = false, icono = nil, accion = barras},
            {nombre = "Cod. de apoyo", estado = false, icono = nil, accion = restricciones},
            {nombre = "Cod. de contn.", estado = false, icono = nil, accion = contorno},
        }},
        {nombre = "Asig. Propied.", estado = false, icono = nil, opciones = {
            {nombre = "Asignar Secci.", estado = false, icono = nil, accion = barrasPropiedades},
        }},
        {nombre = "Asig. Cargas", estado = false, icono = nil, opciones = {
            {nombre = "Carga puntual", estado = false, icono = nil, accion = nodosPuntual},
            {nombre = "Carga distribu.", estado = false, icono = nil, accion = barrasDistribuida},
        }},
        {nombre = "Ejecu. anális.", estado = false, icono = nil, opciones = {
            {nombre = "Ejecu. análisis", estado = false, icono = nil, accion = ejecutar},
        }},
        {nombre = "Anali. gráfico", estado = false, icono = nil, opciones = {
            {nombre = "Diagrama F.A.", estado = true, icono = nil, accion = DFA},
            {nombre = "Diagrama F.C.", estado = true, icono = nil, accion = DFC},
            {nombre = "Diagrama M.F.", estado = true, icono = nil, accion = DMF},
            {nombre = "Desplazamiet.", estado = true, icono = nil, accion = desplazamiento},
            {nombre = "Reacciones", estado = true, icono = nil, accion = reacciones},
        }},
        {nombre = "Anali. analíti.", estado = false, icono = nil, opciones = {
            {nombre = "Datos general.", estado = true, icono = nil, accion = datos_generales},
            {nombre = "M. Rig. local", estado = true, icono = nil, accion = m_rig_local},
            {nombre = "M. Transform.", estado = true, icono = nil, accion = m_trans},
            {nombre = "M. Rig. global", estado = true, icono = nil, accion = m_rig_global},
            {nombre = "M. Ensamblad.", estado = true, icono = nil, accion = m_ensamblada},
            {nombre = "V. Fuerzas ex.", estado = true, icono = nil, accion = v_fuerzas_ex},
            {nombre = "V. Desplazam.", estado = true, icono = nil, accion = v_desplazamiento},
            {nombre = "V. Reacciones", estado = true, icono = nil, accion = v_reacciones},
            {nombre = "V. Esfuerzos", estado = true, icono = nil, accion = v_esfuerzos},
        }},
        {nombre = "Editar estruct.", estado = true, icono = nil, opciones = {
            {nombre = "Editar estruct.", estado = true, icono = nil, accion = function(gc) 
                if  estructuraMenu[5].estado then -- Opcion activa cuando ya se hizo algun calculo
                    var.store("analisis",0)
                    estructuraMenu[1].estado = estructuraMenu1_estado 
                    estructuraMenu[1].opciones[1].estado = estructuraMenu1_opciones1_estado 
                    estructuraMenu[1].opciones[2].estado = estructuraMenu1_opciones2_estado 
                    estructuraMenu[1].opciones[3].estado = estructuraMenu1_opciones3_estado 
                    estructuraMenu[1].opciones[4].estado = estructuraMenu1_opciones4_estado 
                    estructuraMenu[2].estado = estructuraMenu2_estado 
                    estructuraMenu[2].opciones[1].estado = estructuraMenu2_opciones1_estado 
                    estructuraMenu[3].estado = estructuraMenu3_estado 
                    estructuraMenu[3].opciones[1].estado = estructuraMenu3_opciones1_estado 
                    estructuraMenu[3].opciones[2].estado = estructuraMenu3_opciones2_estado 
                    estructuraMenu[5].estado = false
                    estructuraMenu[6].estado = false
                    MENU.controlEstado = true
                    --MENU.accion = {7,2}
                    inicio(gc)
                end
                inicio(gc)
            end},  
            {nombre = "Reiniciar prog.", estado = true, icono = nil, accion = function(gc)
                var.store("analisis",0)
                ENTRADA_NODOS.memoria = {}
                ENTRADA_BARRAS.memoria = {}
                ENTRADA_NODOS_RESTRICCIONES.memoria = {}
                ENTRADA_BARRAS_CONTORNO.memoria = {}
                ENTRADA_BARRAS_PROPIEDADES.memoria = {}
                ENTRADA_NODOS_PUNTUAL.memoria = {}
                ENTRADA_BARRAS_DISTRIBUIDA.memoria = {}
                estructuraMenu[1].estado = true
                estructuraMenu[1].opciones[1].estado = true
                estructuraMenu[1].opciones[2].estado = false
                estructuraMenu[1].opciones[3].estado = false
                estructuraMenu[1].opciones[4].estado = false
                estructuraMenu[2].estado = false
                estructuraMenu[2].opciones[1].estado = false
                estructuraMenu[3].estado = false
                estructuraMenu[3].opciones[1].estado = false
                estructuraMenu[3].opciones[2].estado = false
                estructuraMenu[5].estado = false
                estructuraMenu[6].estado = false
                MENU.controlEstado = true
               inicio(gc)
            end},
        }},
        {nombre = "Sobre nosotros", estado = true, icono = nil, opciones = {
            {nombre = "Información", estado = true, icono = nil, accion = nosotros},
            {nombre = "Regr. a inicio", estado = true, icono = nil, accion = inicio},
        }},
    }
    
    controlEspecial = function()
        local datoActualizado = false
        local function verificarCambio() 
            for _, valor in ipairs(ENTRADA_NODOS_RESTRICCIONES.memoria) do
                if valor[1] ~= 1 then
                    datoActualizado = true
                    break
                end
            end
        end
        verificarCambio()
        function todosLosNodosConectados(nodos,barras)
            local totalNodos = #nodos.memoria
            local nodosConectados = {}
            for _, par in ipairs(barras.memoria) do
                nodosConectados[par[1]] = true
                nodosConectados[par[2]] = true
            end
            for id = 1, totalNodos do
                if not nodosConectados[id] then
                    return false
                end
            end
            return true
        end  
        if datoActualizado and todosLosNodosConectados(ENTRADA_NODOS,ENTRADA_BARRAS) then
            estructuraMenu[4].estado = true
            estructuraMenu[4].opciones[1].estado = true
        else
            estructuraMenu[4].estado = false
            estructuraMenu[4].opciones[1].estado = false
        end
    end
    
    MENU = menu(estructuraMenu,controlEspecial) 
    -- Se crea el entono grafico de las estructuras como instancia de la calse grafico  
    GRAFICO = grafico(118,25,161)
    --MENU.accion = {4,1}
    
    -- Detalles de programa
    EMPRESA = "AEM-RB"
    SERVICIO_A = "Análisis Estructural Matricial de"
    SERVICIO_B = "Reticulados Bidimensionales"
    VERSION = "Ver.1.0"
        
    -- Variables Globales
    W = platform.window:width()
    H = platform.window:height()
    uChar = nil
    DECIMALES = 2
    pox = 5
    poy = 5
    
    -- Se crea los cuadros de entrada y memoria como uns isntancia de la clase entrada
    ENTRADA_NODOS = entrada(ENTRADA_NODOS_ESTRUCTURA,"ENTRADA_NODOS",ENTRADA_NODOS_CONTROL,ENTRADA_NODOS_GENERADOR,1)
    ENTRADA_BARRAS = entrada(ENTRADA_BARRAS_ESTRUCTURA,"ENTRADA_BARRAS",ENTRADA_BARRAS_CONTROL,ENTRADA_BARRAS_GENERADOR,1)
    ENTRADA_NODOS_RESTRICCIONES = entrada(ENTRADA_NODOS_RESTRICCIONES_ESTRUCTURA,"ENTRADA_NODOS_RESTRICCIONES",ENTRADA_NODOS_RESTRICCIONES_CONTROL,ENTRADA_NODOS_RESTRICCIONES_GENERADOR,2)
    ENTRADA_BARRAS_CONTORNO = entrada(ENTRADA_BARRAS_CONTORNO_ESTRUCTURA,"ENTRADA_BARRAS_CONTORNO",ENTRADA_BARRAS_CONTORNO_CONTROL,ENTRADA_BARRAS_CONTORNO_GENERADOR,2)
    
    ENTRADA_BARRAS_PROPIEDADES = entrada(ENTRADA_BARRAS_PROPIEDADES_ESTRUCTURA,"ENTRADA_BARRAS_PROPIEDADES",ENTRADA_BARRAS_PROPIEDADES_CONTROL,ENTRADA_BARRAS_PROPIEDADES_GENERADOR,2)
    ENTRADA_NODOS_PUNTUAL = entrada(ENTRADA_NODOS_PUNTUAL_ESTRUCTURA,"ENTRADA_NODOS_PUNTUAL",ENTRADA_NODOS_PUNTUAL_CONTROL,ENTRADA_NODOS_PUNTUAL_GENERADOR,2)
    ENTRADA_BARRAS_DISTRIBUIDA = entrada(ENTRADA_BARRAS_DISTRIBUIDA_ESTRUCTURA,"ENTRADA_BARRAS_DISTRIBUIDA",ENTRADA_BARRAS_DISTRIBUIDA_CONTROL,ENTRADA_BARRAS_DISTRIBUIDA_GENERADOR,2)
    ENTRADA_EJECUTAR = entrada(ENTRADA_EJECUTAR_ESTRUCTURA,"ENTRADA_EJECUTAR",ENTRADA_EJECUTAR_CONTROL,ENTRADA_EJECUTAR_GENERADOR,2)

    ENTRADA_RESULTADOS_DFC = entrada(ENTRADA_RESULTADOS_DFC_ESTRUCTURA,"ENTRADA_RESULTADOS_DFC",ENTRADA_RESULTADOS_DFC_CONTROL,ENTRADA_RESULTADOS_DFC_GENERADOR,2)
    ENTRADA_RESULTADOS_DFC.memoria = {0,0}
    ENTRADA_RESULTADOS_DMF = entrada(ENTRADA_RESULTADOS_DMF_ESTRUCTURA,"ENTRADA_RESULTADOS_DMF",ENTRADA_RESULTADOS_DMF_CONTROL,ENTRADA_RESULTADOS_DMF_GENERADOR,2)
    ENTRADA_RESULTADOS_DMF.memoria = {0,0}
    
    --[[Datos de prueba 
    ENTRADA_NODOS.memoria = {{0,0},{3,3},{8,3},{10,1}}
    ENTRADA_BARRAS.memoria = {{1,2},{2,3},{3,4}}
    ENTRADA_NODOS_RESTRICCIONES.memoria = {{2,0},{1,0},{1,0},{2,0}}
    ENTRADA_BARRAS_CONTORNO.memoria = {{2},{3},{4}}
    ENTRADA_BARRAS_PROPIEDADES.memoria = {{10000,2,1},{10000,1,1},{10000,2,1}}
    ENTRADA_NODOS_PUNTUAL.memoria = {{0,0,0},{5,0,0},{0,0,0},{0,0,0}}
    ENTRADA_BARRAS_DISTRIBUIDA.memoria = {{0,0},{-2,-2},{0,0}}
    --]]
    --[[Datos de prueba 
    ENTRADA_NODOS.memoria = {{0,4},{4,4},{10,4},{13,0},{4,0},{4,2}}
    ENTRADA_BARRAS.memoria = {{1,2},{2,3},{3,4},{5,6},{6,2}}
    ENTRADA_NODOS_RESTRICCIONES.memoria = {{3,0},{1,0},{1,0},{2,0},{2,0},{1,0}}
    ENTRADA_BARRAS_CONTORNO.memoria = {{4},{4},{4},{4},{4}}
    ENTRADA_BARRAS_PROPIEDADES.memoria = {{10000,2,1},{10000,4,1},{10000,2,1},{10000,2,1},{10000,2,1}}
    ENTRADA_NODOS_PUNTUAL.memoria = {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{-8000,0,0}}
    ENTRADA_BARRAS_DISTRIBUIDA.memoria = {{0,0},{0,-6000},{0,0},{0,0},{0,0}}
    --]]
    
    estructuraMenu1_estado = nil
    estructuraMenu1_opciones1_estado = nil
    estructuraMenu1_opciones2_estado = nil
    estructuraMenu1_opciones3_estado = nil
    estructuraMenu1_opciones4_estado = nil
    estructuraMenu2_estado = nil
    estructuraMenu2_opciones1_estado = nil
    estructuraMenu3_estado = nil
    estructuraMenu3_opciones1_estado = nil
    estructuraMenu3_opciones2_estado = nil

end        

function on.paint(gc)
    gc:setFont("sansserif","r",7)
    MENU:paint(gc)
end

function on.tabKey()
    MENU:tabKey()
platform.window:invalidate()
end

function on.enterKey()
    ENTRADA_NODOS:enterKey()
    ENTRADA_BARRAS:enterKey()
    ENTRADA_NODOS_RESTRICCIONES:enterKey()
    ENTRADA_BARRAS_CONTORNO:enterKey()
    ENTRADA_BARRAS_PROPIEDADES:enterKey()  
    ENTRADA_NODOS_PUNTUAL:enterKey()
    ENTRADA_BARRAS_DISTRIBUIDA:enterKey()
    ENTRADA_EJECUTAR:enterKey()
    ENTRADA_RESULTADOS_DFC:enterKey()
    ENTRADA_RESULTADOS_DMF:enterKey()
    MENU:enterKey()
platform.window:invalidate()
end

function on.arrowDown()
    ENTRADA_NODOS:arrowDown()
    ENTRADA_BARRAS:arrowDown()
    ENTRADA_NODOS_RESTRICCIONES:arrowDown()
    ENTRADA_BARRAS_CONTORNO:arrowDown()
    ENTRADA_BARRAS_PROPIEDADES:arrowDown()  
    ENTRADA_NODOS_PUNTUAL:arrowDown()
    ENTRADA_BARRAS_DISTRIBUIDA:arrowDown()
    ENTRADA_RESULTADOS_DFC:arrowDown()
    ENTRADA_RESULTADOS_DMF:arrowDown()
    if CONTEXTO == "RESULTADOS_ANALITICOS" and MENU.estado[1] == false then
        poy = poy - 30
    end
    MENU:arrowDown()
platform.window:invalidate()
end

function on.arrowUp()
    ENTRADA_NODOS:arrowUp()
    ENTRADA_BARRAS:arrowUp()
    ENTRADA_NODOS_RESTRICCIONES:arrowUp()
    ENTRADA_BARRAS_CONTORNO:arrowUp()
    ENTRADA_BARRAS_PROPIEDADES:arrowUp()  
    ENTRADA_NODOS_PUNTUAL:arrowUp()
    ENTRADA_BARRAS_DISTRIBUIDA:arrowUp()
    ENTRADA_RESULTADOS_DFC:arrowUp()
    ENTRADA_RESULTADOS_DMF:arrowUp()
    if CONTEXTO == "RESULTADOS_ANALITICOS" and MENU.estado[1] == false then
        poy = poy + 30
    end
    MENU:arrowUp()
platform.window:invalidate()
end

function on.arrowRight()
    if CONTEXTO == "RESULTADOS_ANALITICOS" and MENU.estado[1] == false then
        pox = pox - 30
    end
platform.window:invalidate()
end

function on.arrowLeft()
    if CONTEXTO == "RESULTADOS_ANALITICOS" and MENU.estado[1] == false then
        pox = pox + 30
    end
platform.window:invalidate()
end


function on.charIn(char)
    ENTRADA_NODOS:charIn(char)
    ENTRADA_BARRAS:charIn(char)
    ENTRADA_NODOS_RESTRICCIONES:charIn(char)
    ENTRADA_BARRAS_CONTORNO:charIn(char)
    ENTRADA_BARRAS_PROPIEDADES:charIn(char)  
    ENTRADA_NODOS_PUNTUAL:charIn(char)
    ENTRADA_BARRAS_DISTRIBUIDA:charIn(char)
    if uChar == "d" then
        local n = tonumber(char) 
        if n then
            DECIMALES = n
        end
    else
        ENTRADA_RESULTADOS_DFC:charIn(char)
        ENTRADA_RESULTADOS_DMF:charIn(char)
    end
    uChar = char

platform.window:invalidate()
end

function on.backspaceKey()
    ENTRADA_NODOS:backspaceKey()
    ENTRADA_BARRAS:backspaceKey()
    ENTRADA_NODOS_RESTRICCIONES:backspaceKey()
    ENTRADA_BARRAS_CONTORNO:backspaceKey()
    ENTRADA_BARRAS_PROPIEDADES:backspaceKey()
    ENTRADA_NODOS_PUNTUAL:backspaceKey()
    ENTRADA_BARRAS_DISTRIBUIDA:backspaceKey()
    ENTRADA_RESULTADOS_DFC:backspaceKey()
    ENTRADA_RESULTADOS_DMF:backspaceKey()
platform.window:invalidate()
end


function centrarTextoW(gc,texto,y)
    gc:setFont("sansserif", "r", 7)
    local wt = gc:getStringWidth(texto)
    local ht = gc:getStringHeight(texto)
    gc:drawString(texto,W/2-wt/2,y)
end

function fondoMenuActivo(gc)
    local color = MENU.estado[1] and 0xF0F0F0 or 0xFFFFFF
    gc:setColorRGB(color)
    gc:fillRect(0,0,W,H)
end

function fondo_base(gc,x,y,contenido,inter)
    -- Limite entre ingreso de datos y grafico
    gc:setColorRGB(0XC8C8C8)
    gc:drawRect(-1,-1,80,213)
    -- Panel de instrucciones
    gc:setColorRGB(255,240,240)
    gc:fillRect(x,y,80,15)
    local color = MENU.estado[1] and {240,240,240} or {255,255,255}
    gc:setColorRGB(unpack(color))
    gc:fillRect(x,y+15,80,200)
    gc:setColorRGB(140,000,000)
    gc:setFont("sansserif","r",7)
    gc:drawString("▶ Instrucciones",x+4,y+2)    
    -- Contenido de instrucciones
    gc:setColorRGB(050,050,050)
    for i,k in ipairs(contenido) do
        gc:drawString(k,x+4,y+17+((i-1)*inter))
    end    
end

function fondo_base_resultados(gc,x,y,contenido,inter)
    -- Limite entre ingreso de datos y grafico
    gc:setColorRGB(0XC8C8C8)
    gc:drawRect(-1,-1,80,213)
    -- Panel de instrucciones
    gc:setColorRGB(200,200,200)
    gc:fillRect(x,y,80,15)
    local color = MENU.estado[1] and {240,240,240} or {255,255,255}
    gc:setColorRGB(unpack(color))
    gc:fillRect(x,y+15,80,200)
    gc:setColorRGB(050,050,050)
    gc:setFont("sansserif","r",7)
    gc:drawString("▶ Resultados",x+4,y+2)    
    -- Contenido de instrucciones
    gc:setColorRGB(050,050,050)
    for i,k in ipairs(contenido) do
        gc:drawString(k,x+4,y+17+((i-1)*inter))
    end    
end

function inicio(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "INICIO"
    gc:setFont("sansserif", "r", 7)
    gc:setColorRGB(255,86,87)
    gc:fillRect(125+11,80-10,68-22,14)
    gc:setColorRGB(255,255,255)
    centrarTextoW(gc,EMPRESA,81-10)
    centrarTextoW(gc,EMPRESA,81-10)
    --local logo = image.new(_R.IMG.tilove3)
    --gc:drawImage(logo,134,72)
    gc:setColorRGB(000,000,000)
    centrarTextoW(gc,SERVICIO_A,H/2-10-10+1)
    --centrarTextoW(gc,"0000000000",H/2-10-25+1)
    centrarTextoW(gc,SERVICIO_B,H/2-10+12-10+2)
    centrarTextoW(gc,VERSION,   H/2-10+24-10+3)
    centrarTextoW(gc,"presione [ tab ]",   H/2-10+24+20)
        
end

function nodos(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_NODOS"
    local contenido = {"Ingr. coord. (x,y) ", "desde  cerca  del", "origen,  hacia  el", "margen sup. izq.", "consid. x≥0, y≥0.", "Verif. estabilidad", "y   alineación  en", "cada nodo.", "Req.  mínimo de", "dos  nodos  para", "continuar."}
    fondo_base(gc,-1,85,contenido,9.5)
    -- Cuadros de entrada
    ENTRADA_NODOS:paint(gc)
    -- Grafico de sistema
    GRAFICO:nodos(gc)
    GRAFICO:datosNodos(gc)
    GRAFICO:etiquetasNodos(gc)
end

function barras(gc)
    -- El color del fondo cambiara si el menu esta activo
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_BARRAS"        
    local contenido = {"Ingr. nod. ( ni,nj ) ", "pa. crear la barra", "desde  cerca  del", "origen,  hacia  el", "margen sup. izq.", "Verif. estabilidad", "y   alineación  en", "cada barra.", "Req.  mínimo  de", "una   barra   para", "continuar."}
    fondo_base(gc,-1,85,contenido,9.5)
    -- Cuadros de entrada
    ENTRADA_BARRAS:paint(gc)
    -- Grafico de sistema
    GRAFICO:barras(gc)
    GRAFICO:etiquetasBarras(gc)
    GRAFICO:nodos(gc)
    GRAFICO:etiquetasNodos(gc)
end

function restricciones(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_NODOS_RESTRICCIONES"
    local contenido = {"Ingresa  nodo  n ", "tipo  de  apoyo S", "y angulo θ dond.,", "S = 1 → Libre", "S = 2 → Empot.", "S = 3 → Simple", "S = 4 → Rod. x", "S = 5 → Rod. y", "S = 6 → Z Rest", "S = 7 → x Libre", "S = 8 → Y Libre"}
    fondo_base(gc,-1,85,contenido,9.7)
    -- Cuadros de entrada
    ENTRADA_NODOS_RESTRICCIONES:paint(gc)
    -- Grafico de sistema
    GRAFICO:barras(gc)
    GRAFICO:nodos(gc)
    GRAFICO:etiquetasNodos(gc)
    GRAFICO:restriccionNodo(gc)
end

function contorno(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_BARRAS_CONTORNO"
    local contenido = {"Ingese el número", "de  barra  b  y  el", "tipo  de condición", "de contorno C:", "C = 1 :", "C = 2 :", "C = 3 :", "C = 4 :", "Donde:", "Por defecto, toda", "barra se conside-", "ra no  articulada."}
    fondo_base(gc,-1,65,contenido,10.5)
    local contornos = image.new(_R.IMG.contornos)
    gc:drawImage(contornos,36,128)
    -- Cuadros de entrada
    ENTRADA_BARRAS_CONTORNO:paint(gc)
    -- Grafico de sistema
    GRAFICO:barras(gc)
    GRAFICO:etiquetasBarras(gc)
    GRAFICO:contornoBarras(gc)
    GRAFICO:nodos(gc)
end

function barrasPropiedades(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_BARRAS_PROPIEDADES"
    local contenido = {
    "Ingrese  el  núm.", 
    "de  barra  b,  el", 
    "área  A,  la iner-", 
    "cia I y  el módu-", 
    "lo de elasticidad", 
    "E; Por defecto:", 
    "A = 10000, I = 1,", 
    "E = 1, tds. las b."}
    fondo_base(gc,-1,105,contenido,10.9)
    -- Cuadros de entrada
    ENTRADA_BARRAS_PROPIEDADES:paint(gc)
    -- Grafico de sistema
    GRAFICO:barras(gc)
    GRAFICO:etiquetasBarras(gc)
    GRAFICO:nodos(gc)
    GRAFICO:propiedadesBarras(gc)
end

function nodosPuntual(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_NODOS_PUNTUAL"
    local contenido = {
    "Ingrese  el  núm.", 
    "de  nodo  n,  la ", 
    "carga puntual en", 
    "x -> px, y -> py", 
    "y el momento m;", 
    "Considerando:", 
    "[ ↓ - ] [ → + ]  y", 
    "momento .a.h. +"
    }
    fondo_base(gc,-1,105,contenido,10.8)
    -- Cuadros de entrada
    ENTRADA_NODOS_PUNTUAL:paint(gc)
    -- Grafico de sistema
    GRAFICO:barras(gc)
    GRAFICO:puntualNodos(gc)
    GRAFICO:nodos(gc)
    GRAFICO:etiquetasNodos(gc)
end

function barrasDistribuida(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_BARRAS_DISTRIBUIDA"
    local contenido = {
    "Ingrese  el  núm.", 
    "de  barra -> b, la", 
    "carga distribuida, ", 
    "considetando: ", 
    "crg. inicial -> Wi", 
    "crg. final -> Wj", 
    "Además  del  án-", 
    "gulo  de  inclina-", 
    "ción θ; donde:", 
    "[ ↓↓- ] y θ.a.h.+."
    }
    fondo_base(gc,-1,85,contenido,10.7)
    -- Cuadros de entrada
    ENTRADA_BARRAS_DISTRIBUIDA:paint(gc)
    -- Grafico de sistema
    GRAFICO:distribuidaBarras(gc)
    GRAFICO:barras(gc)
    GRAFICO:etiquetasBarras(gc)
    GRAFICO:nodos(gc)
end

function ejecutar(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_EJECUTAR"
    local contenido = {
    'Antes de continu-',
    'ar,  confirme  la',
    'geometría  de los',
    'nodos  y  barras,',
    'revise las cargas,',
    'contornos y apoy.',
    'asignados, verifi-',
    'que las propieda-',
    'des físicas: área,',
    'inercia y módulo',
    'de elasticidad.',
    'De manera que se',
    'garantice la pre-',
    'cisión del análisis',
    'estructural.',
    'Presione [ enter ]'
    }
    fondo_base(gc,-1,25,contenido,10.5)
    -- Cuadros de entrada        
    ENTRADA_EJECUTAR:paint(gc)    
    -- Grafico de sistema
    GRAFICO:distribuidaBarras(gc)
    GRAFICO:barras(gc)
    GRAFICO:contornoBarras(gc)
    GRAFICO:etiquetasBarras(gc)
    --GRAFICO:propiedadesBarras(gc)
    GRAFICO:puntualNodos(gc)
    GRAFICO:nodos(gc)
    GRAFICO:restriccionNodo(gc)
end

function DFA(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_DFA"
    local contenido = {
    "En este diagrama",
    "se muestran las",
    "fuerzas axiales en",
    "cada barra de la",
    "estructura donde:",
    "Valor positivo:",
    "bar. está en ten-",
    "sión, [T].",
    "Valor negativo:",
    "bar. está en com-",
    "presión, [C].",
    "Elongándola  o a-",
    "cortándola  axial-",
    "mente.",
    "-----------",
    "Para  cambiar  el ",
    "número  de  deci-",
    "males   presione ",
    "[d] y luego algún",
    "[número]."
    }
    fondo_base_resultados(gc,-1,0,contenido,9.5)

    -- Grafico de sistema
    GRAFICO:DFA(gc)
    GRAFICO:barras(gc)
    GRAFICO:etiquetasBarras(gc)
    GRAFICO:nodos(gc)
    
    gc:setColorRGB(050,050,050)
    local titulo = "Diagrama de fuerzas axiales"
    local titulo_w = gc:getStringWidth(titulo)
    gc:drawString(titulo,80+237/2-titulo_w/2,2)
end

function DFC(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_RESULTADOS_DFC" 
    local n_barras = #RESULTADOS.datos.barra.conexion
    local contenido = {
    "Fuerza Cortante:",
    "Indica la intensi-",
    "dad de las fuerzas",
    "perpendiculares al",
    "eje longitudinal de",
    "las barras.",    
    "Núm. barras = "..n_barras,
    "-----------",
    "Para  cambiar  el ",
    "número  de  deci-",
    "males   presione ",
    "[d] y luego algún",
    "[número]."
    }
    fondo_base_resultados(gc,-1,65,contenido,9.5)
    gc:setColorRGB(050,050,050)
    -- Cuadros de entrada
    ENTRADA_RESULTADOS_DFC:paint(gc)
    -- Grafico de sistema
    local barra = ENTRADA_RESULTADOS_DFC.memoria[1]
    if barra == 0 then
        GRAFICO:DFC(gc)
        GRAFICO:barras(gc)
        GRAFICO:etiquetasBarras(gc)
        GRAFICO:nodos(gc)
    else
        GRAFICO:DFC_barra(gc)
    end
    gc:setColorRGB(050,050,050)
    local titulo = "Diagrama de fuerzas cortantes"
    local titulo_w = gc:getStringWidth(titulo)
    gc:drawString(titulo,80+237/2-titulo_w/2,2)
end

function DMF(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_RESULTADOS_DMF"
    local n_barras = #RESULTADOS.datos.barra.conexion
    local contenido = {
    "Momento Flector:",
    "Representa la",
    "tendencia de  las",
    "barras a doblarse",
    "o curvarse bajo la",
    "carga.",
    "Núm. barras = "..n_barras,
    "-----------",
    "Para  cambiar  el ",
    "número  de  deci-",
    "males   presione ",
    "[d] y luego algún",
    "[número]."
    }
    fondo_base_resultados(gc,-1,65,contenido,9.5)
    -- Cuadros de entrada
    ENTRADA_RESULTADOS_DMF:paint(gc)
    -- Grafico de sistema
    local barra = ENTRADA_RESULTADOS_DMF.memoria[1]
    if barra == 0 then
        GRAFICO:DMF(gc)
        GRAFICO:barras(gc)
        GRAFICO:etiquetasBarras(gc)
        GRAFICO:nodos(gc)
    else
        GRAFICO:DMF_barra(gc)
    end
    gc:setColorRGB(050,050,050)
    local titulo = "Diagrama de momentos flectores"
    local titulo_w = gc:getStringWidth(titulo)
    gc:drawString(titulo,80+237/2-titulo_w/2,2)
end

function desplazamiento(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_DESPLAZAMIENTO"
    local contenido = {
    "Esta grafica mu-",
    "estra los despla-",
    "zamientos noda.",
    "según el sistema",
    "de coordenadas",
    "global, donde:",
    "ux: Desplazam.",
    "en x horizontal.",
    "(hacia la der. +)",
    "uy: Desplazam.",
    "en y vertical.",
    "(hacia arriba +)",
    "gz: Rotación ex.",
    "en radianes.",
    "(anti-horario +).",
    "Para  cambiar  el ",
    "número  de  deci-",
    "males   presione ",
    "[d] y luego algún",
    "[número]."
    }
    fondo_base_resultados(gc,-1,0,contenido,9.5)
    --GRAFICO:etiquetasNodos(gc)
    GRAFICO:desplazamiento(gc)
    gc:setColorRGB(050,050,050)
    local titulo = "Desplazamientos"
    local titulo_w = gc:getStringWidth(titulo)
    gc:drawString(titulo,80+237/2-titulo_w/2,2)
end

function reacciones(gc)
    fondoMenuActivo(gc)
    gc:setFont("sansserif", "r", 7)
    CONTEXTO = "ENTRADA_REACCIONES"
    local contenido = {
    "Esta grafica mu-",
    "estra las reacc-",
    "ciones en nodos",
    "según el sistema",
    "de coordenadas",
    "global, donde:",
    "rx: Reacción",
    "en x horizontal.",
    "(hacia la der. +)",
    "ry: Reacción",
    "en y vertical.",
    "(hacia arriba +)",
    "mz: Reacción c.",
    "momento.",
    "(anti-horario +)",
    "-----------",
    "Para  cambiar  el ",
    "número  de  deci-",
    "males   presione ",
    "[d] y luego algún",
    "[número]."
    }
    fondo_base_resultados(gc,-1,0,contenido,9.5)

    GRAFICO:reacciones(gc)
    GRAFICO:barras(gc)
    GRAFICO:nodos(gc)
    GRAFICO:etiquetasNodos(gc)
    gc:setColorRGB(050,050,050)
    local titulo = "Reacciones"
    local titulo_w = gc:getStringWidth(titulo)
    gc:drawString(titulo,80+237/2-titulo_w/2,2)
end

function datos_generales(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 14
    
    local w = {} -- Almacena los anchos máximos de cada columna
    local titulo = {"  nodo  ","  coorde.  ","  fx  ","  fy  ","  mz  ","  rest.  ","  ang.  "}
    
    -- Calcular los anchos máximos de cada columna
    for j = 1, #titulo do
        w[j] = gc:getStringWidth(titulo[j])
    end
    -- Iterar sobre los datos para calcular los anchos máximos
    for i, coordenada in ipairs(nodo.coordenada) do
        local datos = {i, coordenada[1].." , "..coordenada[2], nodo.carga[i][1], nodo.carga[i][2], nodo.carga[i][3], nodo.restriccion[i][1], nodo.restriccion[i][2]}
        for j = 1, #datos do
            w[j] = math.max(w[j], gc:getStringWidth(datos[j]))
        end
    end
    -- Dibujar la tabla
    for i, coordenada in ipairs(nodo.coordenada) do
        local datos = {i, coordenada[1].." , "..coordenada[2], nodo.carga[i][1], nodo.carga[i][2], nodo.carga[i][3], nodo.restriccion[i][1], nodo.restriccion[i][2]}
        local xc = x
        gc:setFont("sansserif", "r", 7)
        for j = 1, #datos do
            if i == 1 then
                gc:setColorRGB(220,220,220)
                gc:drawRect(xc, y + (i - 1) * inter, w[j]+5, inter)
                local titulo_w = gc:getStringWidth(titulo[j])
                gc:setColorRGB(255, 150, 150)
                gc:drawString(titulo[j], xc + (w[j]+5) / 2 - titulo_w / 2 + 1, y + (i - 1) * inter + 2)
            end
            gc:setColorRGB(220,220,220)
            gc:drawRect(xc, y + (i) * inter, w[j]+5, inter)
            gc:setColorRGB(050,050,050)
            local datos_w = gc:getStringWidth(datos[j])
            gc:drawString(datos[j], xc + (w[j]+5) / 2 - datos_w / 2 + 1, y + i * inter + 2)
            xc = xc + w[j]+5
        end
    end
    
    local x = pox
    local y = y + (#nodo.coordenada+1)*inter+inter
    local inter = 14
    
    local w = {} -- Almacena los anchos máximos de cada columna
    local titulo = {"  barra  ","  ni - nj  ","  Wi - Wj  ","  contorno  ","  long.  ","  ang.  "}
    
    -- Calcular los anchos máximos de cada columna
    for j = 1, #titulo do
        w[j] = gc:getStringWidth(titulo[j])
    end
    -- Iterar sobre los datos para calcular los anchos máximos
    for i, conexion in ipairs(barra.conexion) do
        local datos = {i, conexion[1].." , "..conexion[2], barra.carga[i][1].." , "..barra.carga[i][2], tostring(barra.contorno[i][1]).." , "..tostring(barra.contorno[i][2]), string.format("%."..tostring(DECIMALES).."f",barra.longitud[i][1]), string.format("%."..tostring(DECIMALES).."f",barra.angulo[i][1])}
        for j = 1, #datos do
            w[j] = math.max(w[j], gc:getStringWidth(datos[j]))
        end
    end
    -- Dibujar la tabla
    for i, conexion in ipairs(barra.conexion) do
        local datos = {i, conexion[1].." , "..conexion[2], barra.carga[i][1].." , "..barra.carga[i][2],tostring(barra.contorno[i][1]).." , "..tostring(barra.contorno[i][2]), string.format("%."..tostring(DECIMALES).."f",barra.longitud[i][1]), string.format("%."..tostring(DECIMALES).."f",barra.angulo[i][1])}
        local xc = x
        gc:setFont("sansserif", "r", 7)
        for j = 1, #datos do
            if i == 1 then
                gc:setColorRGB(220,220,220)
                gc:drawRect(xc, y + (i - 1) * inter, w[j]+5, inter)
                local titulo_w = gc:getStringWidth(titulo[j])
                gc:setColorRGB(255, 150, 150)
                gc:drawString(titulo[j], xc + (w[j]+5) / 2 - titulo_w / 2 + 1, y + (i - 1) * inter + 2)
            end
            gc:setColorRGB(220,220,220)
            gc:drawRect(xc, y + (i) * inter, w[j]+5, inter)
            gc:setColorRGB(050,050,050)
            local datos_w = gc:getStringWidth(datos[j])
            gc:drawString(datos[j], xc + (w[j]+5) / 2 - datos_w / 2 + 1, y + i * inter + 2)
            xc = xc + w[j]+5
        end
    end
    
    local x = pox
    local y = y + (#nodo.coordenada+1)*inter
    local inter = 14
    
    local w = {} -- Almacena los anchos máximos de cada columna
    local titulo = {"  barra  ","  A  ","  I  ","  E  "}
    
    -- Calcular los anchos máximos de cada columna
    for j = 1, #titulo do
        w[j] = gc:getStringWidth(titulo[j])
    end
    -- Iterar sobre los datos para calcular los anchos máximos
    for i, conexion in ipairs(barra.conexion) do
        local datos = {i, string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][1]), string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][2]), string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][3]) }
        for j = 1, #datos do
            w[j] = math.max(w[j], gc:getStringWidth(datos[j]))
        end
    end
    -- Dibujar la tabla
    for i, conexion in ipairs(barra.conexion) do
        local datos = {i, string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][1]), string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][2]), string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][3]) }
        local xc = x
        gc:setFont("sansserif", "r", 7)
        for j = 1, #datos do
            if i == 1 then
                gc:setColorRGB(220,220,220)
                gc:drawRect(xc, y + (i - 1) * inter, w[j]+5, inter)
                local titulo_w = gc:getStringWidth(titulo[j])
                gc:setColorRGB(255, 150, 150)
                gc:drawString(titulo[j], xc + (w[j]+5) / 2 - titulo_w / 2 + 1, y + (i - 1) * inter + 2)
            end
            gc:setColorRGB(220,220,220)
            gc:drawRect(xc, y + (i) * inter, w[j]+5, inter)
            gc:setColorRGB(050,050,050)
            local datos_w = gc:getStringWidth(datos[j])
            gc:drawString(datos[j], xc + (w[j]+5) / 2 - datos_w / 2 + 1, y + i * inter + 2)
            xc = xc + w[j]+5
        end
    end
    
end

function imprimir_matriz(gc,mat,x,y,ni,nj,inter)
    gc:setFont("sansserif","r",7)    
    gc:setColorRGB(050,050,050)
    local temporal = {}
    local max_w = 0
    local valor
    for i = 1,#mat do -- fila
        temporal[i] = {}
        for k = 1, #mat do -- columna
            if type(mat[i][k]) == "number" then
                valor = string.format("%."..tostring(DECIMALES).."f",mat[i][k])
            else
                valor = mat[i][k]
            end
            temporal[i][k] = valor
            local tw = gc:getStringWidth(valor)
            max_w = math.max(max_w,tw)
        end
    end
    for i = 1,#temporal do -- fila
        for j = 1, #temporal do -- columna
            local valor = temporal[i][j]
            gc:drawString(valor, 15 + x + (j-1) * (max_w + 8), inter + y + (i-1) * inter)
        end 
    end
    local indice = {}
    if ni == 0 and nj == 0 then
        for i=1,#mat do
            table.insert(indice,i)
        end
    elseif ni == -1 and nj == -1 then
        for i=1,#RESULTADOS.gdl_libre do
            table.insert(indice,RESULTADOS.gdl_libre[i])
        end
    else
        for i=1,3 do
            table.insert(indice,(ni - 1) * 3 + i)
        end
        for i=1,3 do
            table.insert(indice,(nj - 1) * 3 + i)
        end
    end
    
    gc:setColorRGB(255,150,150)
    for i=1,#indice do
        gc:drawString(indice[i],15+x+(i-1)*(max_w+8),y)
    end
    for i=1,#indice do
        gc:drawString(indice[i],x,inter+y+(i-1)*inter)
    end
    local w = 15+(max_w+8)*(#temporal)
    local h = inter+(inter)*(#temporal)
    --gc:drawRect(x,y,w,h)
    return w,h
end

local function matriz_usada(ai,aj)
    local mat
    if not ai and not aj then
        mat = {
            {"E*A/L", "0", "0", "-E*A/L", "0", "0"}, 
            {"0", "12*E*I/L^3", "6*E*I/L^2", "0", "-12*E*I/L^3", "6*E*I/L^2"},
            {"0", "6*E*I/L^2", "4*E*I/L", "0", "-6*E*I/L^2", "2*E*I/L"}, 
            {"-E*A/L", "0", "0", "E*A/L", "0", "0"},
            {"0", "-12*E*I/L^3", "-6*E*I/L^2", "0", "12*E*I/L^3", "-6*E*I/L^2"},
            {"0", "6*E*I/L^2", "2*E*I/L", "0", "-6*E*I/L^2", "4*E*I/L"}
        }        
    elseif ai and not aj then
        mat = {
            {"E*A/L", "0", "0", "-E*A/L", "0", "0"},
            {"0", "3*E*I/L^3", "0", "0", "-3*E*I/L^3", "3*E*I/L^2"},
            {"0", "0", "0", "0", "0", "0"},
            {"-E*A/L", "0", "0", "E*A/L", "0", "0"},
            {"0", "-3*E*I/L^3", "0", "0", "3*E*I/L^3", "-3*E*I/L^2"},
            {"0", "3*E*I/L^2", "0", "0", "-3*E*I/L^2", "3*E*I/L"}
        }
    elseif not ai and aj then
        mat = {
            {"E*A/L", "0", "0", "-E*A/L", "0", "0"},
            {"0", "3*E*I/L^3", "3*E*I/L^2", "0", "-3*E*I/L^3", "0"},
            {"0", "3*E*I/L^2", "3*E*I/L", "0", "-3*E*I/L^2", "0"},
            {"-E*A/L", "0", "0", "E*A/L", "0", "0"},
            {"0", "-3*E*I/L^3", "-3*E*I/L^2", "0", "3*E*I/L^3", "0"},
            {"0", "0", "0", "0", "0", "0"}
        }
    elseif ai and aj then
        mat = {
            {"E*A/L", "0", "0", "-E*A/L", "0", "0"},
            {"0", "0", "0", "0", "0", "0"},
            {"0", "0", "0", "0", "0", "0"},
            {"-E*A/L", "0", "0", "E*A/L", "0", "0"},
            {"0", "0", "0", "0", "0", "0"},
            {"0", "0", "0", "0", "0", "0"}
        }
    end
    return mat
end 


function m_rig_local(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("k_local ( MATRIZ DE RIGIDEZ LOCAL ) :",x,y)
    local w,h = 0,0
    for i,conexion in ipairs(barra.conexion) do
        local nombre = "k_local[ "..i.." ] : "
        local nombre_w = gc:getStringWidth(nombre)
        local ni = conexion[1]
        local nj = conexion[2]
        local ai = barra.contorno[i][1]
        local aj = barra.contorno[i][2]
        local mw,mh = imprimir_matriz(gc,matriz_usada(ai,aj),x+nombre_w+5,y+(h)+inter*3,ni,nj,inter)
        local A = string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][1])
        local I = string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][2])
        local E = string.format("%."..tostring(DECIMALES).."f",barra.propiedad[i][3])
        local L = string.format("%."..tostring(DECIMALES).."f",barra.longitud[i][1])
        local propiedad = "A = "..A.." , I = "..I.." , E = "..E.." , L = "..L
        gc:setColorRGB(000,000,000)
        gc:drawString("Donde : "..propiedad,x+nombre_w+5,y+(h-1)+inter*2)
        gc:drawString(nombre,x,y+(h)+inter*3+mh/2)
        w = nombre_w + 5 + mw
        --
        local nombre = " = "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.k_local[i]
        local mw,mh = imprimir_matriz(gc,mat,w+x+nombre_w+5,y+(h)+inter*3,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*3+mh/2)
        --
        h = h + mh + inter*2
    end
end

function m_trans(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("t ( MATRIZ DE TRANSFORMACIÓN) :",x,y)
    local w,h = 0,0
    for i,conexion in ipairs(barra.conexion) do
        local nombre = "t [ "..i.." ] : "
        local nombre_w = gc:getStringWidth(nombre)
        local ni = conexion[1]
        local nj = conexion[2]
        local t_text = {
            {"cos(θ-βi)", "-sin(θ-βi)", "0", "0", "0", "0"},
            {"sin(θ-βi)", "cos(θ-βi)", "0", "0", "0", "0"},
            {"0", "0", "1", "0", "0", "0"},
            {"0", "0", "0", "cos(θ-βj)", "-sin(θ-βj)", "0"},
            {"0", "0", "0", "sin(θ-βj)", "cos(θ-βj)", "0"},
            {"0", "0", "0", "0", "0", "1"}
        }
        local mw,mh = imprimir_matriz(gc,t_text,x+nombre_w+5,y+(h)+inter*3,ni,nj,inter)
        local theta = string.format("%."..tostring(DECIMALES).."f",barra.angulo[i][1])
        local beta_i = string.format("%."..tostring(DECIMALES).."f",nodo.restriccion[ni][2])
        local beta_j = string.format("%."..tostring(DECIMALES).."f",nodo.restriccion[nj][2])
        local propiedad = "θ = "..theta.." , βi = "..beta_i.." , βj = "..beta_j
        gc:setColorRGB(000,000,000)
        gc:drawString("Donde : "..propiedad,x+nombre_w+5,y+(h-1)+inter*2)
        gc:drawString(nombre,x,y+(h)+inter*3+mh/2)
        w = nombre_w + 5 + mw
        --
        local nombre = " = "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.t[i]
        local mw,mh = imprimir_matriz(gc,mat,w+x+nombre_w+5,y+(h)+inter*3,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*3+mh/2)
        w = w + nombre_w + 5 + mw
        --
        local nombre = " t_tran. [ "..i.." ] : "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.t_traspuesta[i]
        local mw,mh = imprimir_matriz(gc,mat,w+x+nombre_w+5,y+(h)+inter*3,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*3+mh/2)
        --
        h = h + mh + inter*2
        w = 0
    end
end

function m_rig_global(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("k_global ( MATRIZ DE RIGIDEZ GLOBAL ) : [ k_global ] = [ t ][ k_local ][ t_t ]",x,y)
    local w,h = 0,0
    for i,conexion in ipairs(barra.conexion) do
        local nombre = "k_global[ "..i.." ] : "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.k_global[i]
        local ni = conexion[1]
        local nj = conexion[2]
        local mw,mh = imprimir_matriz(gc,mat,x+nombre_w+5,y+(h)+inter*1.5,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,x,y+(h)+inter*1.5+mh/2)
        h = h + mh + inter
    end
end

function m_ensamblada(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("K ( MATRIZ DE RIGIDEZ GLOBAL ENSAMBLADA ) : ",x,y)
    local nombre = "K : "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.k_global_ensamblada
    local mw,mh = imprimir_matriz(gc,mat,x+nombre_w+5,y+inter*2,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,x,y+inter*2+mh/2)
    local y = y+mh+inter*2+inter
    gc:drawString("KLL ( MATRIZ DE RIGIDEZ GLOBAL ENSAMBLADA ORDENADA) : ",x,y)
    gc:drawString("Donde: KLL = Rigidez en GDL Libres. ",x,y+inter)
    local nombre = "KLL : "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.KLL
    local mw,mh = imprimir_matriz(gc,mat,x+nombre_w+5,y+inter*3,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,x,y+inter*3+mh/2)
    local y = y+mh+inter*2+inter
    local nombre = "KLL^-1 : "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.KLL_
    local mw,mh = imprimir_matriz(gc,mat,x+nombre_w+5,y+inter*1,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,x,y+inter*1+mh/2)
end

function imprimir_vector(gc,mat,x,y,ni,nj,inter)
    gc:setFont("sansserif","r",7)    
    gc:setColorRGB(050,050,050)
    local temporal = {}
    local max_w = 0
    for i = 1, #mat do -- Ahora solo hay una dimensión principal
        local valor = string.format("%."..tostring(DECIMALES).."f", mat[i][1])
        temporal[i] = valor -- Almacenando el valor formateado directamente como un elemento del vector
        local tw = gc:getStringWidth(valor)
        max_w = math.max(max_w, tw)
    end
    
    for i = 1, #temporal do -- Dibuja cada valor en el vector
        local valor = temporal[i]
        gc:drawString(valor, 15 + x, inter + y + (i-1) * inter) -- Ajustando la posición x para alinear verticalmente
    end
    
    local indice = {}
    if ni == 0 and nj == 0 then
        for i=1,#mat do
            table.insert(indice,i)
        end
    elseif ni == -1 and nj == -1 then
        for i=1,#RESULTADOS.gdl_libre do
            table.insert(indice,RESULTADOS.gdl_libre[i])
        end
    else
        for i=1,3 do
            table.insert(indice,(ni - 1) * 3 + i)
        end
        for i=1,3 do
            table.insert(indice,(nj - 1) * 3 + i)
        end
    end
    gc:setColorRGB(255,150,150)
    for i=1,#indice do
        gc:drawString(indice[i],x,inter+y+(i-1)*inter)
    end
    local w = 15+(max_w+8)
    local h = inter+(inter)*(#temporal)
    return w,h
end


function v_fuerzas_ex(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("VECTOR DE FUERZAS EXTERNAS { R } = { R1 } - { R2 }",x,y)
    gc:drawString("Donde: { R1 } -> Fuerzas directas sobre los nodos.",x,y+inter*1)
    gc:drawString("           { R2 } -> Fuerzas transmitidas a los nodos (reacciones)",x,y+inter*2)
    gc:drawString("           { RLL } -> Fuerzas en GDL Libres.",x,y+inter*3)
    local w,h = 0,0
    local nombre = "R = "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.R1
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*3.5,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*3.5+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = "- "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.R2
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*3.5,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*3.5+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = "= "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.R
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*3.5,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*3.5+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = "-> RLL = "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.RLL
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*3.5,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*3.5+mh/2)

end

function v_desplazamiento(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("DLL ( VECTOR DE DESPLAZAMIENTO EN GDL LIBRES ) : { DLL } = [ KLL^-1 ]{ RLL }",x,y)
    gc:drawString("Donde: [ KLL^-1 ] -> Matriz inversa de KLL",x,y+inter*1)
    gc:drawString("           { RLL } -> Fuerzas en GDL Libres.",x,y+inter*2)
    local w,h = 0,0
    local nombre = "DLL = "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.KLL_
    local mw,mh = imprimir_matriz(gc,mat,w+x+nombre_w+5,y+(h)+inter*4,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*4+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = " * "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.RLL
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*4,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*4+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = " = "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.DLL
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*4,-1,-1,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*4+mh/2)
    h = mh
    w = 0
    local nombre = "D_local "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.D_local
    local mw,mh = imprimir_vector(gc,mat,x+nombre_w+5,y+(h)+inter*4,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,x,y+(h)+inter*4+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = " , D_global "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.D_global
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*4,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*4+mh/2)
end

function v_reacciones(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("Re ( VECTOR DE REACCIONES ) : { Re } = [ K ]{ D }+{ R }",x,y)
    gc:drawString("Donde: [ K ] -> Matriz de rigidez global ensamblada.",x,y+inter*1)
    gc:drawString("           { D } -> Vector de desplazamientos.",x,y+inter*2)
    gc:drawString("           { R } -> Vector de fuerzas externas.",x,y+inter*3)
    local w,h = 0,0
    local nombre = "Re_local "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.Re_local
    local mw,mh = imprimir_vector(gc,mat,x+nombre_w+5,y+(h)+inter*4,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,x,y+(h)+inter*4+mh/2)
    local w = w+nombre_w+5+mw
    local nombre = " , Re_global "
    local nombre_w = gc:getStringWidth(nombre)
    local mat = RESULTADOS.Re_global
    local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*4,0,0,inter)
    gc:setColorRGB(000,000,000)
    gc:drawString(nombre,w+x,y+(h)+inter*4+mh/2)
end

function v_esfuerzos(gc)
    fondoMenuActivo(gc)
    CONTEXTO = "RESULTADOS_ANALITICOS"
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local x = pox
    local y = poy
    local inter = 12
    gc:setColorRGB(000,000,000)
    gc:drawString("Qt ( VECTOR DE ESFUERZOS ACTUANTES ) : { Qr } = [ k_local ][ t_t ]{ d } + { r_local }",x,y)
    gc:drawString("Donde: [ k_local ] -> Matriz de rigidez local.",x,y+inter*1)
    gc:drawString("           [ t_t ] -> Matriz de transformación transpuesta.",x,y+inter*2)
    gc:drawString("           { d } -> Vector de desplazamiento (extraída de GDL correspondiente).",x,y+inter*3)
    gc:drawString("           { r_local } -> Vector de fuerzas externas (reacciones).",x,y+inter*4)
    local w,h = 0,0
    for i,conexion in ipairs(barra.conexion) do
        local nombre = "Qt [ "..i.." ] = "
        local nombre_w = gc:getStringWidth(nombre)
        local ni = conexion[1]
        local nj = conexion[2]
        local mat = RESULTADOS.k_local[i]
        local mw,mh = imprimir_matriz(gc,mat,x+nombre_w+5,y+(h)+inter*6,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,x,y+(h)+inter*6+mh/2)
        w = nombre_w + 5 + mw
        --
        local nombre = " * "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.t_traspuesta[i]
        local mw,mh = imprimir_matriz(gc,mat,w+x+nombre_w+5,y+(h)+inter*6,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*6+mh/2)
        w = w + nombre_w + 5 + mw
        --
        local nombre = " * "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.D_barra[i]
        local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*6,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*6+mh/2)
        w = w + nombre_w + 5 + mw
        --
        local nombre = " + "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.r2_local[i]
        local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*6,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*6+mh/2)
        w = w + nombre_w + 5 + mw
        --
        local nombre = " = "
        local nombre_w = gc:getStringWidth(nombre)
        local mat = RESULTADOS.Qt[i]
        local mw,mh = imprimir_vector(gc,mat,w+x+nombre_w+5,y+(h)+inter*6,ni,nj,inter)
        gc:setColorRGB(000,000,000)
        gc:drawString(nombre,w+x,y+(h)+inter*6+mh/2)
        w = w + nombre_w + 5 + mw
        --
        h = h + mh + inter
        w = 0
        --]]
    end
end

--[[
local datos = {
    nodo  = {
        coordenada  = ENTRADA_NODOS.memoria,
        restriccion = ENTRADA_NODOS_RESTRICCIONES.memoria,
        carga = ENTRADA_NODOS_PUNTUAL.memoria,
    },
    barra = {
        conexion =  ENTRADA_BARRAS.memoria,
        propiedad = ENTRADA_BARRAS_PROPIEDADES.memoria,
        contorno = contorno_adaptado,
        carga = ENTRADA_BARRAS_DISTRIBUIDA.memoria,
        longitud = {},
        angulo = {}
    }
}        
--]]
function nosotros(gc)
    CONTEXTO = "NOSOTROS"
    gc:setFont("sansserif","r",7)
    local contenido = {
        "AEM-RB (alias OpenRSE)",
        "Análisis Estructural Matricial de Reticulados Bidimensionales",
        "",
        "--------------------------------------------------",
        "Desarrollado por:",
        "   Alexander Rosas Placido",
        "   Universidad de Huánuco - Perú",
        "--------------------------------------------------",
        "",
        "Propósito:",
        "Esta es una herramienta de software libre con fines",
        "académicos para el análisis estructural en 2D.",
        "",
        "Aviso Importante:",
        "Los resultados generados dependen 100% de los",
        "datos ingresados por el usuario.",
        "",
        "El desarrollador no se hace responsable por el uso",
        "o la interpretación de los cálculos. Verifique siempre",
        "sus resultados por un medio independiente.",
    }
    local inter = 10.3
    for i = 1, #contenido do
        if (i >= 1 and i <= 2) or (i >= 4 and i <= 8) then 
            gc:setColorRGB(050,050,100) -- Color del título/créditos
        else
            gc:setColorRGB(080,080,080) -- Color del texto normal
        end
        gc:drawString(contenido[i],3,3+(i-1)*inter)
    end
end


ENTRADA_NODOS_ESTRUCTURA = {
    {nombre = "x", tipo = "cuadro", geometria = {5,5+20*0,48,15}, contenido = "--"},
    {nombre = "y", tipo = "cuadro", geometria = {5,5+20*1,48,15}, contenido = "--"},
    {nombre = "Guardar", tipo = "boton", geometria = {5,5+20*2,48,15}},
    {nombre = "Eliminar", tipo = "boton", geometria = {5,5+20*3,48,15}}
}

ENTRADA_NODOS_GENERADOR = function(tipo) 
    if tipo == "Guardar" then
        if #ENTRADA_NODOS.memoria > 1 then
            estructuraMenu[1].opciones[2].estado = true
            estructuraMenu[1].opciones[3].estado = true
            estructuraMenu[3].estado = true
            estructuraMenu[3].opciones[1].estado = true
        end
    elseif tipo == "Eliminar" then
        if #ENTRADA_NODOS.memoria < 2 then
            estructuraMenu[1].opciones[2].estado = false
            estructuraMenu[1].opciones[3].estado = false
            estructuraMenu[3].estado = false
            estructuraMenu[3].opciones[1].estado = false
        end
        ENTRADA_BARRAS.memoria = {}
        ENTRADA_NODOS_RESTRICCIONES.memoria = {} 
        ENTRADA_BARRAS_CONTORNO.memoria = {} 
        ENTRADA_BARRAS_PROPIEDADES.memoria = {} 
        ENTRADA_NODOS_PUNTUAL.memoria = {} 
        ENTRADA_BARRAS_DISTRIBUIDA.memoria = {}
        estructuraMenu[1].opciones[4].estado = false
        estructuraMenu[2].estado = false
        estructuraMenu[2].opciones[1].estado = false
        estructuraMenu[3].opciones[2].estado = false
    end 
    for i,k in ipairs(ENTRADA_NODOS.memoria) do
        ENTRADA_NODOS_RESTRICCIONES.memoria[i] = {1,0} 
        ENTRADA_NODOS_PUNTUAL.memoria[i] = {0,0,0}
    end
end

ENTRADA_NODOS_CONTROL = function(datos)
    local x, y = datos[1], datos[2]
    if x < 0 or y < 0 then
        return false
    end
    for _, par in ipairs(ENTRADA_NODOS.memoria) do
        if par[1] == x and par[2] == y then
            return false
        end
    end
    return true
end

ENTRADA_BARRAS_ESTRUCTURA = {
    {nombre = "n1", tipo = "cuadro", geometria = {5,5+20*0,48,15}, contenido = "--"},
    {nombre = "n2", tipo = "cuadro", geometria = {5,5+20*1,48,15}, contenido = "--"},
    {nombre = "Guardar", tipo = "boton", geometria = {5,5+20*2,48,15}},
    {nombre = "Eliminar", tipo = "boton", geometria = {5,5+20*3,48,15}}
}

ENTRADA_BARRAS_GENERADOR = function(tipo) -- ENTRADA_BARRAS
    function todosLosNodosConectados(nodos,barras)
        local totalNodos = #nodos.memoria
        local nodosConectados = {}
        for _, par in ipairs(barras.memoria) do
            nodosConectados[par[1]] = true
            nodosConectados[par[2]] = true
        end
        for id = 1, totalNodos do
            if not nodosConectados[id] then
                return false
            end
        end
        return true
    end            
    if tipo == "Guardar" then
        if todosLosNodosConectados(ENTRADA_NODOS, ENTRADA_BARRAS) then
            estructuraMenu[1].opciones[4].estado = true
            estructuraMenu[2].estado = true
            estructuraMenu[2].opciones[1].estado = true
            estructuraMenu[3].opciones[2].estado = true
        end
    elseif tipo == "Eliminar" then
        if not todosLosNodosConectados(ENTRADA_NODOS, ENTRADA_BARRAS) then
            estructuraMenu[1].opciones[4].estado = false
            estructuraMenu[2].estado = false
            estructuraMenu[2].opciones[1].estado = false
            estructuraMenu[3].opciones[2].estado = false
        end
    end 
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        ENTRADA_BARRAS_CONTORNO.memoria[i] = {4} 
        ENTRADA_BARRAS_PROPIEDADES.memoria[i] = {10000,1,1}
        ENTRADA_BARRAS_DISTRIBUIDA.memoria[i] = {0,0}
    end
end

ENTRADA_BARRAS_CONTROL = function(datos, memoria)
    local ni, nj = datos[1], datos[2]
    if ni == nj or ni <= 0 or nj <= 0 or ni > #ENTRADA_NODOS.memoria or nj > #ENTRADA_NODOS.memoria then
        return false
    end
    for _, par in ipairs(ENTRADA_BARRAS.memoria) do
        if (par[1] == ni and par[2] == nj) or (par[1] == nj and par[2] == ni) then
            return false
        end
    end
    return true
end

ENTRADA_NODOS_RESTRICCIONES_ESTRUCTURA = {
    {nombre = "n",        tipo = "cuadro", geometria = {5,5+20*0,45,14}, contenido = "--",  fondo = {255,255,255}},
    {nombre = "S",        tipo = "cuadro", geometria = {5,5+20*1,45,14}, contenido = "--",  fondo = {255,255,255}},
    {nombre = "θ",        tipo = "cuadro", geometria = {5,5+20*2,45,14}, contenido = "--",  fondo = {255,255,255}},
    {nombre = "Guardar",  tipo = "boton",  geometria = {5,5+20*3,45,14}, fondo = {255,255,255}},
}

ENTRADA_NODOS_RESTRICCIONES_GENERADOR = function(tipo) -- ENTRADA_NODOS_RESTRICCIONES
    if tipo == "Guardar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end 
end

ENTRADA_NODOS_RESTRICCIONES_CONTROL = function(datos)
    local n = datos[1]
    local S = datos[2]
    local ang = datos[2]
    if n <= 0 or S <= 0 or ang < 0 then
        return false
    end
    if n > #ENTRADA_NODOS.memoria then
        return false
    end
    if ang < 0 or ang > 360 then
        return false
    end
    if S < 1 or S > 8 then
        return false
    end
    return true
end
    
ENTRADA_BARRAS_CONTORNO_ESTRUCTURA = {
    {nombre = "b",        tipo = "cuadro", geometria = {5,5+20*0,45,14}, contenido = "--",  fondo = {255,255,255}},
    {nombre = "C",        tipo = "cuadro", geometria = {5,5+20*1,45,14}, contenido = "--",  fondo = {255,255,255}},
    {nombre = "Guardar",  tipo = "boton",  geometria = {5,5+20*2,45,14}, fondo = {255,255,255}},
}

ENTRADA_BARRAS_CONTORNO_GENERADOR = function(tipo)
    if tipo == "Guardar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    elseif tipo == "Eliminar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end 
end

ENTRADA_BARRAS_CONTORNO_CONTROL = function(datos, memoria)
    local b = datos[1]
    local C = datos[2]
    if b < 0 then
        return false
    end
    if C < 0 then
        return false
    end
    if b > #ENTRADA_BARRAS.memoria then
        return false
    end
    if C < 1 or C > 4 then
        return false
    end
    return true
end

ENTRADA_BARRAS_PROPIEDADES_ESTRUCTURA = {
        {tipo = "cuadro",  nombre = "b",         geometria = {5,5+20*0,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "A",         geometria = {5,5+20*1,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "I",         geometria = {5,5+20*2,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "E",         geometria = {5,5+20*3,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "boton",   nombre = "Guardar",   geometria = {5,5+20*4,45,14}, fondo = {255,255,255}},
}

ENTRADA_BARRAS_PROPIEDADES_GENERADOR = function(tipo)
    if tipo == "Guardar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    elseif tipo == "Eliminar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end 
end

ENTRADA_BARRAS_PROPIEDADES_CONTROL = function(datos)
    local b = datos[1]
    local A = datos[2]
    local I = datos[3]
    local E = datos[4]
    if b < 0 or b > #ENTRADA_BARRAS.memoria then
        return false
    end
    if A <= 0 or I <= 0 or E <= 0 then
        return false
    end        
    return true
end

ENTRADA_NODOS_PUNTUAL_ESTRUCTURA = {
        {tipo = "cuadro",  nombre = "n",         geometria = {5,5+20*0,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "px",        geometria = {5,5+20*1,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "py",        geometria = {5,5+20*2,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "m",         geometria = {5,5+20*3,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "boton",   nombre = "Guardar",   geometria = {5,5+20*4,45,14}, fondo = {255,255,255}},
}

ENTRADA_NODOS_PUNTUAL_GENERADOR = function(tipo)
    if tipo == "Guardar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    elseif tipo == "Eliminar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end 
end

ENTRADA_NODOS_PUNTUAL_CONTROL = function(datos)
    local n = datos[1]
    if n <= 0 or n > #ENTRADA_NODOS.memoria then
        return false
    end
    return true
end

ENTRADA_BARRAS_DISTRIBUIDA_ESTRUCTURA = {
        {tipo = "cuadro",  nombre = "b",         geometria = {5,5+20*0,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "Wi",        geometria = {5,5+20*1,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "Wj",        geometria = {5,5+20*2,45,14},    contenido = "--",  fondo = {255,255,255}},
        --{tipo = "cuadro",  nombre = "θ",         geometria = {5,5+20*3,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "boton",   nombre = "Guardar",   geometria = {5,5+20*3,45,14}, fondo = {255,255,255}},
}

ENTRADA_BARRAS_DISTRIBUIDA_GENERADOR = function(tipo)
    if tipo == "Guardar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    elseif tipo == "Eliminar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end 
end

ENTRADA_BARRAS_DISTRIBUIDA_CONTROL = function(datos, memoria)
    local b = datos[1]
    local wi = datos[2]
    local wj = datos[3]
    if b <= 0 or b > #ENTRADA_BARRAS.memoria then
        return false
    end
    if wi * wj < 0 then 
        return false
    end 
    return true
end
  
ENTRADA_EJECUTAR_ESTRUCTURA = {
    {tipo = "boton",   nombre = "Ejecut. análisis",   geometria = {-16,5+20*0,68,14}, fondo = {255,255,255}},
}

ENTRADA_EJECUTAR_GENERADOR = function(tipo)
    if tipo == "Ejecut. análisis" then
                
        estructuraMenu1_estado = estructuraMenu[1].estado
        estructuraMenu1_opciones1_estado = estructuraMenu[1].opciones[1].estado
        estructuraMenu1_opciones2_estado = estructuraMenu[1].opciones[2].estado
        estructuraMenu1_opciones3_estado = estructuraMenu[1].opciones[3].estado
        estructuraMenu1_opciones4_estado = estructuraMenu[1].opciones[4].estado
        estructuraMenu2_estado = estructuraMenu[2].estado
        estructuraMenu2_opciones1_estado = estructuraMenu[2].opciones[1].estado
        estructuraMenu3_estado = estructuraMenu[3].estado
        estructuraMenu3_opciones1_estado = estructuraMenu[3].opciones[1].estado
        estructuraMenu3_opciones2_estado = estructuraMenu[3].opciones[2].estado

        estructuraMenu[1].estado = false
        estructuraMenu[2].estado = false
        estructuraMenu[3].estado = false
        estructuraMenu[4].estado = false
        estructuraMenu[5].estado = true
        estructuraMenu[6].estado = true
        
        local contornos = {
            {true,true},
            {false,true},
            {true,false},
            {false,false}
        }
        local contorno_adaptado = {}
        for i,k in ipairs(ENTRADA_BARRAS.memoria) do
            local opcion = ENTRADA_BARRAS_CONTORNO.memoria[i][1]
            table.insert(contorno_adaptado,{contornos[opcion][1],contornos[opcion][2]})
        end
        local datos = {
            nodo  = {
                coordenada  = ENTRADA_NODOS.memoria,
                restriccion = ENTRADA_NODOS_RESTRICCIONES.memoria,
                carga = ENTRADA_NODOS_PUNTUAL.memoria,
            },
            barra = {
                conexion =  ENTRADA_BARRAS.memoria,
                propiedad = ENTRADA_BARRAS_PROPIEDADES.memoria,
                contorno = contorno_adaptado,
                carga = ENTRADA_BARRAS_DISTRIBUIDA.memoria,
                longitud = {},
                angulo = {}
            }
        }        
        RESULTADOS = analizar(datos)     
        
        MENU.controlEstado = false
        MENU.accion = {8,2}
        var.store("analisis",1)
    end
end

ENTRADA_EJECUTAR_CONTROL = function(datos)
    return true
end


ENTRADA_RESULTADOS_DFC_ESTRUCTURA = {
        {tipo = "cuadro",  nombre = "b",         geometria = {5,5+20*0,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "x",         geometria = {5,5+20*1,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "boton",   nombre = "Evaluar",   geometria = {5,5+20*2,45,14}, fondo = {255,255,255}},
}

ENTRADA_RESULTADOS_DFC_GENERADOR = function(tipo)
    if tipo == "Evaluar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end
end

ENTRADA_RESULTADOS_DFC_CONTROL = function(datos)
    local barra = RESULTADOS.datos.barra
    local b = datos[1]
    local x = datos[2]
    if b < 0 or b > #barra.conexion then
        return false
    end
    if b ~= 0 then
        if x < 0 or x > barra.longitud[b][1]  then
            return false
        end
    end
    return true
end

ENTRADA_RESULTADOS_DMF_ESTRUCTURA = {
        {tipo = "cuadro",  nombre = "b",         geometria = {5,5+20*0,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "cuadro",  nombre = "x",         geometria = {5,5+20*1,45,14},    contenido = "--",  fondo = {255,255,255}},
        {tipo = "boton",   nombre = "Evaluar",   geometria = {5,5+20*2,45,14}, fondo = {255,255,255}},
}

ENTRADA_RESULTADOS_DMF_GENERADOR = function(tipo)
    if tipo == "Evaluar" then
        -- No se requiere generar nada ya que este paso es no es relevante
    end
end

ENTRADA_RESULTADOS_DMF_CONTROL = function(datos)
    local barra = RESULTADOS.datos.barra
    local b = datos[1]
    local x = datos[2]
    if b < 0 or b > #barra.conexion then
        return false
    end
    if b ~= 0 then
        if x < 0 or x > barra.longitud[b][1] then
            return false
        end
    end
    return true
end
    
grafico = class()
    
function grafico:init(x,y,c)
    -- Limites de grafico
    self.x, self.y, self.c = x, y, c 
end

function grafico:dibujarTexto(gc,t,x,y,color)
    gc:setColorRGB(255,255,255)
    for i = -2, 2 do 
        gc:setFont("sansserif", "r", 7)
        gc:drawString(t,x+i,y) 
        gc:drawString(t,x,y+i)
    end 
    gc:setColorRGB(unpack(color))
    gc:drawString(t,x,y)      
end

function grafico:escalaNodosTotal()
    -- Inicializar valores para encontrar los extremos
    local min_x, max_x, min_y, max_y = math.huge, -math.huge, math.huge, -math.huge
    -- Iterar sobre todos los nodos para encontrar los valores extremos
    for _, nodo in ipairs(ENTRADA_NODOS.memoria) do
        min_x = math.min(min_x, nodo[1])
        max_x = math.max(max_x, nodo[1])
        min_y = math.min(min_y, nodo[2])
        max_y = math.max(max_y, nodo[2])
    end
    -- Calcular el rango y el factor de escala
    local range_x, range_y = max_x - min_x, max_y - min_y 
    local scale_factor = math.max(range_x, range_y) / self.c 
    -- Calcular los desplazamientos para centrar la visualización
    local offset_x = self.x + (self.c - range_x / scale_factor) / 2
    local offset_y = self.y + (self.c - range_y / scale_factor) / 2
    -- Retornar valores calculados
    return min_x, max_y, scale_factor, offset_x, offset_y
end

function grafico:rotarPoligono(poligono, xi, yi, angulo_grados)
    -- Convertir ángulo a radianes y precalcular seno y coseno
    local angulo_radianes = math.rad(-angulo_grados)
    local cos_angulo = math.cos(angulo_radianes)
    local sin_angulo = math.sin(angulo_radianes)
    local poligonoRotado = {}
    for i = 1, #poligono, 2 do
        local x = poligono[i]
        local y = poligono[i + 1]
        -- Aplicar la rotación utilizando seno y coseno precalculados
        local xr = xi + (x - xi) * cos_angulo - (y - yi) * sin_angulo
        local yr = yi + (x - xi) * sin_angulo + (y - yi) * cos_angulo
        table.insert(poligonoRotado, xr)
        table.insert(poligonoRotado, yr)
    end
    return poligonoRotado
end

function grafico:escalarNodo(x,y)
    local min_x, max_y, scale_factor, offset_x, offset_y = self:escalaNodosTotal()
    local xi = offset_x + (x - min_x) / scale_factor
    local yi = offset_y + (max_y - y) / scale_factor    
    return xi, yi
end

function grafico:nodos(gc)
    --gc:drawRect(self.x,self.y,self.c,self.c)
    if #ENTRADA_NODOS.memoria == 1 then 
        local x,y = self.x + self.c / 2,self.y + self.c / 2
        gc:setColorRGB(000,000,000)
        gc:fillRect(x-1,y-1,3,3)
    else      
        for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
            local xi,yi = nodo[1],nodo[2]
            local x,y = self:escalarNodo(xi,yi)
            gc:setColorRGB(000,000,000)
            gc:fillRect(x-1,y-1,3,3)
        end
    end
end

function grafico:datosNodos(gc)
    if #ENTRADA_NODOS.memoria == 1 then 
        local x,y = self.x + self.c / 2,self.y + self.c / 2
        local xi,yi = ENTRADA_NODOS.memoria[1][1],ENTRADA_NODOS.memoria[1][2]
        gc:setColorRGB(000,000,000)
        gc:setFont("sansserif","r",7)
        local t = "[ "..xi..","..yi.." ]"
        local tw = gc:getStringWidth(t)
        self:dibujarTexto(gc,t,x-tw/2+1,y+5,{000,000,000}) 
    else      
        for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
            local xi,yi = nodo[1],nodo[2]
            local x,y = self:escalarNodo(xi,yi)
            gc:setColorRGB(000,000,000)
            gc:setFont("sansserif","r",7)
            local t = "[ "..xi..","..yi.." ]"
            local tw = gc:getStringWidth(t) 
            self:dibujarTexto(gc,t,x-tw/2+1,y+5,{000,000,000}) 
        end
    end
end

function grafico:etiquetasNodos(gc)
    if #ENTRADA_NODOS.memoria == 1 then 
        local x,y = self.x + self.c / 2,self.y + self.c / 2
        gc:setColorRGB(000,000,000)
        gc:setFont("sansserif","r",7)
        local t = "1"
        local tw = gc:getStringWidth(t)
        self:dibujarTexto(gc,t,x-tw/2+1,y-15,{000,000,000}) 
    else      
        for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
            local xi,yi = nodo[1],nodo[2]
            local x,y = self:escalarNodo(xi,yi)
            gc:setColorRGB(000,000,000)
            gc:setFont("sansserif","r",7)
            local t = i
            local tw = gc:getStringWidth(t) 
            self:dibujarTexto(gc,t,x-tw/2+1,y-15,{000,000,000}) 
        end
    end
end

function grafico:barras(gc)
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni,nj = k[1],k[2]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2]) 
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2]) 
        gc:setColorRGB(150,150,150) 
        gc:drawLine(xi,yi,xj,yj)       
    end         
end

function grafico:etiquetasBarras(gc)
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni,nj = k[1],k[2]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2]) 
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2]) 
        local mx = (xi+xj)/2
        local my = (yi+yj)/2
        gc:setFont("sansserif", "r", 7)
        local t = i
        local tw = gc:getStringWidth(i)
        self:dibujarTexto(gc,t,mx-tw/2+2,my-6,{000,000,000}) 
    end         
end

function grafico:restriccionNodo(gc)
    for i,k in ipairs(ENTRADA_NODOS.memoria) do
        local xi,yi = k[1],k[2]
        local x,y = self:escalarNodo(xi,yi)
        local S = ENTRADA_NODOS_RESTRICCIONES.memoria[i][1]
        local tetha = ENTRADA_NODOS_RESTRICCIONES.memoria[i][2]
        if tonumber(S) ~= 1 then
            gc:setFont("sansserif","r",7)
            local S, Tetha= "S:"..S, "θ:"..tetha
            local wS,wTetha = gc:getStringWidth(S), gc:getStringWidth(Tetha)
            self:dibujarTexto(gc,S,x-wS/2,y+1,{255,100,100}) 
            self:dibujarTexto(gc,Tetha,x-wTetha/2,y+10,{255,100,100})     
        end  
    end
end

function grafico:contornoBarras(gc)
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local mapa = {{true,true},{false,true},{true,false},{false,false}}                    
        local tipo = ENTRADA_BARRAS_CONTORNO.memoria[i][1]
        local ci = mapa[tipo][1]
        local cj = mapa[tipo][2]
        local ni,nj = k[1],k[2]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2]) 
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2]) 
        local xm = (xi + xj) / 2
        local ym = (yi + yj) / 2
        local xmi, ymi = (xm + xi) / 2, (ym + yi) / 2
        local xmj, ymj = (xj + xm) / 2, (yj + ym) / 2
        local function dibujarRectangulo(x, y)
            gc:setColorRGB(255, 0, 255)
            gc:fillRect(x - 1, y - 1, 2, 2)
            gc:drawRect(x - 1, y - 1, 2, 2)
        end                    
        if ci then dibujarRectangulo((xmi + xi) / 2, (ymi + yi) / 2) end
        if cj then dibujarRectangulo((xj + xmj) / 2, (yj + ymj) / 2) end
    end
end

function grafico:propiedadesBarras(gc)
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni,nj = k[1],k[2]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2]) 
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2]) 
        local x,y = (xi + xj) / 2,(yi + yj) / 2
        local A = ENTRADA_BARRAS_PROPIEDADES.memoria[i][1]
        local I = ENTRADA_BARRAS_PROPIEDADES.memoria[i][2]
        local E = ENTRADA_BARRAS_PROPIEDADES.memoria[i][3]
        if tonumber(A) ~= 10000 or  tonumber(I) ~= 1 or tonumber(E) ~= 1 then
            gc:setFont("sansserif","r",7)
            local A, I, E= "A:"..A, "I:"..I, "E:"..E
            local wA,wI,wE = gc:getStringWidth(A), gc:getStringWidth(I), gc:getStringWidth(E)
            self:dibujarTexto(gc,A,x-wA/2,y+3,{000,000,000}) 
            self:dibujarTexto(gc,I,x-wI/2,y+12,{000,000,000}) 
            self:dibujarTexto(gc,E,x-wE/2,y+21,{000,000,000}) 
        end
    end
end

function grafico:puntualNodos(gc)
    for i,k in ipairs(ENTRADA_NODOS.memoria) do
        local xi,yi = k[1],k[2]
        local x,y = self:escalarNodo(xi,yi)
        local px = ENTRADA_NODOS_PUNTUAL.memoria[i][1]
        local py = ENTRADA_NODOS_PUNTUAL.memoria[i][2]
        local m  = ENTRADA_NODOS_PUNTUAL.memoria[i][3]
        gc:setColorRGB(255,100,100)
        if px>0 then
            local function flechaPositivo(x,y,t)
               gc:drawLine(x,y,x-15,y) 
               gc:drawLine(x,y,x-4,y-4) 
               gc:drawLine(x,y,x-4,y+4) 
               gc:setFont("sansserif","r",7)
               local t = math.abs(t)
               local tw = gc:getStringWidth(t)
               gc:drawString(t,x-15-tw-2,y-5)
            end
            flechaPositivo(x,y,px)
        elseif px<0 then
            local function flechaNegativo(x,y,t)
               gc:drawLine(x,y,x+15,y) 
               gc:drawLine(x,y,x+4,y-4) 
               gc:drawLine(x,y,x+4,y+4) 
               gc:setFont("sansserif","r",7)
               local t = math.abs(t)
               gc:drawString(t,x+15+4,y-5)
            end
            flechaNegativo(x,y,px)
        end
        if py>0 then
            local function flechaPositivo(x,y,t)
               gc:drawLine(x,y,x,y+15) 
               gc:drawLine(x,y,x-4,y+4) 
               gc:drawLine(x,y,x+4,y+4) 
               gc:setFont("sansserif","r",7)
               local t = math.abs(t)
               local tw = gc:getStringWidth(t)
               gc:drawString(t,x-tw/2+1,y+16)
            end
            flechaPositivo(x,y,py)
        elseif py<0 then
            local function flechaNegativo(x,y,t)
               gc:drawLine(x,y,x,y-15) 
               gc:drawLine(x,y,x-4,y-4) 
               gc:drawLine(x,y,x+4,y-4) 
               gc:setFont("sansserif","r",7)
               local t = math.abs(t)
               local tw = gc:getStringWidth(t)
               gc:drawString(t,x-tw/2+1,y-28)
            end
            flechaNegativo(x,y,py)
        end
        gc:setColorRGB(255,100,100)
        if m>0 then
            local function momentoPositivo(x,y,t)
                gc:drawArc(x-10,y-10,20,20,90,225)
                gc:fillArc(x+6,y+4,4,4,0,360)
                local t = math.abs(t)
                gc:drawString(t,x+10,y+8)
            end
            momentoPositivo(x,y,m)
        elseif m<0 then
            local function momentoNegativo(x,y,t)
                gc:drawArc(x-10,y-10,20,20,135,225)
                gc:fillArc(x-8,y-10,4,4,0,360)
                local t = math.abs(t)
                local tw = gc:getStringWidth(t)
                gc:drawString(t,x-5-tw-4,y-17)
            end
            momentoNegativo(x,y,m)
        end
    end
end

function grafico:distribuidaBarras(gc)
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni, nj = k[1], k[2]
        local xi, yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1], ENTRADA_NODOS.memoria[ni][2])
        local xj, yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1], ENTRADA_NODOS.memoria[nj][2])
        local wi, wj = ENTRADA_BARRAS_DISTRIBUIDA.memoria[i][1], ENTRADA_BARRAS_DISTRIBUIDA.memoria[i][2]
        local coordenadasNi, coordenadasNj = ENTRADA_NODOS.memoria[ni], ENTRADA_NODOS.memoria[nj]
        local dx, dy = coordenadasNj[1] - coordenadasNi[1], coordenadasNj[2] - coordenadasNi[2]
        local angulo_radianes = math.atan2(dy, dx)
        local angulo_grados = math.deg(angulo_radianes)
        angulo_grados = (angulo_grados < 0) and (angulo_grados + 360) or angulo_grados
        local p1 = (xj-xi)^2
        local p2 = (yj-yi)^2
        local long = math.sqrt(p1+p2)   
        local maxCargaGlobal = 0
        for _, cargas in ipairs(ENTRADA_BARRAS_DISTRIBUIDA.memoria) do
            local wi, wj = unpack(cargas)
            maxCargaGlobal = math.max(maxCargaGlobal, math.abs(wi), math.abs(wj))
        end
        local escala = 16 / maxCargaGlobal
        poligonoCarga = {xi+long,yi,xi+long,yi+(wj*escala),xi,yi+(wi*escala),xi,yi,}
        poligonoCargaRotada = self:rotarPoligono(poligonoCarga,xi,yi,angulo_grados)
        if wi ~= 0 or wj ~= 0 then 
            gc:setColorRGB(245, 245, 255)  
            gc:fillPolygon(poligonoCargaRotada)
            gc:setColorRGB(150, 150, 255)
            gc:drawPolyLine(poligonoCargaRotada)
            local xi_texto = poligonoCargaRotada[5]- gc:getStringWidth(math.abs(wi))/2
            local yi_texto = poligonoCargaRotada[6]- 7
            self:dibujarTexto(gc,math.abs(wi),xi_texto,yi_texto,{150, 150, 255}) 
            local xj_texto = poligonoCargaRotada[3]- gc:getStringWidth(math.abs(wj))/2
            local yj_texto = poligonoCargaRotada[4] - 7
            self:dibujarTexto(gc,math.abs(wj),xj_texto,yj_texto,{150, 150, 255}) 
        end
    end
end

function grafico:DFA(gc)
    local barra = RESULTADOS.datos.barra
    local nodo  = RESULTADOS.datos.nodo
    local resultados_abs = {}
    for i=1,#barra.conexion do
        local ax = math.abs(RESULTADOS.Qt[i][1][1])
        table.insert(resultados_abs,ax)
    end
    local maximo_abs = math.max(unpack(resultados_abs))
    for i,conexion in ipairs(barra.conexion) do
        -- Datos requeridos
        local ni, nj = conexion[1], conexion[2]
        local xi, yi = self:escalarNodo(nodo.coordenada[ni][1],nodo.coordenada[ni][2])
        local xj, yj = self:escalarNodo(nodo.coordenada[nj][1],nodo.coordenada[nj][2])
        local angulo_grados = barra.angulo[i][1]
        local longitud_escalado = math.sqrt((xj-xi)^2+(yj-yi)^2)
        -- se obtienen las fuerzas axiales
        local ax =  string.format("%."..tostring(DECIMALES).."f",RESULTADOS.Qt[i][1][1])
        -- Se grafican los resultados
        local escala = 16/maximo_abs
        local diagrama = {xi,yi,xi,yi+ax*escala,xi+longitud_escalado,yi+ax*escala,xi+longitud_escalado,yi}
        local diagrama_rotado = self:rotarPoligono(diagrama,xi,yi,angulo_grados)
        gc:setColorRGB(150, 150, 255)
        if tonumber(ax)~=0 then 
            gc:drawPolyLine(diagrama_rotado) 
            local x = (diagrama_rotado[3]+diagrama_rotado[5])/2-gc:getStringWidth(-ax)/2
            local y = (diagrama_rotado[4]+diagrama_rotado[6])/2-7
            self:dibujarTexto(gc,-ax,x,y,{100, 100, 255}) 
        else
            local x = (xi+xj)/2-gc:getStringWidth(0)/2
            local y = (yi+yj)/2-7
            self:dibujarTexto(gc,0,x,y,{100, 100, 255}) 
        end
    end
end

function grafico:DFC(gc)
    local nodo = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local resultados_abs = {}
    for i=1,#barra.conexion do
        local x_max = RESULTADOS.puntos_criticos_cortante[i][1]
        local x_min = RESULTADOS.puntos_criticos_cortante[i][2]
        local v_max = math.abs(RESULTADOS:fuerza_cortante(i,x_max))
        local v_min = math.abs(RESULTADOS:fuerza_cortante(i,x_min))
        local v = math.max(v_max,v_min)
        table.insert(resultados_abs,v)
    end
    local maximo_abs = math.max(unpack(resultados_abs))
    for i,conexion in ipairs(barra.conexion) do
        -- Datos requeridos
        local ni, nj = conexion[1], conexion[2]
        local xr, yr = nodo.coordenada[ni][1],nodo.coordenada[ni][2]
        local xi, yi = self:escalarNodo(nodo.coordenada[ni][1],nodo.coordenada[ni][2])
        local xj, yj = self:escalarNodo(nodo.coordenada[nj][1],nodo.coordenada[nj][2])
        local longitud_real = barra.longitud[i][1]
        local angulo_grados = barra.angulo[i][1]
        local longitud_escalado = math.sqrt((xj-xi)^2+(yj-yi)^2)
        -- Se obtiene los resultados de cortantes
        local vi = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(i,0))
        local vj = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(i,longitud_real))
        -- Se grafican los resultados
        local escala = 20/maximo_abs
        local diagrama = {xi,yi}
        local longitud_escala = longitud_escalado/longitud_real
        local paso = 10
        for x=0,longitud_real,paso/longitud_escala do
            local x_diagrama = x + xr
            local y_diagrama = -(RESULTADOS:fuerza_cortante(i,x)*escala) + yi
            local x_diagrama,p = self:escalarNodo(x_diagrama,y_diagrama)
            table.insert(diagrama,x_diagrama)
            table.insert(diagrama,y_diagrama)
        end
        local x_final = longitud_real + xr
        local y_final = -(RESULTADOS:fuerza_cortante(i,longitud_real)*escala) + yi
        local x_final,p = self:escalarNodo(x_final,y_final)
        table.insert(diagrama,x_final)
        table.insert(diagrama,y_final) 
        diagrama_rotado = self:rotarPoligono(diagrama,xi,yi,angulo_grados)
        gc:setColorRGB(150, 150, 255)
        table.insert(diagrama_rotado,xj)
        table.insert(diagrama_rotado,yj)
        if tonumber(vi)~=0 or tonumber(vj) ~= 0 or maximo_abs ~=0 then
            gc:drawPolyLine(diagrama_rotado)
            local xi_texto = diagrama_rotado[3]- gc:getStringWidth(vi)/2
            local yi_texto = diagrama_rotado[4]- 7
            self:dibujarTexto(gc,vi,xi_texto,yi_texto,{100, 100, 255}) 
            local xi_texto = diagrama_rotado[#diagrama_rotado-3]- gc:getStringWidth(vj)/2
            local yi_texto = diagrama_rotado[#diagrama_rotado-2]- 7
            self:dibujarTexto(gc,vj,xi_texto,yi_texto,{100, 100, 255}) 
        else
            local x = (xi+xj)/2-gc:getStringWidth(0)/2
            local y = (yi+yj)/2-7
            self:dibujarTexto(gc,0,x,y,{100, 100, 255}) 
        end
    end
end

function grafico:DFC_barra(gc)
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local barra_u = ENTRADA_RESULTADOS_DFC.memoria[1]
    local distancia_u = ENTRADA_RESULTADOS_DFC.memoria[2]
    -- Resulatos a peticion del usuario
    local x_u = string.format("%."..tostring(DECIMALES).."f",distancia_u)
    local v_u = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(barra_u,x_u))
    local datos = "x : "..x_u.."  v : "..v_u
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c/2-wdatos/2,self.y,{255,000,000}) 
    -- Se grafican los resultados en puntos notables
    local x_max = string.format("%."..tostring(DECIMALES).."f",RESULTADOS.puntos_criticos_cortante[barra_u][1])
    local x_min = string.format("%."..tostring(DECIMALES).."f",RESULTADOS.puntos_criticos_cortante[barra_u][2])
    local v_max = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(barra_u,x_max))
    local v_min = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(barra_u,x_min))
    local datos = "x min : "..x_min
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x,self.y+self.c-10,{050,050,050}) 
    local datos = "v min : "..v_min
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x,self.y+self.c,{050,050,050}) 
    local datos = "x max : "..x_max
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c-wdatos,self.y+self.c-10,{050,050,050}) 
    local datos = "v max : "..v_max
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c-wdatos,self.y+self.c,{050,050,050}) 
    -- Se grafican los resultados
    local xi, yi = self.x, self.y + self.c/2
    local xj, yj = self.x+self.c, self.y + self.c/2
    local v_abs = math.max(math.abs(v_max),math.abs(v_min))
    local longitud_real = barra.longitud[barra_u][1]
    local longitud_escalado = math.sqrt((xj-xi)^2+(yj-yi)^2)
    local escala = 50/v_abs
    local vi = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(barra_u,0))
    local vj = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:fuerza_cortante(barra_u,longitud_real))
    local diagrama = {xi,yi}
    local longitud_escala = longitud_escalado/longitud_real
    local paso = 10
    for x=0,longitud_real,paso/longitud_escala do
        local x_diagrama = x*longitud_escala + xi --xr
        local y_diagrama = -(RESULTADOS:fuerza_cortante(barra_u,x)*escala) + yi
        table.insert(diagrama,x_diagrama)
        table.insert(diagrama,y_diagrama)
    end
    local x_final = longitud_escalado + xi
    local y_final = -(RESULTADOS:fuerza_cortante(barra_u,longitud_real)*escala) + yi
    table.insert(diagrama,x_final)
    table.insert(diagrama,y_final) 
    table.insert(diagrama,xj)
    table.insert(diagrama,yj)
    gc:setColorRGB(150, 150, 255)
    if tonumber(vi)~=0 or tonumber(vj) ~= 0 or v_abs ~=0 then
        gc:drawPolyLine(diagrama)
        local xi_texto = diagrama[3]- gc:getStringWidth(vi)/2
        local yi_texto = diagrama[4]- 7
        self:dibujarTexto(gc,vi,xi_texto,yi_texto,{100, 100, 255}) 
        local xi_texto = diagrama[#diagrama-3]- gc:getStringWidth(vj)/2
        local yi_texto = diagrama[#diagrama-2]- 7
        self:dibujarTexto(gc,vj,xi_texto,yi_texto,{100, 100, 255}) 
    else
        local x = (xi+xj)/2-gc:getStringWidth(0)/2
        local y = (yi+yj)/2-7
        self:dibujarTexto(gc,0,x,y,{100, 100, 255}) 
    end
    -- Se grafican complementarios     
    gc:setColorRGB(100,100,100)
    gc:drawLine(xi,yi,xj,yj)
    -- Datos barra
    local mx = (xi+xj)/2
    local my = (yi+yj)/2
    gc:setFont("sansserif", "r", 7)
    local t = barra_u
    local tw = gc:getStringWidth(t)
    self:dibujarTexto(gc,t,mx-tw/2+2,my-13,{050,050,050}) 
    local t = "L : "..string.format("%."..tostring(DECIMALES).."f",longitud_real)
    local tw = gc:getStringWidth(t)
    self:dibujarTexto(gc,t,mx-tw/2+2,my+1,{050,050,050}) 
    -- Nodo
    gc:setColorRGB(000,000,000)
    gc:fillRect(xi-1,yi-1,3,3)
    gc:fillRect(xj-1,yj-1,3,3)
    gc:setFont("sansserif","r",7)
    local t = barra.conexion[barra_u][1]
    local tw = gc:getStringWidth(t) 
    self:dibujarTexto(gc,t,xi-tw-3,yi-7,{000,000,000}) 
    local t = barra.conexion[barra_u][2]
    local tw = gc:getStringWidth(t) 
    self:dibujarTexto(gc,t,xj+4,yj-7,{000,000,000}) 
    -- nodo x
    gc:setColorRGB(255,000,000)
    gc:fillRect(xi+x_u*longitud_escala-1,yi-1,3,3)
end

function grafico:DMF(gc)
    local nodo = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local resultados_abs = {}
    for i=1,#barra.conexion do
        local x_max = RESULTADOS.puntos_criticos_momento[i][1]
        local x_min = RESULTADOS.puntos_criticos_momento[i][2]
        local m_max = math.abs(RESULTADOS:momento_flector(i,x_max))
        local m_min = math.abs(RESULTADOS:momento_flector(i,x_min))
        local m = math.max(m_max,m_min)
        table.insert(resultados_abs,m)
    end
    local maximo_abs = math.max(unpack(resultados_abs))
    for i,conexion in ipairs(barra.conexion) do
        -- Datos requeridos
        local ni, nj = conexion[1], conexion[2]
        local xr, yr = nodo.coordenada[ni][1],nodo.coordenada[ni][2]
        local xi, yi = self:escalarNodo(nodo.coordenada[ni][1],nodo.coordenada[ni][2])
        local xj, yj = self:escalarNodo(nodo.coordenada[nj][1],nodo.coordenada[nj][2])
        local longitud_real = barra.longitud[i][1]
        local angulo_grados = barra.angulo[i][1]
        local longitud_escalado = math.sqrt((xj-xi)^2+(yj-yi)^2)
        -- Se obtiene los resultados de cortantes
        local mi = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:momento_flector(i,0))
        local mj = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:momento_flector(i,longitud_real))
        -- Se grafican los resultados
        local escala = 20/maximo_abs
        local diagrama = {xi,yi}
        local longitud_escala = longitud_escalado/longitud_real
        local paso = 10
        for x=0,longitud_real,paso/longitud_escala do
            local x_diagrama = x + xr
            local y_diagrama = -(RESULTADOS:momento_flector(i,x)*escala) + yi
            local x_diagrama,p = self:escalarNodo(x_diagrama,y_diagrama)
            table.insert(diagrama,x_diagrama)
            table.insert(diagrama,y_diagrama)
        end
        local x_final = longitud_real + xr
        local y_final = -(RESULTADOS:momento_flector(i,longitud_real)*escala) + yi
        local x_final,p = self:escalarNodo(x_final,y_final)
        table.insert(diagrama,x_final)
        table.insert(diagrama,y_final) 
        diagrama_rotado = self:rotarPoligono(diagrama,xi,yi,angulo_grados)
        gc:setColorRGB(150, 150, 255)
        table.insert(diagrama_rotado,xj)
        table.insert(diagrama_rotado,yj)
        if tonumber(mi)~=0 or tonumber(mj) ~= 0 or maximo_abs ~=0 then
            gc:drawPolyLine(diagrama_rotado)
            local xi_texto = diagrama_rotado[3]- gc:getStringWidth(-mi)/2
            local yi_texto = diagrama_rotado[4]- 7
            self:dibujarTexto(gc,-mi,xi_texto,yi_texto,{100, 100, 255}) 
            local xi_texto = diagrama_rotado[#diagrama_rotado-3]- gc:getStringWidth(-mj)/2
            local yi_texto = diagrama_rotado[#diagrama_rotado-2]- 7
            self:dibujarTexto(gc,-mj,xi_texto,yi_texto,{100, 100, 255}) 
        else
            local x = (xi+xj)/2-gc:getStringWidth(0)/2
            local y = (yi+yj)/2-7
            self:dibujarTexto(gc,0,x,y,{100, 100, 255}) 
        end
    end
end

function grafico:DMF_barra(gc)
    local nodo  = RESULTADOS.datos.nodo
    local barra = RESULTADOS.datos.barra
    local barra_u = ENTRADA_RESULTADOS_DMF.memoria[1]
    local distancia_u = ENTRADA_RESULTADOS_DMF.memoria[2]
    -- Resulatos a peticion del usuario
    local x_u = string.format("%."..tostring(DECIMALES).."f",distancia_u)
    local m_u = string.format("%."..tostring(DECIMALES).."f",-RESULTADOS:momento_flector(barra_u,x_u))
    local datos = "x : "..x_u.."  m : "..m_u
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c/2-wdatos/2,self.y,{255,000,000}) 
    -- Se grafican los resultados en puntos notables
    local x_max = string.format("%."..tostring(DECIMALES).."f",RESULTADOS.puntos_criticos_momento[barra_u][1])
    local x_min = string.format("%."..tostring(DECIMALES).."f",RESULTADOS.puntos_criticos_momento[barra_u][2])
    local m_max = string.format("%."..tostring(DECIMALES).."f",-RESULTADOS:momento_flector(barra_u,x_max))
    local m_min = string.format("%."..tostring(DECIMALES).."f",-RESULTADOS:momento_flector(barra_u,x_min))
    local datos = "x min : "..x_min
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x,self.y+self.c-10,{050,050,050}) 
    local datos = "m min : "..m_min
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x,self.y+self.c,{050,050,050}) 
    local datos = "x max : "..x_max
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c-wdatos,self.y+self.c-10,{050,050,050}) 
    local datos = "m max : "..m_max
    local wdatos = gc:getStringWidth(datos)
    self:dibujarTexto(gc,datos,self.x+self.c-wdatos,self.y+self.c,{050,050,050}) 
    -- Se grafican los resultados
    local xi, yi = self.x, self.y + self.c/2
    local xj, yj = self.x+self.c, self.y + self.c/2
    local m_abs = math.max(math.abs(m_max),math.abs(m_min))
    local longitud_real = barra.longitud[barra_u][1]
    local longitud_escalado = math.sqrt((xj-xi)^2+(yj-yi)^2)
    local escala = 50/m_abs
    local mi = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:momento_flector(barra_u,0))
    local mj = string.format("%."..tostring(DECIMALES).."f",RESULTADOS:momento_flector(barra_u,longitud_real))
    local diagrama = {xi,yi}
    local longitud_escala = longitud_escalado/longitud_real
    local paso = 10
    for x=0,longitud_real,paso/longitud_escala do
        local x_diagrama = x*longitud_escala + xi --xr
        local y_diagrama = -(RESULTADOS:momento_flector(barra_u,x)*escala) + yi
        table.insert(diagrama,x_diagrama)
        table.insert(diagrama,y_diagrama)
    end
    local x_final = longitud_escalado + xi
    local y_final = -(RESULTADOS:momento_flector(barra_u,longitud_real)*escala) + yi
    table.insert(diagrama,x_final)
    table.insert(diagrama,y_final) 
    table.insert(diagrama,xj)
    table.insert(diagrama,yj)
    gc:setColorRGB(150, 150, 255)
    if tonumber(mi)~=0 or tonumber(mj) ~= 0 or m_abs ~=0 then
        gc:drawPolyLine(diagrama)
        local xi_texto = diagrama[3]- gc:getStringWidth(-mi)/2
        local yi_texto = diagrama[4]- 7
        self:dibujarTexto(gc,-mi,xi_texto,yi_texto,{100, 100, 255}) 
        local xi_texto = diagrama[#diagrama-3]- gc:getStringWidth(-mj)/2
        local yi_texto = diagrama[#diagrama-2]- 7
        self:dibujarTexto(gc,-mj,xi_texto,yi_texto,{100, 100, 255}) 
    else
        local x = (xi+xj)/2-gc:getStringWidth(0)/2
        local y = (yi+yj)/2-7
        self:dibujarTexto(gc,0,x,y,{100, 100, 255}) 
    end
    -- Se grafican complementarios     
    gc:setColorRGB(100,100,100)
    gc:drawLine(xi,yi,xj,yj)
    -- Datos barra
    local mx = (xi+xj)/2
    local my = (yi+yj)/2
    gc:setFont("sansserif", "r", 7)
    local t = barra_u
    local tw = gc:getStringWidth(t)
    self:dibujarTexto(gc,t,mx-tw/2+2,my-13,{050,050,050}) 
    local t = "L : "..string.format("%."..tostring(DECIMALES).."f",longitud_real)
    local tw = gc:getStringWidth(t)
    self:dibujarTexto(gc,t,mx-tw/2+2,my+1,{050,050,050}) 
    -- Nodo
    gc:setColorRGB(000,000,000)
    gc:fillRect(xi-1,yi-1,3,3)
    gc:fillRect(xj-1,yj-1,3,3)
    gc:setFont("sansserif","r",7)
    local t = barra.conexion[barra_u][1]
    local tw = gc:getStringWidth(t) 
    self:dibujarTexto(gc,t,xi-tw-3,yi-7,{000,000,000}) 
    local t = barra.conexion[barra_u][2]
    local tw = gc:getStringWidth(t) 
    self:dibujarTexto(gc,t,xj+4,yj-7,{000,000,000}) 
    -- nodo x
    gc:setColorRGB(255,000,000)
    gc:fillRect(xi+x_u*longitud_escala-1,yi-1,3,3)
end

function grafico:desplazamiento(gc)
    local dx_datos = {}
    local dy_datos = {}
    for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
        local dx = RESULTADOS.D_global[(i-1)*3+1][1]
        local dy = RESULTADOS.D_global[(i-1)*3+2][1]
        table.insert(dx_datos,math.abs(dx))
        table.insert(dy_datos,math.abs(dy))
    end
    local dmaxx = math.max(unpack(dx_datos))
    local dmaxy = math.max(unpack(dy_datos))
    -- Verificar si el desplazamiento máximo es cero
    local escalax = dmaxx == 0 and 1 or 10/dmaxx
    local escalay = dmaxy == 0 and 1 or 10/dmaxy
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni,nj = k[1],k[2]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2]) 
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2]) 
        gc:setColorRGB(220,220,220) 
        gc:drawLine(xi,yi,xj,yj)       
    end         
    for i,k in ipairs(ENTRADA_BARRAS.memoria) do
        local ni,nj = k[1],k[2]
        local dxi = RESULTADOS.D_global[(ni-1)*3+1][1]
        local dyi = RESULTADOS.D_global[(ni-1)*3+2][1]
        local dxj = RESULTADOS.D_global[(nj-1)*3+1][1]
        local dyj = RESULTADOS.D_global[(nj-1)*3+2][1]
        local xi,yi = self:escalarNodo(ENTRADA_NODOS.memoria[ni][1],ENTRADA_NODOS.memoria[ni][2])
        local xj,yj = self:escalarNodo(ENTRADA_NODOS.memoria[nj][1],ENTRADA_NODOS.memoria[nj][2])
        local xi,yi = xi+dxi*escalax,yi-dyi*escalay
        local xj,yj = xj+dxj*escalax,yj-dyj*escalay
        gc:setColorRGB(100,100,100) 
        gc:drawLine(xi,yi,xj,yj)       
    end         
    for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
        local dx = RESULTADOS.D_global[(i-1)*3+1][1]
        local dy = RESULTADOS.D_global[(i-1)*3+2][1]
        local dz = RESULTADOS.D_global[(i-1)*3+3][1]
        local xi,yi = nodo[1],nodo[2]
        local x,y = self:escalarNodo(xi,yi)
        local x,y = x+dx*escalax,y-dy*escalay
        gc:setColorRGB(000,000,000)
        gc:fillRect(x-1,y-1,3,3)
        if dx~=0 or dy~=0 or dz~=0 then
            dx = "ux:"..string.format("%."..tostring(DECIMALES).."f",dx)
            dy = "uy:"..string.format("%."..tostring(DECIMALES).."f",dy)
            dz = "gz:"..string.format("%."..tostring(DECIMALES).."f",dz)
            self:dibujarTexto(gc,dx,x-gc:getStringWidth(dx)/2+1,y+2,{100, 100, 255}) 
            self:dibujarTexto(gc,dy,x-gc:getStringWidth(dy)/2+1,y+11+2,{100, 100, 255}) 
            self:dibujarTexto(gc,dz,x-gc:getStringWidth(dz)/2+1,y+22+2,{100, 100, 255}) 
        end
    end
end

function grafico:reacciones(gc)
    local tolerancia = 1e-8 
    for i, nodo in ipairs(ENTRADA_NODOS.memoria) do
        local rx = RESULTADOS.Re_global[(i-1)*3+1][1]
        local ry = RESULTADOS.Re_global[(i-1)*3+2][1]
        local rz = RESULTADOS.Re_global[(i-1)*3+3][1]
        local xi, yi = nodo[1], nodo[2]
        local x, y = self:escalarNodo(xi, yi)
        if math.abs(rx) > tolerancia or math.abs(ry) > tolerancia or math.abs(rz) > tolerancia then
            rx = "rx:" .. string.format("%." .. tostring(DECIMALES) .. "f", rx)
            ry = "ry:" .. string.format("%." .. tostring(DECIMALES) .. "f", ry)
            rz = "mz:" .. string.format("%." .. tostring(DECIMALES) .. "f", rz)
            self:dibujarTexto(gc, rx, x - gc:getStringWidth(rx) / 2 + 1, y + 2, {100, 100, 255})
            self:dibujarTexto(gc, ry, x - gc:getStringWidth(ry) / 2 + 1, y + 11 + 2, {100, 100, 255})
            self:dibujarTexto(gc, rz, x - gc:getStringWidth(rz) / 2 + 1, y + 22 + 2, {100, 100, 255})
        end
    end
end

entrada = class()
    
function entrada:init(cuadros,contexto,control,generador,tipo)
    self.cuadros  = cuadros
    self.contexto = contexto
    self.control = control
    self.tipo = tipo
    self.generador = generador
    self.cursor = 1
    self.memoria = {}
end

function entrada:paint(gc)
    if self.contexto ~= CONTEXTO then return end
    gc:setFont("sansserif", "r", 7)
    for i, k in ipairs(self.cuadros) do
        local x, y, w, h = unpack(k.geometria)
        local colorBorde = i == self.cursor and {240, 0, 0} or {100, 100, 100}
        local contenidoCentrado, texto
        gc:setColorRGB(unpack(colorBorde))
        gc:drawRect(x + 21, y, w, h)
        if k.tipo == "cuadro" then
            texto = k.nombre
            contenidoCentrado = k.contenido
        elseif k.tipo == "boton" then
            texto = k.nombre
        end
        -- Dibujar texto común y contenido centrado
        gc:setColorRGB(0, 0, 0)
        if k.tipo == "cuadro" then
            gc:setFont("sansserif", "r", 7)
            gc:drawString(texto, x, y + 2)
            gc:drawString(":",x+13, y + 2)
            local wt = gc:getStringWidth(contenidoCentrado)
            gc:drawString(contenidoCentrado, (x + 21) + w / 2 - wt / 2 + 1, y + 3)
        else  -- para botones y cualquier otro tipo que solo necesita centrar el nombre
            gc:setFont("sansserif", "r", 7)
            local wt = gc:getStringWidth(texto)
            gc:drawString(texto, (x + 21) + w / 2 - wt / 2 + 1, y + 3)
        end
    end
end

function entrada:arrowDown()
    if self.contexto == CONTEXTO and MENU.estado[1] == false  then
        if self.cursor < #self.cuadros then
            self.cursor = self.cursor + 1
        end
    end
end

function entrada:arrowUp()
    if self.contexto == CONTEXTO and MENU.estado[1] == false  then
        if self.cursor > 1 then
            self.cursor = self.cursor - 1
        end
    end
end

function entrada:charIn(char)
    if self.contexto == CONTEXTO and MENU.estado[1] == false  then
        local cuadro = self.cuadros[self.cursor]
        if cuadro.tipo == "cuadro" then
            -- Verificar si el contenido es "--" y reemplazarlo por una cadena vacía
            if cuadro.contenido == "--" then
                cuadro.contenido = ""
            end
            -- Verificar si el carácter es un dígito numérico, un punto decimal o un símbolo negativo
            if char:match("[%e%d%.%-]") and #cuadro.contenido < 11 then
                -- Verificar si el carácter es un punto decimal y si ya existe uno en el contenido
                if char == "." and cuadro.contenido:find("%.") then
                    return
                end
                if char == "e" and cuadro.contenido:find("%e") then
                    return
                end
                -- Verificar si el carácter es un símbolo negativo y si ya existe uno en el contenido
                if char == "-" and cuadro.contenido:find("^%-") then
                    return
                end
                -- Permitir el símbolo negativo solo al inicio del contenido
                if char == "-" and #cuadro.contenido > 0 then
                    return
                end
                -- Concatenar el carácter al contenido del cuadro
                cuadro.contenido = cuadro.contenido .. char
            end
        end
    end
end

function entrada:backspaceKey()
    if self.contexto == CONTEXTO and MENU.estado[1] == false  then
        local cuadro = self.cuadros[self.cursor]
        if cuadro.tipo == "cuadro" then
            -- Verificar si el contenido del cuadro no está vacío y no es igual a "--"
            if cuadro.contenido ~= "" and cuadro.contenido ~= "--" then
                -- Eliminar el último carácter del contenido
                cuadro.contenido = string.sub(cuadro.contenido, 1, #cuadro.contenido - 1)
                -- Si el contenido queda vacío, restaurar a "--"
                if cuadro.contenido == "" then
                    cuadro.contenido = "--"
                end
            end
        end
    end
end

function entrada:enterKey()
    if self.contexto == CONTEXTO and MENU.estado[1] == false then
        local cuadro = self.cuadros[self.cursor]
        if cuadro.tipo == "boton" then
            if cuadro.nombre == "Guardar" then
                -- Guardar el contenido de los cuadros en la memoria
                local conteo = {}
                local contenidoValido = true
                for _, k in ipairs(self.cuadros) do
                    if k.tipo == "cuadro" then
                        if k.contenido == "" or k.contenido == "--" or k.contenido == "-" or k.contenido == "." then
                            contenidoValido = false
                            break
                        else
                            table.insert(conteo, tonumber(k.contenido))
                            -- Restablecer el contenido de los cuadros a "--"
                            k.contenido = "--"
                        end
                    end
                end
                if contenidoValido then
                    -- Añadimos verifiaciones adicionales
                    if self.control(conteo) then -- si llega fpor tualse hay un error
                        if self.tipo == 2 then
                            local id,parte = conteo[1],{}
                            for i = 2,#conteo do table.insert(parte,conteo[i]) end
                            if id == 0 then 
                                for i=1,#self.memoria do
                                    self.memoria[i] =  parte
                                end
                            else
                                self.memoria[id] =  parte
                            end
                            self.generador(cuadro.nombre)
                        elseif self.tipo == 1 then
                            table.insert(self.memoria,conteo)
                            self.generador(cuadro.nombre)
                        end
                    end
                    self.cursor = 1
                end
            elseif cuadro.nombre == "Eliminar" then
                -- Eliminar el último grupo de datos ingresados en self.memoria
                if #self.memoria >= 0 then
                    if self.tipo == 2 then
                        -- En este caso no existiria [eliminar], ya que solo se debe reemplazar
                        -- los datos con guardar
                    elseif self.tipo == 1 then
                        table.remove(self.memoria)
                        self.generador(cuadro.nombre)
                    end
                end
            elseif cuadro.nombre == "Ejecut. análisis" then
                self.generador(cuadro.nombre)                   
            elseif cuadro.nombre == "Evaluar" then
                -- Guardar el contenido de los cuadros en la memoria
                local conteo = {}
                local contenidoValido = true
                for _, k in ipairs(self.cuadros) do
                    if k.tipo == "cuadro" then
                        if k.contenido == "" or k.contenido == "--" or k.contenido == "-" or k.contenido == "." then
                            contenidoValido = false
                            break
                        else
                            table.insert(conteo, tonumber(k.contenido))
                            -- Restablecer el contenido de los cuadros a "--"
                            k.contenido = "--"
                        end
                    end
                end
                if contenidoValido then
                    -- Añadimos verifiaciones adicionales
                    if self.control(conteo) then -- si llega fpor tualse hay un error
                        self.memoria = conteo
                        self.generador(cuadro.nombre)
                    end
                    self.cursor = 1
                end
            end
        end
    end
end

menu = class()

function menu:init(menu,control)
    self.menu = menu
    self.control = control
    self.controlEstado = true
    self.cursor = {1,1}
    self.cursor[1] = self:primeraOpcionHabilitada(self.menu)
    self.cursor[2] = self:primeraOpcionHabilitada(self.menu[self.cursor[1]].opciones)
    self.accion = {8,2}
    self.estado = {false,false}
    self.ancho = 90
    self.alto = 15  
end

function menu:paint(gc)
    if self.controlEstado then
        self.control()
    end
    self.menu[self.accion[1]].opciones[self.accion[2]].accion(gc)        
    local function graficar(indice, submenu)
        local desface_x = submenu and self.ancho or 0
        local desface_y_base = submenu and self.alto * (self.cursor[1] - 1) or 0
        for i, k in ipairs(indice) do
            local y_pos = -1 + (i - 1) * self.alto + desface_y_base
            --local icono = image.new(k.icono)
            gc:setColorRGB(255, 255, 255)
            gc:fillRect(-1 + desface_x, y_pos, self.ancho, self.alto)
            local cursor = submenu and self.cursor[2] or self.cursor[1]
            if i == cursor then
                gc:setColorRGB(0Xf0f0f0)
                gc:fillRect(-1 + desface_x, y_pos, self.ancho, self.alto)
                gc:setColorRGB(200, 0, 0)
                gc:setFont("sansserif", "r", 7)
                gc:drawString("▶", desface_x + self.ancho - 9, 3 + y_pos)
            end
            gc:setColorRGB(255,255,255)
            gc:drawRect(-1 + desface_x, y_pos, self.ancho, self.alto)
            gc:setColorRGB(000,000,000)
            gc:setFont("sansserif", "r", 7)
            gc:drawString(i,4 + desface_x, 2 + y_pos)
            --gc:drawImage(icono, 2 + desface_x, 3 + y_pos)
            gc:setColorRGB(k.estado and 0 or 150, k.estado and 0 or 150, k.estado and 0 or 150)
            gc:setFont("sansserif", "r", 7)
            gc:drawString(k.nombre, 14 + desface_x, 2 + y_pos)
            if i == #indice then
            gc:setColorRGB(0XC8C8C8)
            gc:drawRect(-1 + desface_x, -1 + desface_y_base, self.ancho, self.alto * i)
            end
        end
    end
    if self.estado[1] then
        gc:setFont("sansserif", "r", 7)
        graficar(self.menu, false)
        if self.estado[2] then    
            gc:setFont("sansserif", "r", 7)
            graficar(self.menu[self.cursor[1]].opciones, true)
        end
    end
end

function menu:tabKey()
    if PROGRAMA_ACTIVO then
        self.estado[1] = not self.estado[1]
        self.estado[2] = false -- Siempre desactivar el segundo estado cuando se presiona Tab.
        if self.estado[1] then
            self.cursor[1] = self:primeraOpcionHabilitada(self.menu)
            self.cursor[2] = self:primeraOpcionHabilitada(self.menu[self.cursor[1]].opciones)
        end
    end
end

function menu:enterKey()
    if self.estado[1] and not self.estado[2] then
        self.estado[2] = true
    elseif self.estado[1] and self.estado[2] then
        self.accion[1] = self.cursor[1]
        self.accion[2] = self.cursor[2]
        self.estado[1] = false
        self.estado[2] = false
        self.cursor[1] = self:primeraOpcionHabilitada(self.menu)
        self.cursor[2] = self:primeraOpcionHabilitada(self.menu[self.cursor[1]].opciones)
        pox = 5
        poy = 5
    end
end

function menu:primeraOpcionHabilitada(opciones)
    for index, opcion in ipairs(opciones) do
        if opcion.estado then
            return index
        end
    end
    return 1
end

function menu:arrowDown()
    local cursorIndex, options, limit
    if self.estado[2] then
        cursorIndex = self.cursor[2]
        options = self.menu[self.cursor[1]].opciones
        limit = #options
    elseif self.estado[1] then
        cursorIndex = self.cursor[1]
        options = self.menu
        limit = #options
    else
        return
    end
    cursorIndex = cursorIndex + 1
    while cursorIndex <= limit and not options[cursorIndex].estado do
        cursorIndex = cursorIndex + 1
    end
    if cursorIndex > limit then
        cursorIndex = cursorIndex - 1
        while cursorIndex > 0 and not options[cursorIndex].estado do
            cursorIndex = cursorIndex - 1
        end
    end
    self.cursor[self.estado[2] and 2 or 1] = cursorIndex
end

function menu:arrowUp()
    local cursorIndex
    if self.estado[2] then
        cursorIndex = self.cursor[2]
        options = self.menu[self.cursor[1]].opciones
    elseif self.estado[1] then
        cursorIndex = self.cursor[1]
        options = self.menu
    else
        return
    end
    if cursorIndex > self:primeraOpcionHabilitada(options) then
        cursorIndex = cursorIndex - 1
    end
    while cursorIndex > 0 and not options[cursorIndex].estado do
        cursorIndex = cursorIndex - 1
    end
    self.cursor[self.estado[2] and 2 or 1] = cursorIndex
end

analizar = class()

function analizar:init(datos)

    self.datos = datos
    
    -- CALCULOS INICIALES
    self:calcular_longitud_angulo_barra()
    
    -- CALCULO PRINCIPALES
    self.k_local = {}              self:calcular_k_local() 
    
    self.t = {}                    self:calcular_t()
    self.t_traspuesta = {}         self:calcular_t_traspuesta()
    self.k_global = {}             self:calcular_k_global()
    self.k_global_ensamblada = {}  self:calcular_k_global_ensamblada()
    
    
    self.gdl_libre = {}
    self.gdl_restringido = {}
    self.gdl_articulado = {}             
    self:clasificar_gdl()

    self.KLL = {}
    self.KLR = {}
    self.KRL = {}
    self.KRR = {}                        
    self:ordenar_k_global_ensamblada()
 
    self.R1 = {}         
    self:ensamblar_R1()
        
    self.r2_local = {}
    self.r2_global = {}
    self.R2 = {}         
    self:ensamblar_R2()
    
    self.R = {}   self:calcular_R()
    self.RLL = {} self:reducir_R()
    
    self.KLL_ = {} -- KLL inversa
    self.DLL = {}       self:calcular_vector_desplzamiento_gdl_libre()
    self.D_barra = {}
    self.D_local = {}   self:calcular_vector_desplazamiento_local()
    self.D_global = {}  self:calcular_vector_desplazamiento_global()
        
    self.Re_local = {}  self:calcular_vector_reaccion_local()
    self.Re_global = {} self:calcular_vector_reaccion_global()
       
    self.Qt = {}        self:calcular_vector_esfuerzos_barra()
    
    -- CALCULO ADICIONALES
    self.puntos_criticos_cortante = {} self:calcular_puntos_criticos_cortante()
    self.puntos_criticos_momento  = {} self:calcular_puntos_criticos_momento() 
    
end

function analizar:fuerza_cortante(b,x)
    local barra = self.datos.barra
    local wa = barra.carga[b][1]
    local wb = barra.carga[b][2]
    local L  = barra.longitud[b][1]
    local cv = self.Qt[b][2][1]
    return wa*x+(x^2*(-wa+wb))/(2*L)+cv
end

function analizar:momento_flector(b,x)
    local barra = self.datos.barra
    local wa = barra.carga[b][1]
    local wb = barra.carga[b][2]
    local L  = barra.longitud[b][1]
    local cv = self.Qt[b][2][1]
    local cm = self.Qt[b][3][1]
    return cm-cv*x-(wa*x^2)/2-(x^3*(-wa+wb))/(6*L)
end

function analizar:calcular_puntos_criticos_cortante()
    local barra = self.datos.barra
    for i,k in ipairs(barra.conexion) do
        local wa = barra.carga[i][1]
        local wb = barra.carga[i][2]
        local L  = barra.longitud[i][1]
        local cv = self.Qt[i][2][1]
        --
        local a = (-wa+wb)/(2*L)
        local b = wa
        local c = cv
        local a = string.format("%.10f", a)
        local b = string.format("%.10f", b)
        local c = string.format("%.10f", c)
        --
        math.eval("xmax:=nfMax("..a.."*x^2+"..b.."*x+"..c..",x,0,"..L..")")
        math.eval("xmin:=nfMin("..a.."*x^2+"..b.."*x+"..c..",x,0,"..L..")")
        local xmax = tonumber(math.eval("xmax"))
        local xmin = tonumber(math.eval("xmin"))
        table.insert(self.puntos_criticos_cortante,{xmax,xmin})
        math.eval("DelVar xmax,xmin")
    end

end

function analizar:calcular_puntos_criticos_momento()
    local barra = self.datos.barra
    for i,k in ipairs(barra.conexion) do
        local wa = barra.carga[i][1]
        local wb = barra.carga[i][2]
        local L  = barra.longitud[i][1]
        local cv = self.Qt[i][2][1]
        local cm = self.Qt[i][3][1]
        --
        local a = -(-wa+wb)/(6*L)
        local b = -wa/2
        local c = -cv
        local d = cm
        local a = string.format("%.10f", a)
        local b = string.format("%.10f", b)
        local c = string.format("%.10f", c)
        local d = string.format("%.10f", d)
        --
        math.eval("xmax:=nfMax("..tostring(a).."*x^3+"..tostring(b).."*x^2+"..tostring(c).."*x+"..tostring(d)..",x,0,"..tostring(L)..")")
        math.eval("xmin:=nfMin("..tostring(a).."*x^3+"..tostring(b).."*x^2+"..tostring(c).."*x+"..tostring(d)..",x,0,"..tostring(L)..")")
        local xmax = tonumber(math.eval("xmax"))
        local xmin = tonumber(math.eval("xmin"))
        table.insert(self.puntos_criticos_momento,{xmax,xmin})
        math.eval("DelVar xmax,xmin")
    end
end

function analizar:calcular_longitud_angulo_barra()
    local barra = self.datos.barra
    local nodo = self.datos.nodo
    for i,conexion in ipairs(barra.conexion) do
        local ni,nj = conexion[1],conexion[2]
        local xi,yi = nodo.coordenada[ni][1],nodo.coordenada[ni][2]
        local xj,yj = nodo.coordenada[nj][1],nodo.coordenada[nj][2]
        -- Calculo de la longitud de la barra
        local longitud = math.sqrt((xj-xi)^2+(yj-yi)^2)
        table.insert(self.datos.barra.longitud,{longitud})
        -- Calculo del angulo de la barra
        local angulo_radianes = math.atan2(yj-yi, xj-xi) 
        local angulo_grados = math.deg(angulo_radianes)
        if angulo_grados < 0 then
            angulo_grados = angulo_grados + 360
        end
        table.insert(self.datos.barra.angulo,{angulo_grados})
    end
end

function analizar:matriz_rigidez_na_na(E,A,I,L)
    local K = {
        {E*A/L,0,0,-E*A/L,0,0}, 
        {0,12*E*I/L^3,6*E*I/L^2,0,-12*E*I/L^3,6*E*I/L^2},
        {0,6*E*I/L^2,4*E*I/L,0,-6*E*I/L^2,2*E*I/L}, 
        {-E*A/L,0,0,E*A/L,0,0},
        {0,-12*E*I/L^3,-6*E*I/L^2,0,12*E*I/L^3,-6*E*I/L^2},
        {0,6*E*I/L^2,2*E*I/L,0,-6*E*I/L^2,4*E*I/L}
    } 
    return K 
end

function analizar:matriz_rigidez_a_na(E,A,I,L)
    local K = {
      {E*A/L,0,0,-E*A/L,0,0},
      {0,3*E*I/L^3,0,0,-3*E*I/L^3,3*E*I/L^2},
      {0,0,0,0,0,0},
      {-E*A/L,0,0,E*A/L,0,0},
      {0,-3*E*I/L^3,0,0,3*E*I/L^3,-3*E*I/L^2},
      {0,3*E*I/L^2,0,0,-3*E*I/L^2,3*E*I/L}
    }
    return K
end

function analizar:matriz_rigidez_na_a(E,A,I,L)
    local K = {
        {E*A/L,0,0,-E*A/L,0,0},
        {0,3*E*I/L^3,3*E*I/L^2,0,-3*E*I/L^3,0},
        {0,3*E*I/L^2,3*E*I/L,0,-3*E*I/L^2,0},
        {-E*A/L,0,0,E*A/L,0,0},
        {0,-3*E*I/L^3,-3*E*I/L^2,0,3*E*I/L^3,0},
        {0,0,0,0,0,0}
    }
    return K
end

function analizar:matriz_rigidez_a_a(E,A,L)
    local K = {
        {E*A/L,0,0,-E*A/L,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {-E*A/L,0,0,E*A/L,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0}
    }
    return K
end

function analizar:calcular_k_local()
    local barra = self.datos.barra
    for i, k in ipairs(barra.conexion) do
        -- El orden las propiedades es 1:A 2:I 3:E
        local A,I = barra.propiedad[i][1],barra.propiedad[i][2]
        local E,L = barra.propiedad[i][3],barra.longitud[i][1]
        local ci,cj = barra.contorno[i][1],barra.contorno[i][2]
        local k_local
        if not ci and not cj then
          k_local = self:matriz_rigidez_na_na(E,A,I,L)
        elseif ci and not cj then
          k_local = self:matriz_rigidez_a_na(E,A,I,L)
        elseif not ci and cj then
          k_local = self:matriz_rigidez_na_a(E,A,I,L) 
        elseif ci and cj  then
          k_local = self:matriz_rigidez_a_a(E,A,L)
        end
        table.insert(self.k_local, k_local)
    end
end

function analizar:calcular_t()
    local barra = self.datos.barra
    local nodo  = self.datos.nodo
    for i, conexion in ipairs(barra.conexion) do
        local theta  = math.rad(barra.angulo[i][1]) -- angulo de barra
        local beta_i = math.rad(nodo.restriccion[conexion[1]][2])
        local beta_j = math.rad(nodo.restriccion[conexion[2]][2])
        local t = {
            {math.cos(theta-beta_i),-math.sin(theta-beta_i),0,0,0,0},
            {math.sin(theta-beta_i), math.cos(theta-beta_i),0,0,0,0},
            {0,0,1,0,0,0},
            {0,0,0,math.cos(theta-beta_j),-math.sin(theta-beta_j),0},
            {0,0,0,math.sin(theta-beta_j),math.cos(theta-beta_j),0},
            {0,0,0,0,0,1}
        }
        table.insert(self.t,t)
    end
end


function analizar:trasponer_matriz(a)
    local a_traspuesta = {} 
    for i = 1, #a[1] do 
        a_traspuesta[i] = {} 
        for j = 1, #a do 
            a_traspuesta[i][j] = a[j][i] 
        end 
    end 
    return a_traspuesta
end

function analizar:calcular_t_traspuesta()
    local barra = self.datos.barra
    for i, k in ipairs(barra.conexion) do
        local t_traspuesta = self:trasponer_matriz(self.t[i])
        table.insert(self.t_traspuesta,t_traspuesta)
    end
end


function analizar:multiplicar_matriz(a,b)
    local producto = {}
    for i = 1, #a do
        producto[i] = {}
        for j = 1, #b[1] do
            producto[i][j] = 0
            for k = 1, #a[1] do
              producto[i][j] = producto[i][j] + a[i][k] * b[k][j]
            end
        end
    end
    return producto
end

function analizar:calcular_k_global()
    local barra = self.datos.barra
    for i, k in ipairs(barra.conexion) do
        -- Matrices necesarias, recordemos K = t_t * k * t
        local k_local = self.k_local[i]
        local t = self.t[i]
        local t_traspuesta = self.t_traspuesta[i]
        
        local temporal = self:multiplicar_matriz(t,k_local)
        local k_global = self:multiplicar_matriz(temporal,t_traspuesta)
        table.insert(self.k_global,k_global)
    end
end   


function analizar:calcular_k_global_ensamblada()
    local nodo  = self.datos.nodo
    local barra = self.datos.barra
    for i = 1, #nodo.coordenada * 3 do
        self.k_global_ensamblada[i] = {}
        for j = 1, #nodo.coordenada * 3 do
            self.k_global_ensamblada[i][j] = 0
        end
    end 
    for i, conexion in ipairs(barra.conexion) do
        local k_global = self.k_global[i]
        local ni = conexion[1]
        local nj = conexion[2]
        -- Agregar las contribuciones de la matriz de rigidez de barra
        for i = 1, 3 do  -- Iterar por los grados de libertad, que son siempre 3
            for j = 1, 3 do
                -- Calcular los índices en la matriz de rigidez global K_total
                local fila,columna
                fila = (ni - 1) * 3 + i
                columna = (ni - 1) * 3 + j
                self.k_global_ensamblada[fila][columna] = self.k_global_ensamblada[fila][columna] + k_global[i][j]
                fila = (ni - 1) * 3 + i
                columna = (nj - 1) * 3 + j
                self.k_global_ensamblada[fila][columna] = self.k_global_ensamblada[fila][columna] + k_global[i][j + 3]
                fila = (nj - 1) * 3 + i
                columna = (ni - 1) * 3 + j
                self.k_global_ensamblada[fila][columna] = self.k_global_ensamblada[fila][columna] + k_global[i + 3][j]
                fila = (nj - 1) * 3 + i
                columna = (nj - 1) * 3 + j
                self.k_global_ensamblada[fila][columna] = self.k_global_ensamblada[fila][columna] + k_global[i + 3][j + 3]
            end
        end
    end    
end

function analizar:clasificar_gdl()
    restricciones = {
        {true,  true,  true},  -- 1: Libre
        {false, false, false}, -- 2: Empotrado
        {false, false, true},  -- 3: Simple
        {true,  false, true},  -- 4: Rodillo En X
        {false, true,  true},  -- 5: Rodillo En Y
        {true,  true,  false}, -- 6: Giro Restringido
        {true,  false, false}, -- 7: X Libre
        {false, true,  false}  -- 8: Y Libre
    }    
    local nodo  = self.datos.nodo
    local barra = self.datos.barra
    for i, k in ipairs(nodo.coordenada) do
        local cumpleCondicion = true
        for j, conexion in ipairs(barra.conexion) do
            local ni = conexion[1]
            local nj = conexion[2]
            local ci = barra.contorno[j][1]
            local cj = barra.contorno[j][2]
            local articulado
            -- Establece 'articulado' según si el nodo está en el inicio o fin de la barra y si esa conexión está articulada
            if ni == i then 
                articulado = ci 
            elseif nj == i then 
                articulado = cj 
            else articulado = nil  
            -- La barra es irrelevante para este nodo
            end 
            -- Si 'articulado' es false, el nodo no está totalmente articulado; la condición no se cumple
            if not articulado and articulado ~= nil then
                cumpleCondicion = false
                -- No se necesita 'break' aquí ya que queremos evaluar todas las barras, pero podría optimizar si se prefiere
            end
        end
        -- Inserta el tercer GDL del nodo en 'GDL_Articulado' solo si el nodo cumple con la condición después de revisar todas las barras
        if cumpleCondicion then
            local gdl = ((i - 1) * 3) + 3
            table.insert(self.gdl_articulado, gdl)
        end
    end    
    for i, restriccion in ipairs(nodo.restriccion) do
        local condicion = restriccion[1]
        local baseGDL = (i - 1) * 3 -- Asumiendo 3 GDL por nodo: x, y, theta
        local restriccion = restricciones[condicion]
        for gdl = 1, 3 do
            local gdlActual = baseGDL + gdl
            local esArticulado = false
            -- Búsqueda directa para verificar si gdlActual está en GDL_Articulado
            for _, gdlArticulado in ipairs(self.gdl_articulado) do
                if gdlArticulado == gdlActual then
                    esArticulado = true
                    break -- Salir del bucle una vez que se encuentra el GDL actual en GDL_Articulado
                end
            end
            -- Decidir si el GDL actual es libre o restringido
            if esArticulado or not restriccion[gdl] then
                table.insert(self.gdl_restringido, gdlActual)
            else
                table.insert(self.gdl_libre, gdlActual)
            end
        end
    end
end

function analizar:ordenar_k_global_ensamblada()
    local nuevoOrdenGDL = {}
    for _, gdl in ipairs(self.gdl_libre) do table.insert(nuevoOrdenGDL, gdl) end
    for _, gdl in ipairs(self.gdl_restringido) do table.insert(nuevoOrdenGDL, gdl) end
    local nLibres = #self.gdl_libre
    -- Directamente reordenar y extraer submatrices
    for i, gdl_i in ipairs(nuevoOrdenGDL) do
        for j, gdl_j in ipairs(nuevoOrdenGDL) do
            local valor = self.k_global_ensamblada[gdl_i][gdl_j]
            if i <= nLibres then
                if j <= nLibres then
                    self.KLL[i] = self.KLL[i] or {}
                    self.KLL[i][j] = valor
                else
                    self.KLR[i] = self.KLR[i] or {}
                    self.KLR[i][j - nLibres] = valor
                end
            else
                if j <= nLibres then
                    self.KRL[i - nLibres] = self.KRL[i - nLibres] or {}
                    self.KRL[i - nLibres][j] = valor
                else
                    self.KRR[i - nLibres] = self.KRR[i - nLibres] or {}
                    self.KRR[i - nLibres][j - nLibres] = valor
                end
            end
        end
    end
end

function analizar:ensamblar_R1()
    local nodo = self.datos.nodo
    for i = 1, #nodo.carga do
        local contador = (i - 1) * 3
        self.R1[contador + 1] = {nodo.carga[i][1]}  -- Fuerza en X para el nodo i
        self.R1[contador + 2] = {nodo.carga[i][2]}  -- Fuerza en Y para el nodo i
        self.R1[contador + 3] = {nodo.carga[i][3]}  -- Momento de giro para el nodo i
    end
end

function analizar:empotramiento_perfecto_na_na(L,Wi,Wj) -- cambiar por a minuscula por estilo
    if Wi == 0 and Wj == 0 then return 0,0,0,0 end
    local Mi = -L^2/60 * (3*Wi + 2*Wj)
    local Mj = L^2/60 * (2*Wi + 3*Wj)
    local Vi = -L/20 * (7*Wi + 3*Wj)
    local Vj = -L/20 * (3*Wi + 7*Wj)
    return Vi,Mi,Vj,Mj
end

function analizar:empotramiento_perfecto_a_na(L,Wi,Wj)
    if Wi == 0 and Wj == 0 then return 0,0,0,0 end
    local Vi = -(L/120)*(33*Wi+12*Wj)
    local Vj = -(L/120)*(27*Wi+48*Wj)
    local Mi = 0
    local Mj = (L^2/120)*(7*Wi+8*Wj)
    return Vi,Mi,Vj,Mj
end
 
function analizar:empotramiento_perfecto_na_a(L,Wi,Wj)
    if Wi == 0 and Wj == 0 then return 0,0,0,0 end
    local entrada_wi = Wi
    local entrada_wj = Wj
    local Wi = entrada_wj
    local Wj = entrada_wi
    local Vi = -(L/120)*(27*Wi+48*Wj)
    local Vj = -(L/120)*(33*Wi+12*Wj)
    local Mi = -(L^2/120)*(7*Wi+8*Wj)
    local Mj = 0
    return Vi,Mi,Vj,Mj
end

function analizar:empotramiento_perfecto_a_a(L,Wi,Wj)
   if Wi == 0 and Wj == 0 then return 0,0,0,0 end
   local Vi = -(L*(2*Wi+Wj))/6
   local Vj = -(L*(Wi+2*Wj))/6
   local Mi = 0
   local Mj = 0
   return Vi,Mi,Vj,Mj 
end

function analizar:ensamblar_R2()
    local barra = self.datos.barra
    local nodo  = self.datos.nodo
    -- a. Se determina los vectores de reaccion local
    for i,carga in ipairs(barra.carga) do
        local l  = barra.longitud[i][1]
        local wi,wj = carga[1],carga[2]
        local ci,cj = barra.contorno[i][1],barra.contorno[i][2]
        local vi, mi, vj, mj
        if ci and cj then
            vi, mi, vj, mj = self:empotramiento_perfecto_a_a(l,wi,wj)
        elseif ci  and not cj then
            vi, mi, vj, mj = self:empotramiento_perfecto_a_na(l,wi,wj)
        elseif not ci and cj then
            vi, mi, vj, mj = self:empotramiento_perfecto_na_a(l,wi,wj)
        else
            vi, mi, vj, mj = self:empotramiento_perfecto_na_na(l,wi,wj)
        end   
        local r2_local={{0},{vi},{mi},{0},{vj},{mj}} -- Asume cargas axiales nulas
        table.insert(self.r2_local,r2_local)
    end    
    -- b. Se tansforma los vectores de reaccion a el sistema global
    for i,k in ipairs(barra.conexion) do
        local t = self.t[i]
        local r2_local = self.r2_local[i]
        local r2_global = self:multiplicar_matriz(t,r2_local) -->>>>> DUDA CON T_DARRA
        table.insert(self.r2_global,r2_global)
    end  
    -- c. Se realiza el ensamble del vector de reaccion global
    for i = 1, #nodo.coordenada * 3 do
        self.R2[i] = {0} -- Asume 3 grados de libertad por nodo
    end
    -- Recorrer cada barra y sus cargas en el sistema global (r2)
    for i, conexion in ipairs(barra.conexion) do
        local ni, nj = conexion[1], conexion[2] -- Nodos inicio y fin de la barra
        local cargasBarra = self.r2_global[i] -- Cargas de la barra en el sistema global
        -- Agregar las contribuciones de la barra al vector R2 global
        for j = 1, 6 do -- Recorre los 6 grados de libertad por barra
            local gdl_global
            if j <= 3 then
                gdl_global = (ni - 1) * 3 + j -- GDL para el nodo de inicio
            else
                gdl_global = (nj - 1) * 3 + (j - 3) -- GDL para el nodo de fin
            end
            -- Sumar la contribución al vector R2
            self.R2[gdl_global][1] = self.R2[gdl_global][1] + cargasBarra[j][1]
        end
    end      
end

function analizar:restar_matriz(a,b)
     local resta = {}
    for i = 1, #a do
        resta[i] = {}
        for j = 1, #a[1] do
            resta[i][j] = a[i][j] - b[i][j]
        end
    end
    return resta
end

function analizar:calcular_R()
    self.R = self:restar_matriz(self.R1,self.R2)
end

function analizar:reducir_R()
    for i, gdl in ipairs(self.gdl_libre) do
        -- Inserta solo los valores correspondientes a los GDL libres en el nuevo vector
        table.insert(self.RLL, self.R[gdl])
    end
end

function analizar:invertir_matriz(A)
    local n = #A
    local copiaA = {}
    for i = 1, n do
        copiaA[i] = {}
        for j = 1, n do
            copiaA[i][j] = A[i][j]
        end
    end
    local I = {}
    -- Inicializar la matriz identidad I
    for i = 1, n do
        I[i] = {}
        for j = 1, n do
            I[i][j] = (i == j) and 1 or 0
        end
    end
    -- Proceso de eliminación de Gauss-Jordan utilizando copiaA en lugar de A
    for i = 1, n do
        -- Asegurarse de que el elemento diagonal no sea cero en copiaA
        if copiaA[i][i] == 0 then
            error("La matriz contiene un cero en la diagonal y no puede ser invertida mediante este método.")
        end
        -- Normalizar la fila i
        for j = 1, n do
            if i ~= j then
                local ratio = copiaA[j][i] / copiaA[i][i]
                for k = 1, n do
                    copiaA[j][k] = copiaA[j][k] - ratio * copiaA[i][k]
                    I[j][k] = I[j][k] - ratio * I[i][k]
                end
            end
        end
    end
    -- Dividir cada fila por su elemento diagonal en copiaA y aplicar lo mismo en I
    for i = 1, n do
        local divisor = copiaA[i][i]
        for j = 1, n do
            I[i][j] = I[i][j] / divisor
        end
    end
    return I        
end

function analizar:calcular_vector_desplzamiento_gdl_libre()
    -- [DLL] = [KLL]^(-1)*[RLL]
    local KLL_inversa = self:invertir_matriz(self.KLL)
    self.KLL_ = KLL_inversa
    self.DLL = self:multiplicar_matriz(KLL_inversa,self.RLL)
end

function analizar:calcular_vector_desplazamiento_local()
    for i = 1, #self.gdl_libre + #self.gdl_restringido do
        table.insert(self.D_local, {0})
    end
    -- Inserta los desplazamientos de los GDL libres en sus posiciones correspondientes.
    for i, gdlLibre in ipairs(self.gdl_libre) do
        self.D_local[gdlLibre] = self.DLL[i]
    end 
end

function analizar:calcular_vector_desplazamiento_global()
   local nodo = self.datos.nodo
   for i = 1, #nodo.coordenada do
       local baseIndex = (i - 1) * 3
       local u1 = self.D_local[baseIndex + 1][1] 
       local u2 = self.D_local[baseIndex + 2][1]
       local u3 = self.D_local[baseIndex + 3][1] 
       local temp1 = {{u1},{u2},{u3}}
       local angulo_grados = nodo.restriccion[i][2]
       local angulo_radianes = math.rad(angulo_grados)
       local m = {
           {math.cos(angulo_radianes),-math.sin(angulo_radianes),0},
           {math.sin(angulo_radianes),math.cos(angulo_radianes),0},
           {0,0,1},
       }
       local temp2 = self:multiplicar_matriz(m,temp1)
       self.D_global[baseIndex + 1] = {temp2[1][1]}  -- Fuerza en X para el nodo i
       self.D_global[baseIndex + 2] = {temp2[2][1]}  -- Fuerza en Y para el nodo i
       self.D_global[baseIndex + 3] = {temp2[3][1]}  -- Momento de giro para el nodo i
   end
end

function analizar:calcular_vector_reaccion_local()
    local temporal = self:multiplicar_matriz(self.k_global_ensamblada,self.D_local)
    self.Re_local = self:restar_matriz(temporal,self.R)
    --[[
    local Re_copia = {}
    for i,k in pairs(self.Re) do
       table.insert(Re_copia,k)
    end
    for i, k in ipairs(self.gdl_libres) do
       self.Re[k] = {0}
    end
    for i = 1, #self.nodos*3 do
       if self.D[i][1] ~= self.D_global[i][1]  then
           self.Re[i] = Re_copia[i]
       end
    end
    --]]
end

function analizar:calcular_vector_reaccion_global()
    local nodo = self.datos.nodo
    for i = 1, #nodo.coordenada do
        local baseIndex = (i - 1) * 3
        local u1 = self.Re_local[baseIndex + 1][1] 
        local u2 = self.Re_local[baseIndex + 2][1]
        local u3 = self.Re_local[baseIndex + 3][1] 
        local temp1 = {{u1},{u2},{u3}}
        local angulo_grados = nodo.restriccion[i][2]
        local angulo_radianes = math.rad(angulo_grados)
        local m = {
            {math.cos(angulo_radianes),-math.sin(angulo_radianes),0},
            {math.sin(angulo_radianes),math.cos(angulo_radianes),0},
            {0,0,1},
        }
        local temp2 = self:multiplicar_matriz(m,temp1)
        self.Re_global[baseIndex + 1] = {temp2[1][1]}  -- Fuerza en X para el nodo i
        self.Re_global[baseIndex + 2] = {temp2[2][1]}  -- Fuerza en Y para el nodo i
        self.Re_global[baseIndex + 3] = {temp2[3][1]}  -- Momento de giro para el nodo i
    end
end

function analizar:sumar_matriz(a,b)
     local resta = {}
    for i = 1, #a do
        resta[i] = {}
        for j = 1, #a[1] do
            resta[i][j] = a[i][j] + b[i][j]
        end
    end
    return resta
end

function analizar:calcular_vector_esfuerzos_barra()
    local barra = self.datos.barra
    for i, barra in ipairs(barra.conexion) do
        -- Determinar los GDL para los nodos de esta barra.
        local gdl_i_inicio = (barra[1] - 1) * 3 + 1
        local gdl_j_inicio = (barra[2] - 1) * 3 + 1
        -- Preparar D_local como una matriz para operaciones matriciales.
        local D_ = {}
        for gdl = gdl_i_inicio, gdl_i_inicio + 2 do
            table.insert(D_, {self.D_local[gdl][1]}) 
        end
        for gdl = gdl_j_inicio, gdl_j_inicio + 2 do
            table.insert(D_, {self.D_local[gdl][1]})
        end 
        self.D_barra[i] = D_    
        -- Transformar D_global a D_local aplicando [T_traspuesta].
        local D_transformado = self:multiplicar_matriz(self.t_traspuesta[i], D_)
        -- Calcular Qt para esta barra como [K_prima] * D_transformado.
        local Qt_actual = self:multiplicar_matriz(self.k_local[i], D_transformado)
        -- Sumar r2_prima[i] a Qt_actual para incluir los efectos de las cargas distribuidas y/o puntuales.
        local Qt_sumado = self:sumar_matriz(Qt_actual, self.r2_local[i])
        -- Almacenar el resultado ajustado en la colección Qt.
        table.insert(self.Qt, Qt_sumado)
    end
end