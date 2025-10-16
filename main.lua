
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Funktion um Spieler zu kicken
local function kickPlayer(player, reason)
    player:Kick(reason)
end

-- Funktion um Hautfarbe zu überprüfen
local function checkSkinColor(player)
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Warte auf Body Colors
    local bodyColors = character:WaitForChild("Body Colors", 5)
    
    if bodyColors then
        local headColor = bodyColors.HeadColor3
        local torsoColor = bodyColors.TorsoColor3
        local leftArmColor = bodyColors.LeftArmColor3
        local rightArmColor = bodyColors.RightArmColor3
        local leftLegColor = bodyColors.LeftLegColor3
        local rightLegColor = bodyColors.RightLegColor3
        
        -- Definiere schwarze Farbe (sehr dunkle Farbtöne)
        local function isBlackColor(color)
            -- Prüfe ob die Farbe sehr dunkel ist (RGB Werte unter 0.15)
            return color.R < 0.15 and color.G < 0.15 and color.B < 0.15
        end
        
        -- Prüfe ob ALLE Körperteile schwarz sind
        local allBlack = isBlackColor(headColor) and 
                        isBlackColor(torsoColor) and 
                        isBlackColor(leftArmColor) and 
                        isBlackColor(rightArmColor) and 
                        isBlackColor(leftLegColor) and 
                        isBlackColor(rightLegColor)
        
        if not allBlack then
            -- Kicke den Spieler wenn nicht alle Körperteile schwarz sind
            kickPlayer(player, "❌ Nur schwarze Hautfarbe ist erlaubt!")
            print("🚫 " .. player.Name .. " wurde gekickt - keine schwarze Hautfarbe")
        else
            print("✅ " .. player.Name .. " hat schwarze Hautfarbe - darf bleiben")
        end
    end
end

-- Prüfe lokalen Spieler
if LocalPlayer then
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1) -- Warte kurz bis Character vollständig geladen ist
        checkSkinColor(LocalPlayer)
    end)
    
    -- Prüfe sofort wenn Character bereits existiert
    if LocalPlayer.Character then
        task.wait(1)
        checkSkinColor(LocalPlayer)
    end
end

-- Prüfe auch andere Spieler (falls Script Server-Side läuft)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        checkSkinColor(player)
    end)
    
    if player.Character then
        task.wait(1)
        checkSkinColor(player)
    end
end)

print("🎮 Skin Color Check aktiviert - Nur schwarze Hautfarbe erlaubt!")
