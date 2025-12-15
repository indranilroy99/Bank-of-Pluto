#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Vulnerable function: Format string vulnerability
void generate_statement(char *account, char *format) {
    char account_buffer[50];
    
    // Copy account number
    strncpy(account_buffer, account, sizeof(account_buffer) - 1);
    account_buffer[sizeof(account_buffer) - 1] = '\0';
    
    printf("=== Account Statement ===\n");
    printf("Account Number: %s\n", account_buffer);
    printf("Statement Format: ");
    
    // VULNERABLE: Using user input directly in printf
    // This allows format string attacks!
    printf(format);  // Dangerous! User can inject format specifiers
    printf("\n\n");
    
    printf("Date       | Description           | Amount    | Balance\n");
    printf("-----------|-----------------------|-----------|----------\n");
    printf("2024-01-20 | Salary Deposit        | $3,000.00 | $12,450.00\n");
    printf("2024-01-15 | Online Purchase       | -$150.00  | $9,450.00\n");
    printf("2024-01-10 | Bill Payment          | -$200.00  | $9,600.00\n");
    printf("2024-01-05 | Interest Earned       | $50.00    | $9,800.00\n");
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <account> <format>\n", argv[0]);
        return 1;
    }
    
    char *account = argv[1];
    char *format = argv[2];
    
    generate_statement(account, format);
    
    return 0;
}

