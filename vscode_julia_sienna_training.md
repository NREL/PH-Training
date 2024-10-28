
# Session 1: Setting up VSCode, Julia, and Sienna Packages

### Overview  
This session covers the installation and configuration of **VSCode**, **Julia**, and key **Sienna packages** to prepare for power system modeling and simulations.

---

### Prerequisites  
- Internet access and admin permissions.  
- Basic knowledge of command-line tools.

---

### Step 1: Install Visual Studio Code  
1. Download from [VSCode](https://code.visualstudio.com/).  
2. Install following the on-screen instructions.  
3. Launch VSCode after installation.

---

### Step 2: Install Julia on Windows  
1. Visit [Julia Downloads](https://julialang.org/downloads/platform/#windows).  
2. Download the **Windows installer** (`.exe`).  
3. Run the installer and follow these steps:
   - Choose **installation path** (default: `C:\\Users\\<YourUser>\\AppData\\Local\\Programs\\Julia`).  
   - Select **"Add Julia to PATH"** for easier access from the terminal.  
4. Verify installation:
   ```bash
   julia --version
   ```

---

### Step 3: Configure Julia in VSCode  
1. Open **VSCode**, go to **Extensions** (`Ctrl+Shift+X`).  
2. Search for and install the **Julia extension**.  
3. Set Julia's path:  
   - Open **Command Palette** (`Ctrl+Shift+P`).  
   - Search: `Settings` → `Julia: Executable Path`.  
   - Provide the full path to your `julia.exe`.

---

### Step 4: Start Julia REPL in VSCode  
1. Open the **Command Palette** (`Ctrl+Shift+P`).  
2. Type `Julia: Start REPL` and press **Enter** to launch it.

---

### Step 5: Install Sienna Packages  
Enter **package mode** in the Julia REPL by typing:
```julia
] add DataFrames CSV
```
Then install the packages listed below:

### 1. PowerSystems.jl  
- **Description**:  
  A library for defining and managing power system data, including time-series and scenario management.  
- **Installation**:
   ```julia
   add PowerSystems
   ```
- **Documentation**:  
  [PowerSystems.jl Documentation](https://nrel-sienna.github.io/PowerSystems.jl/stable/)

### 2. PowerSimulations.jl  
- **Description**:  
  Provides an interface for building and running complex simulations such as multi-stage optimization models.  
- **Installation**:
   ```julia
   add PowerSimulations
   ```
- **Documentation**:  
  [PowerSimulations.jl Documentation](https://nrel-sienna.github.io/PowerSimulations.jl/latest/)

### 3. PowerGraphics.jl  
- **Description**:  
  A visualization tool that simplifies the creation of plots and graphs for analyzing power systems.  
- **Installation**:
   ```julia
   add PowerGraphics
   ```
- **Documentation**:  
  [PowerGraphics.jl Documentation](https://nrel-sienna.github.io/PowerGraphics.jl/stable/)

---

### Troubleshooting  
- **Path Issues**: Verify paths in VSCode’s settings.  
- **Package Issues**: Ensure Julia is up-to-date and has internet access.  
- **Restart Required**: If REPL does not load, restart VSCode.

---

### Next Steps  
You are now ready for **Session 2: Basic Julia Tutorial**, where you will explore the fundamentals of Julia programming for power system modeling.

---

### Reference Links  
- [Julia and VSCode Setup Guide](https://www.matecdev.com/posts/julia-introduction-vscode.html)  
- [Julia for Windows Installation Guide](https://julialang.org/downloads/platform/#windows)  
- [PowerSystems.jl Documentation](https://nrel-sienna.github.io/PowerSystems.jl/stable/)  
- [PowerSimulations.jl Documentation](https://nrel-sienna.github.io/PowerSimulations.jl/latest/)  
- [PowerGraphics.jl Documentation](https://nrel-sienna.github.io/PowerGraphics.jl/stable/)
