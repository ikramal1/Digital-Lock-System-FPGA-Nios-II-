# Digital-Lock-System-FPGA-Nios-II-


A secure 4-digit password system implemented on Intel/Altera DE1 FPGA boards using Nios II soft processor. Features lockout protection, password change capability, and visual feedback through 7-segment displays and LEDs.

## 🎯 Features

- **4-Digit Password Protection**: Enter passwords using switches and push buttons
- **Security Lockout**: 3 consecutive wrong attempts trigger a 10-second lockout with countdown
- **Password Change Mode**: Update password with visual confirmation (blinking display)
- **Visual Feedback**: 
  - 7-segment displays show entered digits
  - Green LED for success
  - Red LED for failure
  - Only one LED active at a time
- **Debounced Inputs**: Reliable key press detection using polling-based edge detection
- **Emergency Reset**: Cancel operations and clear lockout at any time

## 🛠️ Hardware Requirements

### FPGA Board
- Intel/Altera DE1 board 
- Nios II processor configured in Quartus Platform Designer (Qsys)

### Required Hardware Components
- **Switches (SW)**: At least SW[3:0] for digit input (0-9)
- **Push Buttons (KEY)**: 4 buttons (KEY0-KEY3), active-low
- **7-Segment Displays (HEX)**: HEX0-HEX3 for digit display
- **LEDs**: 
  - LEDG0 (green) for success indication
  - LEDR0 (red) for error indication

### Memory Requirements
- **On-chip RAM**: Minimum 8KB (actual usage ~3KB code + ~20 bytes data)

## 📋 Hardware Configuration (Platform Designer/Qsys)

Your Nios II system must include these PIOs:

| Component | Type | Width | Base Address | Description |
|-----------|------|-------|--------------|-------------|
| KEY_BASE | Input PIO | 4-bit | (defined in system.h) | Push buttons, active-low |
| SW_BASE | Input PIO | 10-bit | (defined in system.h) | Slide switches |
| LEDR_BASE | Output PIO | 10-bit | (defined in system.h) | Red LEDs |
| LEDG_BASE | Output PIO | 8-bit | (defined in system.h) | Green LEDs |
| HEX_BASE | Output PIO | 28-bit | (defined in system.h) | 7-segment displays (4×7 bits) |

**Note**: All base addresses are automatically generated in `system.h` by Platform Designer.

## 🎮 User Interface

### Input Controls

| Button/Switch | Function | Description |
|---------------|----------|-------------|
| **SW[3:0]** | Digit Selection | Set switches to choose digit 0-9 (values 10-15 clamp to 9) |
| **KEY0** | Enter Digit | Captures current SW value and adds to entry buffer |
| **KEY1** | Verify/Save | Verify password (normal mode) OR Save new password (change mode) |
| **KEY2** | Reset | Clear entry, turn off LEDs, cancel lockout, exit change mode |
| **KEY3** | Change Password | Enter password change mode (display blinks) |

### Output Indicators

| Display | Indication |
|---------|------------|
| **HEX0-HEX3** | Shows 4 entered digits (HEX0=rightmost/first digit) |
| **LEDG0** | ✅ Correct password OR password saved successfully |
| **LEDR0** | ❌ Wrong password |
| **HEX2/HEX3** | Lockout countdown timer (shows 10→00 during lockout) |

## 🔐 Usage Guide

### Basic Operation

1. **Enter Password**:
   ```
   - Set SW[3:0] to first digit (e.g., 0001 for "1")
   - Press KEY0
   - Repeat for all 4 digits
   - Press KEY1 to verify
   ```

2. **Default Password**: `1234`

3. **Success**: LEDG0 turns ON, display clears
4. **Failure**: LEDR0 turns ON, display clears, can try again

### Change Password

1. Press **KEY3** → Display starts blinking (confirms change mode active)
2. Enter new 4-digit password using SW + KEY0
3. Press **KEY1** to save → LEDG0 confirms save
4. Old password is now invalid

### Security Lockout

- **3 consecutive wrong attempts** trigger lockout
- **10-second countdown** displayed on HEX2/HEX3
- All inputs ignored except KEY2
- After lockout: wrong attempt counter resets

### Emergency Reset

- Press **KEY2** at any time to:
  - Clear current entry
  - Turn off all LEDs
  - Cancel lockout countdown
  - Exit change mode
  - Reset wrong attempt counter

## 📁 Project Structure

```
digital-lock-fpga/
├── README.md                   # This file
├── src/
│   └── main.c                  # Main application code
├── quartus/
│   ├── digital_lock.qpf        # Quartus project file
│   ├── digital_lock.qsf        # Quartus settings file
│   └── digital_lock.qsys       # Platform Designer system
├── software/
│   └── digital_lock_bsp/       # Board Support Package
└── docs/
    ├── testing_guide.md        # Comprehensive test procedures
    └── user_manual.md          # End-user documentation
```

## 🚀 Getting Started

### Prerequisites

- Intel Quartus II 13.0sp1
- Nios II EDS (Embedded Design Suite)
- USB Blaster cable for programming
- DE1 FPGA board

### Build and Deploy

1. **Clone Repository**:
   ```bash
   git clone https://github.com/ikramal1/Digital-Lock-System-FPGA-Nios-II-.git  
   cd Digital-Lock-System-FPGA-Nios-II-
   ```

2. **Open in Quartus**:
   ```bash
   quartus quartus/digitalLock.qpf
   ```

3. **Generate Hardware**:
   - Open Platform Designer (Tools → Platform Designer)
   - Open `digitalLock.qsys`
   - Generate HDL (Generate → Generate HDL)
   - Compile design (Processing → Start Compilation)

4. **Program FPGA**:
   - Tools → Programmer
   - Add `.sof` file
   - Program device

5. **Build Software**:
   ```bash
   cd software/nios2_digitalLock_bsp
   nios2-bsp hal . ../../quartus
   cd ../nios2_digitalLock
   nios2-app-generate-makefile --bsp-dir ../nios2_digitalLock_bsp
   make
   ```

6. **Download to Board**:
   ```bash
   nios2-download -g main.elf
   nios2-terminal
   ```


**Quick Test**:
1. Enter `1234` → Press KEY1 → LEDG0 should turn ON ✅
2. Enter `0000` → Press KEY1 → LEDR0 should turn ON ❌
3. Press KEY2 → All LEDs OFF, HEX shows `0000`

## 🔧 Configuration Options

In `main.c`, you can adjust:

```c
#define CODE_LEN          4      // Number of digits (default: 4)
#define LOCKOUT_SECONDS  10      // Lockout duration (default: 10s)
#define POLL_US          5000    // Polling interval (default: 5ms)
#define BLINK_CYCLES     100     // Change mode blink rate (default: 500ms)
```

**Default password** can be changed at line ~XX:
```c
uint8_t code[CODE_LEN] = {1,2,3,4};  // Change to your preferred default
```

## 🐛 Troubleshooting

| Problem | Possible Cause | Solution |
|---------|----------------|----------|
| Keys don't respond | Wrong KEY_BASE polarity | Verify active-low config in Qsys |
| HEX shows garbage | Wrong 7-seg encoding | Check `seg7[]` lookup table for your board |
| Double key presses | Insufficient debounce | Increase `POLL_US` or `AFTER_RELEASE_US` |
| Lockout doesn't work | Wrong streak not incrementing | Check LED behavior after wrong entry |
| Blinking not visible | BLINK_CYCLES too small | Increase to 200 (1 second cycle) |

## 📊 State Machine Overview

```
IDLE ──────────────────→ ENTERING ──────────→ IDLE
  ↑                         │                   ↑
  │                         ↓                   │
  │                      VERIFY ────────────────┘
  │                         │
  │                         ↓ (3 wrong)
  │                      LOCKED
  │                         │
  └─────────────────────────┘
  
Change Mode: IDLE → CHANGE_MODE → IDLE (independent path)
```

## 🎓 Educational Value

This project demonstrates:
- **Embedded C programming** for soft processors
- **Memory-mapped I/O** using Nios II HAL
- **Finite State Machine** design patterns
- **Input debouncing** techniques
- **Security concepts** (lockout mechanisms)
- **FPGA system integration** with Qsys/Platform Designer

Perfect for:
- Digital systems courses
- Embedded systems labs
- FPGA design projects
- Computer architecture education



## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👥 Authors

- **ALLAM Ikram** - *Initial work* - [YourGitHub](https://github.com/ikramal1)



## 📧 Contact

For questions or support, please open an issue on GitHub or contact [your.email@example.com](mailto:ikramallam26@gmail.com)

---
