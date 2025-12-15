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

if ($return_code !== 0) {
    echo "\n[Error: Program exited with code $return_code]";
}
?>

