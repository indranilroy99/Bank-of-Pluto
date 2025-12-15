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

// Provide clear feedback for buffer overflow
if ($return_code === 133 || $return_code === 139) {
    echo "\n\n";
    echo "╔════════════════════════════════════════════════════════════╗\n";
    echo "║  🚨 BUFFER OVERFLOW DETECTED! 🚨                          ║\n";
    echo "╠════════════════════════════════════════════════════════════╣\n";
    echo "║  Exit Code: $return_code (Segmentation Fault)              ║\n";
    echo "║                                                            ║\n";
    echo "║  What happened:                                            ║\n";
    echo "║  • The recipient field buffer is only 50 bytes            ║\n";
    echo "║  • You sent more than 50 characters                        ║\n";
    echo "║  • The program tried to write beyond the buffer           ║\n";
    echo "║  • This caused a SEGMENTATION FAULT (memory violation)    ║\n";
    echo "║                                                            ║\n";
    echo "║  This is a STACK BUFFER OVERFLOW vulnerability!            ║\n";
    echo "║  In a real attack, this could allow code execution.       ║\n";
    echo "╚════════════════════════════════════════════════════════════╝\n";
} elseif ($return_code !== 0) {
    echo "\n\n[Error: Program exited with code $return_code]";
}
?>

