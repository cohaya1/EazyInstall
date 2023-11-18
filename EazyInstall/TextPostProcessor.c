//
//  TextPostProcessor.c
//  EazyInstall
//
//  Created by Chika Ohaya on 11/12/23.
//

#include "TextPostProcessor.h"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

char* processText(const char* input) {
    if (input == NULL) {
        return NULL;
    }

    int length = strlen(input);
    char* result = malloc(length + 1);
    if (result == NULL) {
        return NULL; // Memory allocation failed
    }

    int j = 0;
    int inWord = 0;
    for (int i = 0; i < length; i++) {
        if (isspace(input[i])) {
            if (inWord) {
                result[j++] = ' ';
                inWord = 0;
            }
        } else {
            result[j++] = input[i];
            inWord = 1;
        }
    }
    result[j] = '\0';

    // Trim trailing space if any
    if (j > 0 && isspace(result[j - 1])) {
        result[j - 1] = '\0';
    }

    return result;
}
