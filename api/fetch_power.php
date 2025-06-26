<?php
include 'database.php';
header('Content-Type: application/json');

if (isset($_GET['tenant_id'])) {
    $tenant_id = intval($_GET['tenant_id']);

    $stmt = $conn->prepare("SELECT id, tenant_id, current_kw, status, updated_at FROM tenant_power WHERE tenant_id = ?");
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
    echo json_encode(["error" => "Missing tenant_id"]);
}
$conn->close();
?>
