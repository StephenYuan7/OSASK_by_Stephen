; hello_os
; TAB=4

CYLS	EQU		10		;CYLS类似于C语言的宏定义

	ORG		0x7c00
;下面是设置FAT12格式的代码
	JMP		entry
	DB		0x90
	DB		"HARIBOTE"
	DW		512
	DB		1
	DW		1
	DB		2
	DW		224
	DW		2880
	DB		0xf0
	DW		9
	DW		18
	DW		2
	DD		0
	DD		2880
	DB		0,0,0x29
	DD		0xffffffff
	DB		"HARIBOTEOS"
	DB		"FAT12   "
	RESB	18

	entry:
			MOV		AX,0	;初始化寄存器，AX,SS,DS都先设为0，有点像C语言初始化变量
			MOV		SS,AX
			MOV		SP,0x7c00
			MOV		DS,AX

			MOV		AX,0X0820
			MOV		ES,AX	;给ES初始化为0x0820,这个就是存储的初始地址
			MOV		CH,0	;CH设置柱面0
			MOV		DH,0	;DH设置磁头0
			MOV		CL,2	;CL设置扇区2,因为第一个扇区是启动区
	readloop:
			MOV		SI,0	;用来计数
	retry:
			MOV		AH,0x02	;0x02就是读盘模式
			MOV		AL,1	;同时处理1个扇区
			MOV		BX,0	;这里没啥用
			MOV		DL,0x00	;如果有多个就需要指定第几个驱动器，这里只有1一个，指定第0号即可
			INT		0x13	;调用磁盘BIOS
			JNC		next	;系统没出错跳转到next
			ADD		SI,1
			CMP		SI,5
			JAE		error	;连续出错5次跳转到error
			MOV		AH,0x00
			MOV		DL,0x00
			INT		0x13	;报错了重置一些寄存器重新开始
			JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX		;三行代码为了让地址移动0x0020，因为，ES不能直接加
		ADD		CL,1			
		CMP		CL,18			
		JBE		readloop	;一个柱面18个扇区未读满，直接跳转继续读，JBE小于等于时跳转
		MOV		CL,1		;读满了，重置CL(扇区从1开始)
		ADD		DH,1
		CMP		DH,2
		JB		readloop	;判断磁头
		MOV		DH,0		;重置磁头
		ADD		CH,1
		CMP		CH,CYLS		;判断柱面
		JB		readloop		


fin:
		HLT						
		JMP		fin				

error:
		MOV		SI,msg		;跟前面显示hello world类似
putloop:
		MOV		AL,[SI]
		ADD		SI,1			
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			
		MOV		BX,15			
		INT		0x10			
		JMP		putloop
msg:
		DB		0x0a, 0x0a		
		DB		"load error"
		DB		0x0a			
		DB		0

		RESB	0x7dfe-$		

		DB		0x55, 0xaa
			
