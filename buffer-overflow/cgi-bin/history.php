#!/usr/bin/env php
<?php
header('Content-Type: text/plain');

// Get POST data
$account = $_POST['account'] ?? '';
$filter = $_POST['filter'] ?? '';
$limit = $_POST['limit'] ?? '10';

// Sanitize for shell execution
$account = escapeshellarg($account);
$filter = escapeshellarg($filter);
$limit = escapeshellarg($limit);

// Path to compiled binary
$binary_path = __DIR__ . '/../bin/heap_overflow';

// Build command
$command = "$binary_path $account $filter $limit 2>&1";

// Execute vulnerable C program
exec($command, $output, $return_code);

// Return output
echo implode("\n", $output);

if ($return_code !== 0) {
    echo "\n[Error: Program exited with code $return_code]";
}
?>

