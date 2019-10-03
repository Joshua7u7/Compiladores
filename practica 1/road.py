class Road:

    way = []
    def __init__(self, road, check):
        self.way = road
        self.check_now = check

    def add_to_road(self, next_state):
        self.way.append(next_state)
    
    def get_road(self, alphabet):
        final_road = "\n\t\t"
        for state_index in range (0, len(self.way)):
            if (state_index < len(self.way) -1):
                final_road += "  --->  " + self.way[state_index] + "[" + alphabet[state_index ] + "]" 
            else:
                final_road += "  --->  " + self.way[state_index]
        final_road += "\n"
        print(final_road) 
