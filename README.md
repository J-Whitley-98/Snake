# Snake: 
    # Godot 4.1 - GDScript2
    # Version 0.2.0: 11/12/23
    # 3D Snake Game
      # 1 Game mode of classic snake
  # Current Bugs:
    # Food can still spawn inside of snake tail and inside itself.
      # This doesn't really break game behaviour, but maybe that's just because I'm not that good at snake.
    # Snake tail is designed to delete from end to head one by one, currently broken. 
      # Bandaid applied, tail currently deletes all at once.
    # Turns out snake is not functional on an uneven grid :( 
        # So I can either add a tile in the center of the grids and move the snake.
        # Or just recode the grid generator to be even and move the camera, keep the snake at 0,0
            # This will also mean recoding how the snake detects walls and what not
    # Note: Snake handles 2 food in one tile just fine tail and all!
  # Upcoming Updates:
    # Tying game to a web page and Github hosting 
    # Code clean-up in immutable snake behaviour and classic game mode.
      # These will become the template for further game modes.
    # Bug fixing.
    # Fleshing out of menu components.
        # In game tips on what your goal is, what kills you, etc.
# First Update: Wednesday - 11/15/23
