class Transitions:
    def __init__(self, current_state, symbol, next_state):
        self.current_state = current_state
        self.symbol = symbol
        self.next_state = next_state

    def get_next_state(self, current_state, symbol):
        if ( (current_state == self.current_state) and (symbol == self.symbol)):
            return self.next_state
        else:
            return "error"
    
    def get_information(self):
        print("\t\tS ( " + self.current_state + " , " + self.symbol + " )  =  " + self.next_state + "\n")
