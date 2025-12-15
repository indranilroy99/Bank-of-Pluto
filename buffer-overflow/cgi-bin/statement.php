#!/usr/bin/env php
<?php
header('Content-Type: text/plain');

// Get POST data
$account = $_POST['account'] ?? '';
$format = $_POST['format'] ?? '';

// Sanitize for shell execution
$account = escapeshellarg($account);
$format = escapeshellarg($format);

// Path to compiled binary
$binary_path = __DIR__ . '/../bin/format_string';

// Build command
$command = "$binary_path $account $format 2>&1";

// Execute vulnerable C program
exec($command, $output, $return_code);

// Return output
echo implode("\n", $output);

if ($return_code !== 0) {
    echo "\n[Error: Program exited with code $return_code]";
}
?>

