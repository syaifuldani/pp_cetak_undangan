<?php
session_start();
require_once '../config/connection.php';
require_once '../config/midtrans_config.php';

try {
    // Validasi session
    if (!isset($_SESSION['user_id'])) {
        throw new Exception('Anda harus login terlebih dahulu');
    }

    // Get input data
    $input = json_decode(file_get_contents('php://input'), true);

    if (!isset($input['order_id'])) {
        throw new Exception('Order ID tidak ditemukan');
    }

    // Process existing order payment
    $snap_token = process_existing_order($input['order_id'], $_SESSION['user_id']);

    // Return snap token
    echo json_encode([
        'status' => 'success',
        'snap_token' => $snap_token
    ]);

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}