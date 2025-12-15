#!/usr/bin/env php
<?php
header('Content-Type: text/plain');

// Get POST data
$recipient = $_POST['recipient'] ?? '';
$amount = $_POST['amount'] ?? '';
$description = $_POST['description'] ?? '';

// Sanitize for shell execution (but still vulnerable to buffer overflow in C program)
$recipient = escapeshellarg($recipient);
$amount = escapeshellarg($amount);
$description = !empty($description) ? escapeshellarg($description) : '';

// Path to compiled binary
$binary_path = __DIR__ . '/../bin/stack_overflow';

// Build command
if (!empty($description)) {
    $command = "$binary_path $recipient $amount $description 2>&1";
} else {
    $command = "$binary_path $recipient $amount 2>&1";
}

// Execute vulnerable C program
exec($command, $output, $return_code);

// Return output
echo implode("\n", $output);

// Realistic bank error messages for buffer overflow
if ($return_code === 133 || $return_code === 139) {
    echo "\n\n";
    echo "Error Code: TRF-5001\n";
    echo "Transaction Processing Error\n";
    echo "─────────────────────────────────────────────\n";
    echo "We encountered an internal error while processing your transfer request.\n";
    echo "Please verify that the recipient account number is correct and try again.\n\n";
    echo "If the problem persists, please contact our support team at:\n";
    echo "support@bankofpluto.com or call 1-800-BANK-PLT\n\n";
    echo "Reference ID: " . substr(md5(time() . $recipient), 0, 12) . "\n";
    echo "Timestamp: " . date('Y-m-d H:i:s') . "\n";
} elseif ($return_code !== 0) {
    echo "\n\nError Code: TRF-5000\n";
    echo "Transaction Processing Error\n";
    echo "─────────────────────────────────────────────\n";
    echo "Unable to process your request at this time.\n";
    echo "Please try again later or contact support.\n";
}
?>
