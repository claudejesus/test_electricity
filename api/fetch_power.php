<?php
// fetch_power.php

header('Content-Type: application/json');

require_once 'database.php'; // Your existing DB connection file

if (isset($_GET['tenant_id'])) {
    $tenant_id = intval($_GET['tenant_id']);

    $sql = "SELECT id, tenant_id, current_kw, status, updated_at FROM tenant_power WHERE tenant_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $tenant_id);
    $stmt->execute();

    $result = $stmt->get_result();
    if ($row = $result->fetch_assoc()) {
        echo json_encode($row);
    } else {
        echo json_encode(["error" => "Tenant not found"]);
    }

    $stmt->close();
} else {
    echo json_encode(["error" => "tenant_id is required"]);
}

$conn->close();
?>
