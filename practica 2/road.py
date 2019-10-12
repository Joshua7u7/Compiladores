class Road:

    way = []
    def __init__(self, road, check):
        self.way = road
        self.check_now = check
        self.error_chars = []

    def add_to_road(self, next_state):
        self.way.append(next_state)
    
    def get_road(self, alphabet):
        final_road = "\n\t\t"
        for state_index in range (0, len(self.way)):
            if (state_index < len(self.way) -1):
                final_road += "  --->  " + self.way[state_index] + "["  + "]" 
            else:
                final_road += "  --->  " + self.way[state_index]
        final_road += "\n Errors :\n"
        for error in self.error_chars:
            final_road += "Status " + error[0] + " handle the error with the symbol " + error[1] +"\n" 
        print(final_road) 

    def add_error(self, status, character):
        self.error_chars.append((status, character))
