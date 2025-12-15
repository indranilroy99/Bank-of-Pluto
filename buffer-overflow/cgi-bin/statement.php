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

// Check if format string attack was used
$format_attack = false;
if (strpos($original_format, '%') !== false) {
    $format_attack = true;
}

// Return output
$output_text = implode("\n", $output);
echo $output_text;

// Provide clear feedback for format string vulnerability
if ($format_attack) {
    echo "\n\n";
    echo "╔════════════════════════════════════════════════════════════╗\n";
    echo "║  🔍 FORMAT STRING VULNERABILITY EXPLOITED! 🔍              ║\n";
    echo "╠════════════════════════════════════════════════════════════╣\n";
    echo "║  What happened:                                            ║\n";
    $format_display = substr($original_format, 0, 40);
    echo "║  • You used format specifiers: " . str_pad($format_display, 40) . "║\n";
    echo "║                                                            ║\n";
    echo "║  Format Specifier Meanings:                                ║\n";
    echo "║  • %x = reads hexadecimal values from the stack          ║\n";
    echo "║  • %p = reads pointer addresses from memory               ║\n";
    echo "║  • %s = attempts to read strings from memory addresses    ║\n";
    echo "║  • %n = writes to memory (number of chars printed)        ║\n";
    echo "║                                                            ║\n";
    echo "║  ⚠️  The values you see above are MEMORY CONTENTS         ║\n";
    echo "║     leaked from the program's stack!                      ║\n";
    echo "║                                                            ║\n";
    echo "║  This is a FORMAT STRING VULNERABILITY!                   ║\n";
    echo "║  Attackers can use this to:                               ║\n";
    echo "║  • Read sensitive data from memory                        ║\n";
    echo "║  • Write to arbitrary memory locations (using %n)         ║\n";
    echo "║  • Potentially execute arbitrary code                     ║\n";
    echo "╚════════════════════════════════════════════════════════════╝\n";
}

if ($return_code !== 0) {
    echo "\n[Error: Program exited with code $return_code]";
}
?>

