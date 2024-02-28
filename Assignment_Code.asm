.data
	gameBoard: .space 42
		.align 2
	board:  .byte '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.'
	board1:  .asciiz " 1 2 3 4 5 6 7\n"
	board2: .asciiz "|"
	space: .asciiz " "
	start3: .asciiz "Player 1 (X)\n"
	start4: .asciiz "Player 2 (O)\n"
	start1: .asciiz "Player 1 (O)\n"
	start2: .asciiz "Player 2 (X)\n"
	choose: .asciiz "Enter 0 to choose X enter another number to choose O: "
	choice1: .asciiz "Player 1 turn. Please enter column input (a number between 1-7): "
	choice2: .asciiz "Player 2 turn. Please enter column input (a number between 1-7): "
	error1: .asciiz "Your column you choose is invalid or full of character! Insert again: "
	undo_1_left: .asciiz "Player 1's undos: "
	input_1_left: .asciiz "Player 1's time to input wrong left: "
	input_2_left: .asciiz "Player 2's time to input wrong left: "
	undo_2_left: .asciiz "Player 2's undos: "
	newline:	.asciiz "\n"
	undo: .asciiz "Enter 1 to undo, enter another number to continue to your move: "
	winner1: .asciiz "Player number 1 won! Congratulations <3 "
	winner2: .asciiz "Player number 2 won! Congratulations <3 "
	drawgame: .asciiz "There's a tie. Both of you are excellent!"
	ins1: .asciiz "Welcome to this Four in a row game.\n"
	ins2: .asciiz "Each player can randomly choose 'X  or 'O' to start the game.\n"
	ins3: .asciiz "In order to win the game, you must have four of your characters aligned, either vertically, horizontally or diagonally.\n"
	ins6: .asciiz "Each player has 3 times to undo their move (after their first move).\n"
	ins4: .asciiz "To start playing, choose the number correspondent to the column you wish to occupy.\n"
	ins5: .asciiz "If any players try to violate it 3 times. This player will lose the game.\n"
	ins7: .asciiz "Good luck!\n"
	random: .asciiz "Randomly choose a number to choose player who go first: "
	random_1: .asciiz "Player 1 go first!\n"
	random_2: .asciiz "Player 2 go first!\n"
		.align 2
	count: .byte 1
	const: .byte 0
	player1: .byte 'X'
	player2: .byte 'O'
	stopgame: .byte 0
	turnchoose: .byte 1
	turncheck: .byte 1
	take_undo_1: .byte 3
	take_undo_2: .byte 3
	input_1: .byte 3
	input_2: .byte 3
.text
li $s7, '.'
main:
	jal instruction
	jal random_player
	jal Choose_player
	jal printGameBoard
Loop:	la $t1, count
	lb $t2,($t1)
	bgt $t2, 42, draw # turn = 1 <= 42    ####### draw
	addi $t2, $t2, 1  #turn++
	sb $t2,($t1)
	la $t1, stopgame	
	lb $t2,($t1)
	bne $t2, $zero, exit # stopgame == false ####### exit
	sb $t2, ($t1)
	##############################
	#PLAYER 1 TURN
	la $t1, turnchoose
	lb $t2, ($t1)
	beq $t2, $zero, player2_turn # if(turn = 1 player1 play)
	sb $zero, ($t1)              #turn choose = 0
	li $v0, 4
	la $a0, undo_1_left
	syscall
	la $t4, take_undo_1
	lb $t2, ($t4)
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, input_1_left
	syscall
	la $t4, input_1
	lb $t2, ($t4)
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, choice1
	syscall  #########
	li $v0, 12
	syscall
	subi $v0, $v0, '0'
	move $a1, $v0
	li $v0, 4
	la $a0, newline
	syscall
while_loop_1:	
	blt $a1, 1, choice_again_1
	bgt $a1, 7, choice_again_1 
	move $t2, $a1
	addi $a1, $a1, -1
	la $t1, const
	lb $a0, ($t1)
	jal getCell
	sb $a0, ($t1)
	bne $v0, $s7, choice_again_1
	j exit_loop_1
		choice_again_1:
			la $t3, input_1
			lb $t4, ($t3)
			addi $t4, $t4, -1
			blt $t4, $zero, player2win
			sb $t4, ($t3)
			li $v0, 4
			la $a0, input_1_left
			syscall
			la $t3, input_1
			lb $t4, ($t3)
			move $a0, $t4
			sb $t4, ($t3)
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, newline
			syscall
			li $v0, 4
			la $a0, error1
			syscall
			li $v0, 12
			syscall
			subi $v0, $v0, '0'
			move $a1, $v0
			li $v0, 4
			la $a0, newline
			syscall
			j while_loop_1
	player2win:
		li $v0, 4
		la $a0, winner2
		syscall
		j exit
	exit_loop_1:
li $t1, 6
for_loop_1:     ###############%%%%%%%%%%%%%%%%%%%%
	addi $t1, $t1, -1
	move $a0, $t1
	move $a1, $t2
	addi $a1, $a1, -1
	jal getCell
	beq $v0, $s7, set_cell_1
	j here_1
		set_cell_1:
			la $t3, player1
			lb $a2, ($t3)
		 	jal setCell
		 	sb $a2, ($t3)
		 	j exit_for_loop_1
	here_1:
	j for_loop_1
	exit_for_loop_1:
	jal printGameBoard #######################################
while_take_undo_1: 
	la $t1, take_undo_1
	lb $t2, ($t1)
	ble $t2, $zero, exit_while_take_undo_1
	sb $t2, ($t1)
	li $t1, 1   # count variable
	for_take_undo_1:
		bgt $t1, 6, exit_for_take_undo_1
		move $a0, $t1
		addi $a0, $a0, -1
		move $t5, $a0
		jal getCell
		la $t2, player1
		lb $t3, ($t2)
		addi $t1, $t1, 1
		bne $t3, $v0, for_take_undo_1
		sb $t3, ($t2)
		li $v0, 4
		la $a0, undo
		syscall
		li $v0, 12
		syscall
		subi $v0, $v0, '0'
		move $t2, $v0 #check_undo_variable
		li $v0, 4
		la $a0, newline
		syscall
		bne $t2, 1, exit_while_take_undo_1
		move $a2, $s7
		move $a0, $t5
		jal setCell
		jal printGameBoard
		li $v0, 4
		la $a0, choice1
		syscall
		li $v0, 12
		syscall
		subi $v0, $v0, '0'
		move $a1, $v0
		li $v0, 4
		la $a0, newline
		syscall
			while_loop_1_2:	
				blt $a1, 1, choice_again_1_2
				bgt $a1, 7, choice_again_1_2 
				move $t2, $a1
				addi $a1, $a1, -1
				la $t3, const
				lb $a0, ($t3)
				jal getCell
				sb $a0, ($t3)
				bne $v0, $s7, choice_again_1_2
				j exit_loop_1_2
					choice_again_1_2:
					la $t3, input_1
					lb $t4, ($t3)
					addi $t4, $t4, -1
					blt $t4, $zero, player2win
					sb $t4, ($t3)
					li $v0, 4
					la $a0, input_1_left
					syscall
					la $t3, input_1
					lb $t4, ($t3)
					move $a0, $t4
					sb $t4, ($t3)
					li $v0, 1
					syscall
					li $v0, 4
					la $a0, newline
					syscall
					li $v0, 4
					la $a0, error1
					syscall
					li $v0, 12
					syscall
					subi $v0, $v0, '0'
					move $a1, $v0
					li $v0, 4
					la $a0, newline
					syscall
					j while_loop_1_2
				exit_loop_1_2:
	li $t3, 5
	for_loop_1_2:
		move $a0, $t3
		move $a1, $t2
		addi $a1, $a1, -1
		jal getCell
		beq $v0, $s7, set_cell_1_2   ###########################
		j here1
			set_cell_1_2:
			la $t4, player1
			lb $a2, ($t4)
		 	jal setCell
		 	sb $a2, ($t4)
		 	jal printGameBoard
		 	j exit_for_loop_1_2
	here1:
	addi $t3, $t3, -1
	j for_loop_1_2
	exit_for_loop_1_2:
	la $t4, take_undo_1
	lb $t2, ($t4)
	addi $t2, $t2, -1
	li $v0, 4
	la $a0, undo_1_left
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	sb $t2, ($t4)
	li $v0, 4
	la $a0, newline
	syscall
	j while_take_undo_1
	exit_for_take_undo_1:
exit_while_take_undo_1:
	########################### Check player 1 win or not if not continue and print game board
	jal isWinner
	bne $v1, 1, not_win_1
	jal printGameBoard
	li $v0, 4
	la $a0, winner1
	syscall
	la $t1, stopgame
	lb $t2, ($t1)
	li $t2, 1
	sb $t2, ($t1)
	j exit
		not_win_1:
			jal printGameBoard
	j Loop
player2_turn:
	la $t1, turnchoose
	lb $t2, ($t1)
	li $t2, 1
	sb $t2, ($t1)              #turn choose = 1
	################# PLAYER 2 TURN ####################3
	li $v0, 4
	la $a0, undo_2_left
	syscall
	la $t4, take_undo_2
	lb $t2, ($t4)
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, input_2_left
	syscall
	la $t4, input_2
	lb $t2, ($t4)
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, choice2
	syscall  #########
	li $v0, 12
	syscall
	subi $v0, $v0, '0'
	move $a1, $v0
	li $v0, 4
	la $a0, newline
	syscall
	################# Column input for player 2 #############
while_loop_2:	
	blt $a1, 1, choice_again_2
	bgt $a1, 7, choice_again_2 
	move $t2, $a1
	addi $a1, $a1, -1
	la $t1, const
	lb $a0, ($t1)
	jal getCell
	sb $a0, ($t1)
	bne $v0, $s7, choice_again_2
	j exit_loop_2
		choice_again_2:
			la $t3, input_2
			lb $t4, ($t3)
			addi $t4, $t4, -1
			blt $t4, $zero, player1win
			sb $t4, ($t3)
			li $v0, 4
			la $a0, input_2_left
			syscall
			la $t3, input_2
			lb $t4, ($t3)
			move $a0, $t4
			sb $t4, ($t3)
			li $v0, 1
			syscall
			li $v0, 4
			la $a0, newline
			syscall
			li $v0, 4
			la $a0, error1
			syscall
			li $v0, 12
			syscall
			subi $v0, $v0, '0'
			move $a1, $v0
			li $v0, 4
			la $a0, newline
			syscall
			j while_loop_2
player1win:
	li $v0, 4
	la $a0, winner1
	syscall
	j exit
exit_loop_2:
li $t1, 6
for_loop_2:
	addi $t1, $t1, -1
	move $a0, $t1
	move $a1, $t2
	addi $a1, $a1, -1
	jal getCell
	beq $v0, $s7, set_cell_2
	j here_2
		set_cell_2:
			la $t3, player2
			lb $a2, ($t3)
		 	jal setCell
		 	sb $a2, ($t3)
		 	j exit_for_loop_2
	here_2:
	j for_loop_2
	exit_for_loop_2:
	jal printGameBoard #######################################
while_take_undo_2: 
	la $t1, take_undo_2
	lb $t2, ($t1)
	ble $t2, $zero, exit_while_take_undo_2
	sb $t2, ($t1)
	li $t1, 1   # count variable
	for_take_undo_2:
		bgt $t1, 6, exit_for_take_undo_2
		move $a0, $t1
		addi $a0, $a0, -1
		move $t5, $a0
		jal getCell
		la $t2, player2
		lb $t3, ($t2)
		addi $t1, $t1, 1
		bne $t3, $v0, for_take_undo_2
		sb $t3, ($t2)
		li $v0, 4
		la $a0, undo
		syscall
		li $v0, 12
		syscall
		subi $v0, $v0, '0'
		move $t2, $v0 #check_undo_variable
		li $v0, 4
		la $a0, newline
		syscall
		bne $t2, 1, exit_while_take_undo_2
		move $a2, $s7
		move $a0, $t5
		jal setCell
		jal printGameBoard
		li $v0, 4
		la $a0, choice2
		syscall
		li $v0, 12
		syscall
		subi $v0, $v0, '0'
		move $a1, $v0
		li $v0, 4
		la $a0, newline
		syscall
			while_loop_2_2:	
				blt $a1, 1, choice_again_2_2
				bgt $a1, 7, choice_again_2_2 
				move $t2, $a1
				addi $a1, $a1, -1
				la $t3, const
				lb $a0, ($t3)
				jal getCell
				sb $a0, ($t3)
				bne $v0, $s7, choice_again_2_2
				j exit_loop_2_2
					choice_again_2_2:
					la $t3, input_2
					lb $t4, ($t3)
					addi $t4, $t4, -1
					blt $t4, $zero, player1win
					sb $t4, ($t3)
					li $v0, 4
					la $a0, input_2_left
					syscall
					la $t3, input_2
					lb $t4, ($t3)
					move $a0, $t4
					sb $t4, ($t3)
					li $v0, 1
					syscall
					li $v0, 4
					la $a0, newline
					syscall
					li $v0, 4
					la $a0, error1
					syscall
					li $v0, 12
					syscall
					subi $v0, $v0, '0'
					move $a1, $v0
					li $v0, 4
					la $a0, newline
					syscall
					j while_loop_2_2
				exit_loop_2_2:
	li $t3, 5
	for_loop_2_2:
		move $a0, $t3
		move $a1, $t2
		addi $a1, $a1, -1
		jal getCell
		beq $v0, $s7, set_cell_2_2   ###########################
		j here2
			set_cell_2_2:
			la $t4, player2
			lb $a2, ($t4)
		 	jal setCell
		 	sb $a2, ($t4)
		 	jal printGameBoard
		 	j exit_for_loop_2_2
	here2:
	addi $t3, $t3, -1
	j for_loop_2_2
	exit_for_loop_2_2:
	la $t4, take_undo_2
	lb $t2, ($t4)
	addi $t2, $t2, -1
	li $v0, 4
	la $a0, undo_2_left
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	sb $t2, ($t4)
	li $v0, 4
	la $a0, newline
	syscall
	j while_take_undo_2
	exit_for_take_undo_2:
exit_while_take_undo_2:
######################### Check win for player 2
	jal isWinner
	bne $v1, 1, not_win_2
	jal printGameBoard
	li $v0, 4
	la $a0, winner2
	syscall
	la $t1, stopgame
	lb $t2, ($t1)
	li $t2, 1
	sb $t2, ($t1)
	j exit
		not_win_2:
			jal printGameBoard
	j Loop
draw: 
	li $v0, 4
	la $a0, drawgame
	syscall
exit:
	li $v0,10
	syscall
Choose_player:
	la $t1, turnchoose
	lb $t2, ($t1)
	beq $t2, $zero, choose_X_O_2    ###### player 2 choose X or O
	
	li $v0, 4
	la $a0, choose
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	bne $t0, $zero, else1
	li $v0, 4
	la $a0, start3
	syscall
	li $v0, 4
	la $a0, start4
	syscall
	j exit_choose
			else1:  
				la $t1, player1
				li $t2, 'O'
				sb $t2, 0($t1)
				la $t1, player2
				li $t2, 'X'
				sb $t2, 0($t1)
				
				li $v0, 4
				la $a0, start1
				syscall
	
				li $v0, 4
				la $a0, start2
				syscall
				j exit_choose
	choose_X_O_2:
	li $v0, 4
	la $a0, choose
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	bne $t0, $zero, else2
	la $t1, player1
	li $t2, 'O'
	sb $t2, 0($t1)
	la $t1, player2
	li $t2, 'X'
	sb $t2, 0($t1)
	li $v0, 4
	la $a0, start2
	syscall
	li $v0, 4
	la $a0, start1
	syscall
	j exit_choose
				else2:
				li $v0, 4
				la $a0, start4
				syscall
	
				li $v0, 4
				la $a0, start3
				syscall
				j exit_choose
	exit_choose:
	jr $ra	
isWinner:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $t1, 0    # i count for row
	li $t2, 0    # j count for column
	for_check_win:
		for_i:	 bgt $t1, 5, exit_for_check_win
			 li $t2, 0
			for_j:  bgt $t2, 6, add_for_i
			        la $t3, turncheck
				lb $t4, ($t3)
				beq $t4, $zero, player2_turn_check # if (turn = 0 player1 check win)
				sb $t4, ($t3)
				move $a0, $t1
				move $a1, $t2
				bge $t2, 4, check_win_col_1
					check_win_row_1:	
						jal getCell
						la $t3, player1
						lb $t4, ($t3)
						bne $v0, $t4, check_win_col_1
							row_1_2:
							addi $a1, $a1, 1
							jal getCell
							la $t3, player1
							lb $t4, ($t3)
							bne $v0, $t4, check_win_col_1
								row_1_3:
								addi $a1, $a1, 1
								jal getCell
								la $t3, player1
								lb $t4, ($t3)
								bne $v0, $t4, check_win_col_1
									row_1_4:
									addi $a1, $a1, 1
									jal getCell
									la $t3, player1
									lb $t4, ($t3)
									bne $v0, $t4, check_win_col_1
									j return_check	
					check_win_col_1:
						move $a0, $t1
						move $a1, $t2
						bge $t1, 3, check_win_diagonal_1
						jal getCell
						la $t3, player1
						lb $t4, ($t3)
						bne $v0, $t4, check_win_diagonal_1
							col_1_2: 
							addi $a0, $a0, 1
							jal getCell
							la $t3, player1
							lb $t4, ($t3)
							bne $v0, $t4, check_win_diagonal_1
								col_1_3:
								addi $a0, $a0, 1
								jal getCell
								la $t3, player1
								lb $t4, ($t3)
								bne $v0, $t4, check_win_diagonal_1
									col_1_4:
									addi $a0, $a0, 1
									jal getCell
									la $t3, player1
									lb $t4, ($t3)
									bne $v0, $t4, check_win_diagonal_1
									j return_check
					check_win_diagonal_1:
						move $a0, $t1
						move $a1, $t2
						blt $t2, 3, check_win_reverse_diagonal_1
						jal getCell
						la $t3, player1
						lb $t4, ($t3)
						bne $v0, $t4, check_win_reverse_diagonal_1
							diagonal_1_2:
							addi $a0, $a0, -1
							addi $a1, $a1, -1
							jal getCell
							la $t3, player1
							lb $t4, ($t3)
							bne $v0, $t4, check_win_reverse_diagonal_1
								diagonal_1_3:
								addi $a0, $a0, -1
								addi $a1, $a1, -1
								jal getCell
								la $t3, player1
								lb $t4, ($t3)
								bne $v0, $t4, check_win_reverse_diagonal_1
									diagonal_1_4:
									addi $a0, $a0, -1
									addi $a1, $a1, -1
									jal getCell
									la $t3, player1
									lb $t4, ($t3)
									bne $v0, $t4, check_win_reverse_diagonal_1
									j return_check
					check_win_reverse_diagonal_1:
						move $a0, $t1
						move $a1, $t2
						bgt $t2, 3, label
						jal getCell
						la $t3, player1
						lb $t4, ($t3)
						bne $v0, $t4, label
							reverse_diagonal_1_2:
							addi $a0, $a0, -1
							addi $a1, $a1, 1
							jal getCell
							la $t3, player1
							lb $t4, ($t3)
							bne $v0, $t4, label
								reverse_diagonal_1_3:
								addi $a0, $a0, -1
								addi $a1, $a1, 1
								jal getCell
								la $t3, player1
								lb $t4, ($t3)
								bne $v0, $t4, label
									reverse_diagonal_1_4:
									addi $a0, $a0, -1
									addi $a1, $a1, 1
									jal getCell
									la $t3, player1
									lb $t4, ($t3)
									bne $v0, $t4, label
									j return_check
		player2_turn_check:
			move $a0, $t1
			move $a1, $t2
			bge $t2, 4, check_win_col_2
					check_win_row_2:	
						jal getCell
						la $t3, player2
						lb $t4, ($t3)
						bne $v0, $t4, check_win_col_2
							row_2_2:
							addi $a1, $a1, 1
							jal getCell
							la $t3, player2
							lb $t4, ($t3)
							bne $v0, $t4, check_win_col_2
								row_2_3:
								addi $a1, $a1, 1
								jal getCell
								la $t3, player2
								lb $t4, ($t3)
								bne $v0, $t4, check_win_col_2
									row_2_4:
									addi $a1, $a1, 1
									jal getCell
									la $t3, player2
									lb $t4, ($t3)
									bne $v0, $t4, check_win_col_2
									j return_check	
					check_win_col_2:
						move $a0, $t1
						move $a1, $t2
						bge $t1, 3, check_win_diagonal_2
						jal getCell
						la $t3, player2
						lb $t4, ($t3)
						bne $v0, $t4, check_win_diagonal_2
							col_2_2: 
							addi $a0, $a0, 1
							jal getCell
							la $t3, player2
							lb $t4, ($t3)
							bne $v0, $t4, check_win_diagonal_2
								col_2_3:
								addi $a0, $a0, 1
								jal getCell
								la $t3, player2
								lb $t4, ($t3)
								bne $v0, $t4, check_win_diagonal_2
									col_2_4:
									addi $a0, $a0, 1
									jal getCell
									la $t3, player2
									lb $t4, ($t3)
									bne $v0, $t4, check_win_diagonal_2
									j return_check
					check_win_diagonal_2:
						move $a0, $t1
						move $a1, $t2
						blt $t2, 3, check_win_reverse_diagonal_2
						jal getCell
						la $t3, player2
						lb $t4, ($t3)
						bne $v0, $t4, check_win_reverse_diagonal_2
							diagonal_2_2:
							addi $a0, $a0, -1
							addi $a1, $a1, -1
							jal getCell
							la $t3, player2
							lb $t4, ($t3)
							bne $v0, $t4, check_win_reverse_diagonal_2
								diagonal_2_3:
								addi $a0, $a0, -1
								addi $a1, $a1, -1
								jal getCell
								la $t3, player2
								lb $t4, ($t3)
								bne $v0, $t4, check_win_reverse_diagonal_2
									diagonal_2_4:
									addi $a0, $a0, -1
									addi $a1, $a1, -1
									jal getCell
									la $t3, player2
									lb $t4, ($t3)
									bne $v0, $t4, check_win_reverse_diagonal_2
									j return_check
					check_win_reverse_diagonal_2:
						move $a0, $t1
						move $a1, $t2
						bgt $t2, 3, label
						jal getCell
						la $t3, player2
						lb $t4, ($t3)
						bne $v0, $t4, label
							reverse_diagonal_2_2:
							addi $a0, $a0, -1
							addi $a1, $a1, 1
							jal getCell
							la $t3, player2
							lb $t4, ($t3)
							bne $v0, $t4, label
								reverse_diagonal_2_3:
								addi $a0, $a0, -1
								addi $a1, $a1, 1
								jal getCell
								la $t3, player2
								lb $t4, ($t3)
								bne $v0, $t4, label
									reverse_diagonal_2_4:
									addi $a0, $a0, -1
									addi $a1, $a1, 1
									jal getCell
									la $t3, player2
									lb $t4, ($t3)
									bne $v0, $t4, label
									j return_check
		
			label:
			addi $t2, $t2, 1
			j for_j
			add_for_i:
			addi $t1, $t1, 1
			j for_i
			return_check:
				li $v1, 1
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
	exit_for_check_win: 
			    la $t3, turncheck
			    lb $t4, ($t3)
			    beq $t4, 1, turncheckto0
			    li $t5, 1
			    move $t4, $t5
			    sb $t4, ($t3)
			    j return_check_win
			    turncheckto0:
			    la $t3, turncheck
			    lb $t4, ($t3)
			    li $t5, 0
			    move $t4, $t5
			    sb $t4, ($t3)
			    return_check_win:
			    
			    li $v1, 0
			    lw $ra, 0($sp)
			    addi $sp, $sp, 4
			    jr $ra
setCell:
	addi $sp,$sp,-16
	sw $s0,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $a2,12($sp)
	
	la $s0,board	#666666
	mul $a0,$a0,7
	add $a0,$a0,$a1
	add $s0,$s0,$a0
	sb $a2, 0($s0)
	
	lw $s0,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $a2,12($sp)
	addi $sp,$sp,16
	jr $ra	
getCell:
	addi $sp,$sp,-12
	sw $s0,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	
	la $s0,board
	mul $a0,$a0,7
	add $a0,$a0,$a1
	add $s0,$s0,$a0
	lb $v0, 0($s0)
	
	lw $s0,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	addi $sp,$sp,12
	jr $ra
printGameBoard:
	li $v0, 4
	la $a0, board1
	syscall
			li $t0, 0               # i = 0
	FOR_PRINT_i: 	
                	li $t1, 0               # j = 0
                	
        FOR_PRINT_j: 	
        		la $s0, board
        		li $v0, 4
                	la $a0, board2
                	syscall
                	
                	mul $t3, $t0, 7 	# $t3 = i * COL
        		add $t3, $t3, $t1 	# $t3 += j
        		add $t3, $s0, $t3
        		lb $a0, 0($t3)
        		li $v0,11
        		syscall
        
        		
        		addi $t1,$t1,1
        		blt $t1,7,FOR_PRINT_j
        		
        		li $v0, 4
                	la $a0, board2
                	syscall
        		
        		li $v0, 4
                	la $a0, newline
                	syscall
        		
        		addi $t0,$t0,1
        		blt $t0, 6, FOR_PRINT_i    # if(i > ROW(6)), Branch to RETURN
        		
			jr $ra
instruction: 
	li $v0, 4
	la $a0, ins1
	syscall
	li $v0, 4
	la $a0, ins2
	syscall
	li $v0, 4
	la $a0, ins3
	syscall
	li $v0, 4
	la $a0, ins4
	syscall
	li $v0, 4
	la $a0, ins5
	syscall
	li $v0, 4
	la $a0, ins6
	syscall
	li $v0, 4
	la $a0, ins7
	syscall
	jr $ra
     
random_player:
	li $v0, 4
	la $a0, random
	syscall
	li $v0, 5
	syscall
	move $t1, $v0
	li $v0, 41
	move $a0, $t1
	syscall 
	move $t7, $a0
	blt $t7, $zero, random_player2
	li $v0, 4
	la $a0, random_1
	syscall
	j exit_random
	random_player2:
	la $t1, turnchoose
	lb $t2, ($t1)
	sb $zero, ($t1)
	la $t1, turncheck
	lb $t2, ($t1)
	sb $zero, ($t1)
	li $v0, 4
	la $a0, random_2
	syscall
	exit_random: 
	jr $ra	
                	
	
