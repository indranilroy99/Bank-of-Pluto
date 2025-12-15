#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Vulnerable function: Stack-based buffer overflow
void process_transfer(char *recipient, char *amount, char *description) {
    char buffer[50];  // Small buffer - vulnerable!
    char amount_buffer[20];
    
    // VULNERABLE: Using strcpy without bounds checking
    strcpy(buffer, recipient);
    strcpy(amount_buffer, amount);
    
    // If description is provided, copy it (also vulnerable)
    if (description != NULL && strlen(description) > 0) {
        char desc_buffer[30];
        strcpy(desc_buffer, description);  // Another vulnerable copy
    }
    
    printf("Transfer processed successfully!\n");
    printf("Recipient: %s\n", buffer);
    printf("Amount: $%s\n", amount_buffer);
    printf("Status: Completed\n");
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <recipient> <amount> [description]\n", argv[0]);
        return 1;
    }
    
    char *recipient = argv[1];
    char *amount = argv[2];
    char *description = (argc > 3) ? argv[3] : NULL;
    
    process_transfer(recipient, amount, description);
    
    return 0;
}

