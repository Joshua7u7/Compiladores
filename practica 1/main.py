import subprocess as sp
from state import State
from transition import Transitions
from road import Road
class Main:

    states_position = 0
    alphabet_position = 1
    initial_state_position = 2
    final_states_position = 3
    initial_transition = 4

    def __init__(self):
        sp.call( 'cls' , shell = True)

    def  read_file(self):
        self.filename = input("Type the filename: ")
        if  self.filename.endswith('.txt')  == False:
            print("I´m sorry, the filename must ends with .txx")
            exit(1)
        else:
            self.process_file()
        
    def process_file(self):
        file = open(self.filename, "r")
        content = file.read()
        content = content.splitlines()
        self.final_transition = len(content)
        self.states = [ state.strip() for state in content[ self.states_position ].split(',') ]
        self.alphabet = [ symbol.strip() for symbol in content[ self.alphabet_position ].split(',') ]
        self.initial_state = content[ self.initial_state_position ].split(',')[0].strip()
        self.final_states = [ state.strip() for state in content[ self.final_states_position ].split(',') ]
        self.transitions = []
        for index in range (self.initial_transition, self.final_transition):
            self.transitions.append( [ element.strip() for element in content[index].split(',') ] )
        self.process_information()

    def set_states(self):
        self.state_objects = []
        for state in self.states:
            is_first = ( state == self.initial_state )
            is_last = ( state in self.final_states )
            self.state_objects.append( State(state, is_first, is_last, False) )
    
    def set_transitions(self):
        self.transitions_objects = []
        self.to_fill = []
        find_error = False
        for transition in self.transitions:
            if ( (transition[2] not in self.states) and (find_error == False) ):
                self.state_objects.append( State( transition[2] , False, False, True ) )
                find_error = True
            self.transitions_objects.append( Transitions( transition[0], transition[1], transition[2] ) )
            self.to_fill.append( [transition[0], transition[1]])
        if find_error == False:
            self.state_objects.append( State( 'e', False, False, True ) )
            for symbol in self.alphabet:
                self.transitions_objects.append( Transitions( 'e', symbol , 'e' ) )
                self.to_fill.append( ['e', symbol])
        
    def fill_transition(self):
        error_state = ''
        for state in self.state_objects:
            if state.get_error() == True:
                error_state = state.get_name()
                break
        for state in self.state_objects:
            for symbol in self.alphabet:
                if ( [state.get_name(), symbol] not in self.to_fill):
                    self.transitions_objects.append(Transitions(state.get_name(), symbol, error_state))

    def process_information(self):
        self.set_states()
        self.set_transitions()
        self.fill_transition()
        self.states = self.state_objects
        self.transitions = self.transitions_objects

    def change_road_status(self):
        for road in self.roads:
                road.check_now = True
    
    def create_new_roads(self, road, aux_state):
        current_way = [x[:] for x in road.way]
        for index in range (1, len(aux_state)):
            self.roads.append(Road(current_way, False))
            self.roads[-1].add_to_road(aux_state[index])

    def show_roads(self):
            for road_index in range(0, len(self.roads)):
                if (self.roads[road_index].way[-1] in self.final_states):
                    self.roads[road_index].get_road(self.new_string)

    
    def get_string(self):
        self.new_string = input("Type the string to validate: ")
        current_state = self.initial_state
        self.roads = [Road([current_state], True)]
        for symbol in self.new_string:
            self.change_road_status()
            for road in self.roads:
                if road.check_now == True:
                    aux_state = []
                    for transition in self.transitions_objects:
                        aux_state.append(transition.get_next_state(road.way[-1], symbol))
                    aux_state = [state for state in aux_state if state != "error"]
                    if ( len(aux_state) > 1 ):
                        self.create_new_roads(road, aux_state)
                        road.add_to_road(aux_state[0])
                    else:
                        road.add_to_road(aux_state[0])
            
main = Main()
main.read_file()
print("\n STATES INFORMATION \n")
for state in main.states:
    state.get_info()
print("\n TRANSITIONS\n")
for transition in main.transitions:
    transition.get_information()
input("Press enter to continue")
sp.call( 'cls' , shell = True)
main.get_string()
main.show_roads()

