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

.set STACK_BASE_ADDR, 0x00FF
.set ROM_BASE_ADDR, 0x8000
.set CPU_VECTOR_TABLE_BASE_ADDR, 0xFFFA

  .org ROM_BASE_ADDR
init:
  ldx #STACK_BASE_ADDR
  txs
  jsr io_init
  jsr lcd_init
main:
  jsr print_hello_world
end:
  jmp end

hello_world_str:
  .string "Hello, world!"

print_hello_world:
  ldx #0
print_hello_world_next_char:
  lda hello_world_str,x
  beq print_hello_world_end
  jsr lcd_putc
  inx
  jmp print_hello_world_next_char
print_hello_world_end:
  rts

io_init:
  lda #0b11111111
  sta VIA_REGISTER_DDRB

  lda #0b11100000
  sta VIA_REGISTER_DDRA
  rts

lcd_init:
  lda #LCD_DATA_FUNCTION_SET
  jsr lcd_instruction

  lda #LCD_DATA_DISPLAY_CONTROL
  jsr lcd_instruction

  lda #LCD_DATA_ENTRY_MODE_SET
  jsr lcd_instruction

  lda #LCD_DATA_CLEAR_DISPLAY
  jsr lcd_instruction
  rts

lcd_instruction:
  jsr lcd_busy_wait
  sta LCD_DATA_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_E
  sta LCD_CONTROL_REGISTER
  lda #0
  sta LCD_CONTROL_REGISTER
  rts

lcd_putc:
  jsr lcd_busy_wait
  sta LCD_DATA_REGISTER
  lda #LCD_CONTROL_RS
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RS | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda #LCD_CONTROL_RS
  sta LCD_CONTROL_REGISTER
  rts

lcd_busy_wait:
  pha
  lda #0b00000000
  sta VIA_REGISTER_DDRB
lcd_busy:
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #(LCD_CONTROL_RW | LCD_CONTROL_E)
  sta LCD_CONTROL_REGISTER
  lda LCD_DATA_REGISTER
  and #LCD_DATA_BUSY_FLAG
  bne lcd_busy
  lda #LCD_CONTROL_RW
  sta LCD_CONTROL_REGISTER
  lda #0b11111111
  sta VIA_REGISTER_DDRB
  pla
  rts

  .org CPU_VECTOR_TABLE_BASE_ADDR - ROM_BASE_ADDR
  .uahalf ROM_BASE_ADDR ; nmi vector
  .uahalf ROM_BASE_ADDR ; reset vector
  .uahalf ROM_BASE_ADDR ; irq/brk vector
