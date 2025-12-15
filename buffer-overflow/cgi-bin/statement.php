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

// Get original format before escaping
$original_format = $_POST['format'] ?? '';

// Return output
$output_text = implode("\n", $output);
echo $output_text;

// Check for format string attacks and provide realistic but informative responses
$format_attack = false;
$advanced_payload = false;

if (strpos($original_format, '%') !== false) {
    $format_attack = true;
    
    // Detect advanced payloads
    if (strpos($original_format, '%p') !== false || 
        strpos($original_format, '%n') !== false ||
        substr_count($original_format, '%') > 5) {
        $advanced_payload = true;
    }
}

// For format string attacks, show realistic output but with leaked data visible
if ($format_attack && !$advanced_payload) {
    // Basic format string - just show the output (memory leak is visible in the statement)
    // No extra message, looks like normal output but with hex values
} elseif ($format_attack && $advanced_payload) {
    // Advanced payload - show more "juicy" information
    echo "\n\n";
    echo "─────────────────────────────────────────────────────────────\n";
    echo "Statement Generation Complete\n";
    echo "─────────────────────────────────────────────────────────────\n";
    echo "Format: " . htmlspecialchars($original_format) . "\n";
    echo "Note: Advanced format processing detected.\n";
    echo "Memory addresses and stack contents have been included in output.\n";
    echo "\n";
    echo "System Information Leaked:\n";
    echo "• Stack pointer values: Visible in format output above\n";
    echo "• Memory layout: Revealed through pointer addresses\n";
    echo "• Potential sensitive data: May be present in stack dump\n";
    echo "\n";
    echo "Note: This output contains low-level system information.\n";
    echo "─────────────────────────────────────────────────────────────\n";
}

if ($return_code !== 0) {
    echo "\n\nError Code: STM-4001\n";
    echo "Statement Generation Error\n";
    echo "─────────────────────────────────────────────\n";
    echo "Unable to generate statement in the requested format.\n";
    echo "Please try a different format (PDF, TXT, or HTML).\n";
}
?>
