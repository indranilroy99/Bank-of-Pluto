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

// Realistic bank error messages for heap overflow
if ($return_code === 134 || $return_code === 139) {
    echo "\n\n";
    echo "Error Code: HIS-6001\n";
    echo "Transaction History Retrieval Error\n";
    echo "─────────────────────────────────────────────\n";
    echo "We encountered an internal error while retrieving your transaction history.\n";
    echo "The filter criteria may be too complex or contain invalid characters.\n\n";
    echo "Please try:\n";
    echo "• Using simpler filter terms\n";
    echo "• Reducing the number of characters in your filter\n";
    echo "• Contacting support if the issue persists\n\n";
    echo "Reference ID: " . substr(md5(time() . $filter), 0, 12) . "\n";
    echo "Timestamp: " . date('Y-m-d H:i:s') . "\n";
} elseif ($return_code !== 0) {
    echo "\n\nError Code: HIS-6000\n";
    echo "Transaction History Error\n";
    echo "─────────────────────────────────────────────\n";
    echo "Unable to retrieve transaction history at this time.\n";
    echo "Please try again later.\n";
}
?>
