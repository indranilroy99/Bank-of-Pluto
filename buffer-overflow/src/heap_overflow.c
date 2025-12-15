#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Vulnerable function: Heap-based buffer overflow
void process_history(char *account, char *filter, char *limit_str) {
    int limit = atoi(limit_str);
    
    // Allocate small buffer on heap
    char *filter_buffer = (char *)malloc(100);  // Small allocation
    char *account_buffer = (char *)malloc(50);
    
    if (filter_buffer == NULL || account_buffer == NULL) {
        printf("Memory allocation failed\n");
        return;
    }
    
    // VULNERABLE: Copying without checking length
    strcpy(account_buffer, account);
    
    // VULNERABLE: Heap overflow if filter is too long
    strcpy(filter_buffer, filter);  // Can overflow if filter > 100 chars
    
    printf("Transaction History for Account: %s\n", account_buffer);
    printf("Filter: %s\n", filter_buffer);
    printf("Records to display: %d\n\n", limit);
    
    // Simulate transaction records
    printf("Date       | Type      | Amount    | Balance\n");
    printf("-----------|-----------|-----------|----------\n");
    printf("2024-01-15 | Deposit   | $500.00   | $12,450.00\n");
    printf("2024-01-10 | Transfer  | -$200.00  | $11,950.00\n");
    printf("2024-01-05 | Withdraw  | -$100.00  | $12,150.00\n");
    
    free(filter_buffer);
    free(account_buffer);
}

int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Usage: %s <account> <filter> <limit>\n", argv[0]);
        return 1;
    }
    
    char *account = argv[1];
    char *filter = argv[2];
    char *limit = argv[3];
    
    process_history(account, filter, limit);
    
    return 0;
}

