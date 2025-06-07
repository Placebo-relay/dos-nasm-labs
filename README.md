# 🖥️ Computer Architecture & Low-Level Programming

🔧 **Dos-box NASM code** for compiling into `.com` files in DOS-box via NASM

## License

This project is licensed under the GNU General Public License (GPL) version 2.0 or later. 

This project also includes NASM, which is licensed under the 2-clause BSD license. 

### Licenses

- **DOSBox**: GPL-2.0-or-later
- **NASM**: 2-clause BSD
---

## 📋 Tasks Overview

### **2.1 I/O: Print Your Name & Numbers**
```nasm
org 0x100

mov ah, 0x06    ; Call Console IO function
mov dl, 'A'     ; Character to output (ASCII 0x41)

int 0x21        ; Call DOS interrupt

int 0x20        ; Exit program || ret = return to caller
```

1. ✍️ Display **your name** on the screen.  
2. 🔢 Display numbers from **0 to 9** on the screen.

### **2.2 I/O Input & Validation**  
`N=?` — print **0...N** (one per line):  
- Example: 0, newline, 1, newline, 2, ...  
- File: `num.asm` (Check if N is within 0..9)  

1. 🔄 Display the numbers in **reverse order** on the screen.  
2. ❗ Add a program check to verify whether the number entered by the user is a **single-digit number**.  
3. ⭐ **Display a pyramid** of `*` symbols on the screen, with the number of tiers entered by the user.  
   - File: `starg.asm`  
4. 🚀 Try to implement a version of the program with **two-digit numbers**.

---

### **2.3 Basic Calculator**  
`calc.asm` (with validation)  
- **Check** if input numbers are **no more than 4**.

---

### **2.4 Advanced Calculator with Two-Digit Numbers**  
`calc2.asm`  
- **Enhance validation checks** for two-digit inputs.

---

# 2.5 Get Date (0x2a)
1. mov ah, 0x2a
# 3.1 BIOS I/O ~ BIOS 0x00
1. Display your name on the screen.  
2. Display numbers from 0 to 9 on the screen.
# 3.2 color BIOS attributes ~ BIOS 0x00
1. Modify the program so that characters are displayed on the screen with different attributes (colors) per line. Each line should contain one specific color of the symbol.  
The number of lines should be 16, corresponding to the number of possible colors.
# 3.3 string BIOS 0x13
1. Prompt the user for a number from 1 to 10.  
Display on the screen a line like "Х негритят отправились обедать", decreasing the counter in each subsequent line.  
The last line should be: "И никого не стало".
# 3.4 draw BIOS 0x00
1. Learn to draw a dot. Be creative and come up with a task: depict an uncomplicated image using dots, possibly an abstract one.
2. Draw two lines crossing each other in an "X" shape on the screen.
3. Draw a square in the center of the screen.
4. Display the flag on the screen.
5. Ask the user for the width of a line in pixels, then draw a line of the specified width.
# 3.5 draw BIOS 0x00
1. Display on the screen 15 squares of different sizes and colors so that each smaller square is positioned at the center of a larger square.
# 3.6 mouse BIOS 0x00 0x33 0x10
1. Develop a program that will terminate only after the second mouse click, not after the first.
# 3.7 draw via mouse BIOS 0x00 0x33 0x10
1. draw w mouse
# 3.8 RTC (RealTime Clock) 0x0B port 0x70
1. Develop a program that continuously displays the current time on the screen.
2. Develop a timer program. The user inputs the number of seconds via the keyboard, and the program should terminate after that amount of time.

