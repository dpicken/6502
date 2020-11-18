.set VIA_REGISTER_B, 0x6000
.set VIA_REGISTER_A, 0x6001
.set VIA_REGISTER_DDRB, 0x6002
.set VIA_REGISTER_DDRA, 0x6003

.set LCD_CONTROL_E, 0b10000000
.set LCD_CONTROL_RW, 0b01000000
.set LCD_CONTROL_RS, 0b00100000
.set LCD_CONTROL_REGISTER, VIA_REGISTER_A

.set LCD_DATA_FUNCTION_SET, 0b00111000     ; 8 bit, 2 lines
.set LCD_DATA_DISPLAY_CONTROL, 0b00001110  ; display on, cursor on, blink off
.set LCD_DATA_ENTRY_MODE_SET, 0b00000110   ; increment, do not shift display
.set LCD_DATA_CLEAR_DISPLAY, 0b00000001
.set LCD_DATA_BUSY_FLAG, 0b10000000
.set LCD_DATA_REGISTER, VIA_REGISTER_B

.set ROM_BASE_ADDR, 0x8000
.set CPU_VECTOR_TABLE_BASE_ADDR, 0xFFFA

  .org ROM_BASE_ADDR
init_io:
  lda #0b11111111
  sta VIA_REGISTER_DDRB

  lda #0b11100000
  sta VIA_REGISTER_DDRA

lcd_busy_wait1:
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy1:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy1
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB
lcd_init_function_set:
  lda #LCD_DATA_FUNCTION_SET
  sta LCD_DATA_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_E
  sta LCD_CONTROL_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER

lcd_busy_wait2:
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy2:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy2
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB
lcd_init_display_control:
  lda #LCD_DATA_DISPLAY_CONTROL
  sta LCD_DATA_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_E
  sta LCD_CONTROL_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER

lcd_busy_wait3:
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy3:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy3
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB
lcd_init_entry_mode_set:
  lda #LCD_DATA_ENTRY_MODE_SET
  sta LCD_DATA_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_E
  sta LCD_CONTROL_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER

lcd_busy_wait4:
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy4:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy4
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB
lcd_clear_display:
  lda #LCD_DATA_CLEAR_DISPLAY
  sta LCD_DATA_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_E
  sta LCD_CONTROL_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER

print_hello_world:
  ldx #0
print_next_char:

lcd_busy_wait5:
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy5:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy5
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB

  lda hello_world_str,x
  beq end
  inx
  sta LCD_DATA_REGISTER
  lda #LCD_CONTROL_RS
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RS | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_RS
  sta LCD_CONTROL_REGISTER
  jmp print_next_char

end:
  jmp end

hello_world_str:
  .string "Hello, world!"

  .org CPU_VECTOR_TABLE_BASE_ADDR - ROM_BASE_ADDR
  .uahalf ROM_BASE_ADDR ; nmi vector
  .uahalf ROM_BASE_ADDR ; reset vector
  .uahalf ROM_BASE_ADDR ; irq/brk vector