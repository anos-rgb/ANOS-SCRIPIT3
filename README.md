# ANOS Exploit - Premium Edition v2.0

![Version](https://img.shields.io/badge/version-2.0-purple)
![Platform](https://img.shields.io/badge/platform-Roblox-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Exploit Roblox yang powerful dengan UI modern, modular, dan mudah dikembangkan.

## ✨ Features

### 🏃 Movement
- **Speed Hack** - Ubah kecepatan berjalan (16-200)
- **Fly Hack** - Terbang dengan kontrol WASD + Space/Shift
- **Noclip** - Tembus tembok dan objek
- **Infinite Jump** - Lompat tanpa batas

### 👁️ Visual  
- **Fullbright** - Terangkan seluruh map
- **Extreme Brightness** ⭐ NEW! - Brightness ekstrem untuk game gelap dengan bloom effect
- **ESP Players** - Highlight semua player
- **X-Ray Vision** - Lihat melalui dinding
- **Remove Fog** - Hapus kabut

### 📍 Teleport
- **Save/Load Checkpoint** - Simpan dan kembali ke posisi
- **Teleport to Spawn** - Kembali ke spawn
- **Teleport to Players** - TP ke player lain dengan list dinamis

### 🛠️ Misc
- **Anti-Kick** - Proteksi dari kick
- **FPS Counter** - Monitor FPS real-time
- **Player Info** - Tampilkan info akun
- **Reset Character** - Reset karakter
- **Rejoin Server** - Rejoin otomatis
- **Server Hop** - Pindah server otomatis
- **Copy Game Link** - Copy link game

## 📁 Struktur Folder

```
ANOS-Exploit/
├── anos.lua                    # Main entry point
├── config/
│   └── settings.lua           # Konfigurasi dan theme
├── core/
│   ├── init.lua              # Core system
│   └── character.lua         # Character management (opsional)
├── ui/
│   ├── main.lua              # Main UI
│   ├── components.lua        # UI components
│   └── themes.lua            # Theme presets (opsional)
├── modules/
│   ├── movement.lua          # Movement features
│   ├── visual.lua            # Visual features
│   ├── teleport.lua          # Teleport features
│   └── misc.lua              # Miscellaneous features
└── utils/
    └── helpers.lua           # Helper functions
```

## 🚀 Instalasi

### Method 1: Load dari GitHub (Recommended)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/ANOS-Exploit/main/anos.lua"))()
```

### Method 2: Copy Paste Manual

1. Copy semua file ke executor Anda
2. Jalankan `anos.lua`

## 🎨 Theme

UI menggunakan theme modern dengan:
- Background transparan untuk performa lebih baik
- Gradient purple-blue yang soft
- Smooth animations
- Responsive hover effects

### Customize Theme

Edit `config/settings.lua`:

```lua
Config.Theme = {
    MainBg = Color3.fromRGB(15, 15, 20),
    MainBgTransparency = 0.3,
    Primary = Color3.fromRGB(139, 92, 246),  -- Purple
    Secondary = Color3.fromRGB(59, 130, 246), -- Blue
    -- ... dll
}
```

## ⌨️ Hotkeys

- `Right Ctrl` - Toggle UI
- `F` - Toggle Fly
- `N` - Toggle Noclip

Edit hotkeys di `config/settings.lua`:

```lua
Config.Hotkeys = {
    ToggleUI = Enum.KeyCode.RightControl,
    ToggleFly = Enum.KeyCode.F,
    ToggleNoclip = Enum.KeyCode.N
}
```

## 🔧 Menambah Fitur Baru

Sistem modular memudahkan penambahan fitur tanpa merusak code existing.

### Contoh: Tambah Fitur di Module Movement

**1. Edit `modules/movement.lua`:**

```lua
-- Tambah fungsi baru
function Movement.SuperJump()
    local core = _G.ANOS.Core
    if not core.Humanoid then return end
    
    core.Humanoid.JumpPower = 200
    core.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    
    _G.ANOS.Utils.Notify("Jump", "Super jump activated!", 2)
end
```

**2. Tambah UI Button di `ui/main.lua`:**

```lua
function UI.LoadMovementTab()
    -- ... existing buttons ...
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "🚀 Super Jump",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            _G.ANOS.Modules.Movement.SuperJump()
        end
    })
end
```

Selesai! Fitur baru siap digunakan.

## 🎯 API Reference

### Core Functions

```lua
-- Character management
_G.ANOS.Core.SetupCharacter()
_G.ANOS.Core.Cleanup()

-- Connection management  
_G.ANOS.Core.AddConnection(name, connection)
_G.ANOS.Core.RemoveConnection(name)
```

### Utils Functions

```lua
-- UI Helpers
_G.ANOS.Utils.Tween(object, duration, properties)
_G.ANOS.Utils.AddCorner(parent, radius)
_G.ANOS.Utils.AddStroke(parent, color, thickness)
_G.ANOS.Utils.AddGradient(parent, colors, rotation)

-- Notifications
_G.ANOS.Utils.Notify(title, message, duration)

-- Teleport
_G.ANOS.Utils.Teleport(targetCFrame, attempts)

-- Player utilities
_G.ANOS.Utils.PlayerExists(playerName)
_G.ANOS.Utils.GetPlayerCharacter(player)
```

### Module Functions

#### Movement Module
```lua
_G.ANOS.Modules.Movement.EnableSpeed()
_G.ANOS.Modules.Movement.DisableSpeed()
_G.ANOS.Modules.Movement.ToggleSpeed()
_G.ANOS.Modules.Movement.SetWalkSpeed(speed)

_G.ANOS.Modules.Movement.EnableFly()
_G.ANOS.Modules.Movement.DisableFly()
_G.ANOS.Modules.Movement.ToggleFly()
_G.ANOS.Modules.Movement.SetFlySpeed(speed)

_G.ANOS.Modules.Movement.EnableNoclip()
_G.ANOS.Modules.Movement.DisableNoclip()
_G.ANOS.Modules.Movement.ToggleNoclip()

_G.ANOS.Modules.Movement.InfiniteJump()
```

#### Visual Module
```lua
_G.ANOS.Modules.Visual.EnableFullbright()
_G.ANOS.Modules.Visual.DisableFullbright()
_G.ANOS.Modules.Visual.ToggleFullbright()

_G.ANOS.Modules.Visual.EnableBrightness()
_G.ANOS.Modules.Visual.DisableBrightness()
_G.ANOS.Modules.Visual.ToggleBrightness()
_G.ANOS.Modules.Visual.SetBrightness(value)

_G.ANOS.Modules.Visual.EnableESP()
_G.ANOS.Modules.Visual.DisableESP()
_G.ANOS.Modules.Visual.ToggleESP()

_G.ANOS.Modules.Visual.ToggleXRay()
_G.ANOS.Modules.Visual.RemoveFog()
_G.ANOS.Modules.Visual.RestoreFog()
```

#### Teleport Module
```lua
_G.ANOS.Modules.Teleport.SaveCheckpoint()
_G.ANOS.Modules.Teleport.LoadCheckpoint()
_G.ANOS.Modules.Teleport.ToSpawn()
_G.ANOS.Modules.Teleport.ToPlayer(playerName)
_G.ANOS.Modules.Teleport.ToCoordinates(x, y, z)
_G.ANOS.Modules.Teleport.GetPlayerList()
```

#### Misc Module
```lua
_G.ANOS.Modules.Misc.EnableAntiKick()
_G.ANOS.Modules.Misc.DisableAntiKick()
_G.ANOS.Modules.Misc.ToggleAntiKick()

_G.ANOS.Modules.Misc.ResetCharacter()
_G.ANOS.Modules.Misc.RejoinServer()
_G.ANOS.Modules.Misc.ServerHop()
_G.ANOS.Modules.Misc.CopyGameLink()

_G.ANOS.Modules.Misc.ToggleFPSCounter()
_G.ANOS.Modules.Misc.GetPlayerInfo()
_G.ANOS.Modules.Misc.ShowPlayerInfo()
```

### UI Components

```lua
-- Create Button
Components.CreateButton(parent, {
    Name = "MyButton",
    Size = UDim2.new(1, -10, 0, 45),
    Text = "Click Me",
    Color = Color3.fromRGB(50, 50, 60),
    HoverColor = Color3.fromRGB(100, 100, 120),
    Callback = function()
        print("Button clicked!")
    end
})

-- Create Toggle
Components.CreateToggle(parent, {
    Name = "MyToggle",
    Text = "Feature",
    ActiveText = "✓ Feature ON",
    InactiveText = "Feature OFF",
    State = false,
    Callback = function(state)
        print("Toggle state:", state)
    end
})

-- Create Slider
Components.CreateSlider(parent, {
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Create Tab
Components.CreateTab(parent, {
    Name = "MyTab",
    Text = "TAB NAME",
    Active = false,
    Callback = function()
        print("Tab clicked!")
    end
})
```

## 📝 Changelog

### Version 2.0 (Current)
- ✨ Complete rewrite dengan sistem modular
- 🎨 UI baru dengan transparansi dan gradient modern
- ⭐ **NEW:** Extreme Brightness feature untuk game gelap
- 🔧 Mudah menambah fitur baru
- 📦 Organized folder structure
- 🎯 Better error handling
- ⚡ Improved performance
- 📱 Responsive UI dengan smooth animations
- 🔑 Hotkey support
- 💾 State persistence setelah respawn

### Version 1.0
- Initial release
- Basic features

## 🐛 Troubleshooting

### Script tidak load?
- Pastikan executor support `HttpGet`
- Check console untuk error messages
- Pastikan semua file ada di GitHub

### Fitur tidak bekerja?
- Beberapa game punya anti-cheat
- Try different games untuk testing
- Check console untuk error messages

### UI tidak muncul?
- Tekan `Right Ctrl` untuk toggle
- Click tombol "A" floating button
- Restart script

## 💡 Tips

1. **Save checkpoint** sebelum eksperimen dengan teleport
2. **Anti-kick** tidak 100% work di semua game
3. **Extreme brightness** sangat berguna untuk horror games
4. **Server hop** untuk avoid toxic players
5. Gunakan **noclip + fly** untuk eksplorasi maksimal

## 🤝 Contributing

Contributions welcome! Cara contribute:

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Development Guidelines

- Follow existing code style
- Test fitur baru di multiple games
- Update README untuk fitur baru
- Comment code Anda
- Keep modules independent

## 📄 License

MIT License - feel free to use and modify

## ⚠️ Disclaimer

Educational purposes only. Use at your own risk. Authors tidak bertanggung jawab atas:
- Account bans
- Game bans
- Data loss
- Any damages

## 👨‍💻 Author

Created with ❤️ by ANOS Team

## 🌟 Star History

Jika project ini membantu, kasih ⭐ di GitHub!

## 📞 Support

- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/ANOS-Exploit/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/ANOS-Exploit/discussions)
- 📧 Email: your.email@example.com

## 🔗 Links

- [Documentation](https://github.com/yourusername/ANOS-Exploit/wiki)
- [Changelog](https://github.com/yourusername/ANOS-Exploit/releases)
- [Roadmap](https://github.com/yourusername/ANOS-Exploit/projects)

---

Made with 💜 for the Roblox community
