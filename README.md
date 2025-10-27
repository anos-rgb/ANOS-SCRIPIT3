# ANOS EXPLOIT v2.0.0

Premium Roblox Exploit Script - Modular & Modern Design

## 🌟 Features

### Movement
- **Speed Hack** - Customizable walk speed (16-200)
- **Fly Hack** - Full 3D flight with WASD controls
- **Noclip** - Walk through walls
- **Infinite Jump** - Jump infinitely high

### Visual
- **Advanced Brightness** - 5-level brightness system for dark games
- **Night Vision** - Green-tinted vision enhancement
- **ESP Players** - See players through walls
- **X-Ray Vision** - See through objects
- **Remove Fog** - Clear all fog effects

### Teleport
- **Save/Load Checkpoint** - Save your position
- **Teleport to Players** - Quick player teleportation
- **Teleport to Spawn** - Return to spawn point
- **Custom Coordinates** - Teleport to specific location

### Miscellaneous
- **Anti-Kick** - Prevents server kicks
- **Server Hop** - Find new server
- **Rejoin** - Rejoin current server
- **Copy Game Link** - Copy game URL
- **Player Info** - View account details

## 📁 Project Structure

```
ANOS-Exploit/
├── anos.lua              # Main entry point
├── config/
│   └── settings.lua      # Configuration & settings
├── ui/
│   ├── main.lua          # Main UI controller
│   ├── components.lua    # Reusable UI components
│   └── themes.lua        # Color themes
├── features/
│   ├── movement.lua      # Movement features
│   ├── visual.lua        # Visual features
│   ├── teleport.lua      # Teleport features
│   └── misc.lua          # Miscellaneous features
└── utils/
    └── helpers.lua       # Helper functions
```

## 🚀 Installation

### Method 1: Direct Load (Recommended)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/anos-rgb/ANOS-SCRIPIT3/main/anos-sc-codex-djvnhz76f.lua"))()
```

### Method 2: Manual Load
1. Download all files from GitHub
2. Upload to your own GitHub repository
3. Update `GITHUB_BASE` URL in `anos.lua`
4. Execute the main script

## 📝 Usage

### Basic Controls
- Click the **toggle button** (floating "A" button) to open/close menu
- Drag the toggle button to move it anywhere on screen
- Use tabs to navigate between features
- Toggle switches turn features on/off
- Sliders adjust values in real-time

### Keyboard Shortcuts
When **Fly** is enabled:
- `W` - Forward
- `S` - Backward
- `A` - Left
- `D` - Right
- `Space` - Up
- `Left Shift` - Down

## 🎨 Customization

### Changing Theme
Edit `ui/themes.lua` to customize colors:
```lua
Themes.Dark = {
    primary = Color3.fromRGB(100, 50, 200),  -- Main accent color
    background = Color3.fromRGB(15, 15, 20),  -- Background
    -- ... more colors
}
```

### Adding New Features
1. Create new function in appropriate feature module
2. Add UI button in `ui/main.lua`
3. Connect button callback to your function

Example:
```lua
-- In features/movement.lua
function Movement.CustomFeature()
    -- Your code here
end

-- In ui/main.lua (in LoadMovementTab function)
Components.CreateButton({
    parent = contentFrame,
    text = "MY FEATURE",
    callback = function()
        Movement.CustomFeature()
    end
})
```

## 🔧 Configuration

Edit `config/settings.lua` to change default values:

```lua
Config.Settings = {
    walkSpeed = 50,      -- Default speed
    flySpeed = 50,       -- Default fly speed
    jumpPower = 100,     -- Jump height
    
    brightness = {
        level = 3,       -- Brightness level (1-5)
        -- ... more settings
    }
}
```

## 📚 API Reference

### Global Namespace
All modules are accessible via `_G.ANOS`:
```lua
_G.ANOS.Movement   -- Movement features
_G.ANOS.Visual     -- Visual features
_G.ANOS.Teleport   -- Teleport features
_G.ANOS.Misc       -- Miscellaneous features
_G.ANOS.Helpers    -- Helper functions
_G.ANOS.Config     -- Configuration
_G.ANOS.Themes     -- UI themes
_G.ANOS.Components -- UI components
_G.ANOS.UI         -- UI controller
```

### Example Usage
```lua
-- Enable speed hack
_G.ANOS.Movement.EnableSpeed(true)

-- Set custom speed
_G.ANOS.Movement.SetWalkSpeed(100)

-- Save checkpoint
_G.ANOS.Teleport.SaveCheckpoint()

-- Enable brightness
_G.ANOS.Visual.EnableBrightness(true)
```

## 🛡️ Safety Features

- **Anti-Detection**: Randomized GUI names
- **Error Handling**: Try-catch on all critical functions
- **Clean Disconnect**: Properly disconnects all connections on close
- **State Persistence**: Remembers feature states across respawns

## ⚠️ Disclaimer

This script is for **educational purposes only**. Use at your own risk. The developers are not responsible for any consequences of using this script, including but not limited to:
- Account bans or terminations
- Game crashes
- Data loss

Always respect game rules and terms of service.

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Coding Standards
- Use meaningful variable names
- Comment complex logic
- Follow existing code structure
- Test thoroughly before submitting

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📞 Support

- **GitHub Issues**: Report bugs or request features
- **Discussions**: Ask questions or share ideas

## 🔄 Changelog

### Version 2.0.0 (Current)
- ✨ Complete modular rewrite
- 🎨 New transparent UI design
- 🌙 Advanced brightness system (5 levels)
- 🎭 Multiple theme support
- 📦 Separated into organized modules
- 🚀 Improved performance
- 🛠️ Better error handling
- 📱 Mobile-friendly toggle button

### Version 1.0.0
- Initial release
- Basic features implementation

## 🎯 Roadmap

### Planned Features
- [ ] Custom keybinds
- [ ] Config save/load system
- [ ] More themes (Cyber, Midnight)
- [ ] Advanced ESP options (distance, health bars)
- [ ] Teleport waypoints system
- [ ] Click teleport
- [ ] Auto-farm framework
- [ ] Script hub integration

## 💡 Tips & Tricks

### Performance Optimization
- Disable unused features to reduce lag
- Lower fly speed in laggy servers
- Use brightness level 2-3 for best visibility/performance

### Best Practices
- Always save a checkpoint before risky actions
- Test features in private servers first
- Use Anti-Kick in strict games
- Keep the toggle button in a safe spot

### Troubleshooting
**Issue**: Features not working after respawn  
**Solution**: Features auto-reapply on respawn. If not, toggle them off and on again.

**Issue**: Fly not responding  
**Solution**: Make sure you're not in a restricted area. Try disabling and re-enabling fly.

**Issue**: UI not showing  
**Solution**: Check if CoreGui access is available. Some executors have restrictions.

**Issue**: Brightness too intense  
**Solution**: Lower brightness level in slider (1-5). Level 2-3 is recommended.

## 🔑 Advanced Usage

### Scripting with ANOS

You can control ANOS features from other scripts:

```lua
-- Wait for ANOS to load
repeat task.wait() until _G.ANOS and _G.ANOS.Loaded

-- Enable multiple features at once
_G.ANOS.Movement.EnableSpeed(true)
_G.ANOS.Movement.SetWalkSpeed(150)
_G.ANOS.Visual.EnableBrightness(true)
_G.ANOS.Visual.SetBrightnessLevel(4)

-- Create custom notification
_G.ANOS.Helpers.Notify("Custom script loaded!", 3, "success")

-- Teleport to custom coordinates
_G.ANOS.Teleport.ToCoordinates(100, 50, 200)

-- Get player information
local info = _G.ANOS.Misc.GetPlayerInfo()
print("Playing as: " .. info.Username)
```

### Creating Custom UI

Use ANOS components in your own scripts:

```lua
-- Create custom button
local myButton = _G.ANOS.Components.CreateButton({
    parent = myFrame,
    text = "My Custom Button",
    color = Color3.fromRGB(100, 200, 50),
    callback = function()
        print("Button clicked!")
    end
})

-- Create custom slider
local mySlider = _G.ANOS.Components.CreateSlider({
    parent = myFrame,
    title = "My Slider",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value)
        print("Slider value: " .. value)
    end
})
```

## 📊 Module Documentation

### Movement Module
```lua
Movement.EnableSpeed(boolean)           -- Toggle speed hack
Movement.SetWalkSpeed(number)           -- Set walk speed (16-200)
Movement.EnableFly(boolean)             -- Toggle fly hack
Movement.SetFlySpeed(number)            -- Set fly speed (16-200)
Movement.EnableNoclip(boolean)          -- Toggle noclip
Movement.InfiniteJump()                 -- Execute jump
Movement.SetJumpPower(number)           -- Set jump power
Movement.SetupCharacter()               -- Reapply features on respawn
```

### Visual Module
```lua
Visual.EnableBrightness(boolean)        -- Toggle brightness
Visual.SetBrightnessLevel(number)       -- Set level (1-5)
Visual.ToggleESP()                      -- Toggle player ESP
Visual.EnableESP(boolean)               -- Enable/disable ESP
Visual.ToggleXRay()                     -- Toggle X-Ray vision
Visual.RemoveFog()                      -- Remove all fog
Visual.ToggleNightVision()              -- Toggle night vision
```

### Teleport Module
```lua
Teleport.SaveCheckpoint()               -- Save current position
Teleport.LoadCheckpoint()               -- Teleport to saved position
Teleport.ToSpawn()                      -- Teleport to spawn
Teleport.ToPlayer(player)               -- Teleport to player
Teleport.ToCoordinates(x, y, z)         -- Teleport to coordinates
```

### Misc Module
```lua
Misc.EnableAntiKick(boolean)            -- Toggle anti-kick
Misc.ResetCharacter()                   -- Reset character
Misc.RejoinServer()                     -- Rejoin current server
Misc.ServerHop()                        -- Join different server
Misc.CopyGameLink()                     -- Copy game URL
Misc.GetPlayerInfo()                    -- Get player data
Misc.PrintPlayerInfo()                  -- Print info to console
Misc.GetGameInfo()                      -- Get game data
Misc.PrintGameInfo()                    -- Print game info
```

### Helpers Module
```lua
Helpers.GetCharacter()                  -- Get character model
Helpers.GetHumanoid()                   -- Get humanoid
Helpers.GetRootPart()                   -- Get root part
Helpers.TweenPosition(instance, pos)    -- Tween position
Helpers.TweenSize(instance, size)       -- Tween size
Helpers.TweenColor(instance, color)     -- Tween color
Helpers.CreateCorner(parent, radius)    -- Create UI corner
Helpers.CreateStroke(parent, ...)       -- Create UI stroke
Helpers.ButtonPressEffect(button)       -- Animate button press
Helpers.AddConnection(name, conn)       -- Add managed connection
Helpers.RemoveConnection(name)          -- Remove connection
Helpers.DisconnectAll()                 -- Disconnect all
Helpers.Notify(message, duration, type) -- Show notification
```

## 🎨 Theme Customization

### Available Themes
- **Dark** (Default) - Purple accent, dark background
- **Midnight** - Blue accent, darker background  
- **Cyber** - Green accent, tech theme

### Switching Themes
```lua
_G.ANOS.Themes.SetTheme("Midnight")
_G.ANOS.Themes.SetTheme("Cyber")
_G.ANOS.Themes.SetTheme("Dark")
```

### Creating Custom Theme
Add to `ui/themes.lua`:

```lua
Themes.MyTheme = {
    name = "MyTheme",
    primary = Color3.fromRGB(255, 100, 100),
    background = Color3.fromRGB(20, 20, 20),
    -- Add all required color properties
}
```

## 🔐 Security Notes

- Script uses randomized GUI names to avoid detection
- No telemetry or data collection
- All features run locally
- Open source for transparency
- Regular security audits recommended

## 🏆 Credits

**Developer**: ANOS Team  
**Version**: 2.0.0  
**Built with**: Lua, Roblox Studio  

### Special Thanks
- Roblox scripting community
- Beta testers
- Contributors

## 📱 Mobile Support

ANOS is fully compatible with mobile devices:
- Touch-friendly toggle button
- Draggable UI elements
- Optimized for smaller screens
- Responsive button sizes

## 🖥️ Executor Compatibility

Tested and working on:
- ✅ Synapse X
- ✅ Script-Ware
- ✅ KRNL
- ✅ Fluxus
- ✅ Electron
- ⚠️ Some features may not work on all executors

## 📖 FAQ

**Q: Is this safe to use?**  
A: Use at your own risk. While we implement safety features, exploiting always carries risk.

**Q: Why aren't some features working?**  
A: Some games have anti-cheat that blocks certain features. Try different games.

**Q: Can I get banned?**  
A: Yes, exploiting violates Roblox TOS and can result in account termination.

**Q: How do I update?**  
A: Re-execute the loadstring. The script always loads the latest version.

**Q: Can I use this on any game?**  
A: Most features work on most games, but some games have protections.

**Q: The UI is too transparent, how do I fix it?**  
A: Edit transparency values in `config/settings.lua` or `ui/themes.lua`.

**Q: How do I add custom features?**  
A: Follow the "Adding New Features" section in this README.

## 🌐 Links

- **Discord**: [Discord Server]
  

---

**Made by ANOS Team**

*Last Updated: 2025*
