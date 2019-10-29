class State:
    def __init__(self,  name ,  first,  final, error):
        self.__is_first = first
        self.__is_final = final
        self.__name = name
        self.__is_error = error
    
    def get_final(self):
        return self.__is_final

    def get_first(self):
        return self.__is_first

    def get_error(self):
        return self.__is_error

    def get_name(self):
        return self.__name

    def get_info(self):
        message =  "\t\tThe state " + self.__name
        if ( self.__is_first == True  and self.__is_final == False):
            message += " its the initial state"
        if ( self.__is_first == True  and self.__is_final == True):
            message += " is the initial state and is final state"
        if ( self.__is_first == False  and self.__is_final == True):
            message += " is final state"
        if (self.__is_error == True):
            message += " is the error state"
        message += "\n"
        print( message)