#include "Arg_Parser.h"
#include "My_Error.cpp"


using namespace std;


Arg_Parser::Arg_Parser(int argc, char *argv[]){
    this->argc = argc;
    this->argv = argv;
    begin = argv;
    end = argv + argc;

}

char *Arg_Parser::get(const string &option) {
    char **itr = find(begin, end, option);
    if (itr != end && ++itr != end) return *itr;
    return 0;
}

bool Arg_Parser::exists(const string &option) {
  return find(begin, end, option) != end;
}


char* Arg_Parser::get_ext(char* file_str){
    unsigned int counter = 0;
    int last_pos = -1;

    while(file_str[counter]!='\0'){
        if(file_str[counter]=='.') last_pos = counter;
        counter++;
    }
    if (last_pos == -1){
        My_Error my_error((string("ERROR: FILE ") +
                       string(file_str) + string(" HAS NO EXTENSION! ABORTING."))
                          .c_str());
        throw my_error;
    }
    return file_str + last_pos + 1;
}





