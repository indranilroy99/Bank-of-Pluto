<?php
// Simple router for PHP built-in server on macOS
// This allows PHP files in cgi-bin to be executed

$requestUri = $_SERVER['REQUEST_URI'];
$requestPath = parse_url($requestUri, PHP_URL_PATH);

// Remove leading slash
$requestPath = ltrim($requestPath, '/');

// If it's a CGI request, execute the PHP file
if (strpos($requestPath, 'cgi-bin/') === 0) {
    $filePath = __DIR__ . '/' . $requestPath;
    
    if (file_exists($filePath) && is_executable($filePath)) {
        // Set environment variables
        $_SERVER['REQUEST_METHOD'] = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        
        // Execute the PHP file
        include $filePath;
        exit;
    }
}

// For other files, let PHP built-in server handle it
return false;

