#include <WiFi.h>
#include <HTTPClient.h>

// WiFi credentials
//const char* ssid = "jesus";
//const char* password = "12345678j"; 
const char* ssid = "jesus";
const char* password = "jesus1234";

//const char* ssid = "HUAWEI-B310-68AD";
//const char* password = "YALJG3Y7FH6";
// Backend API URL
const char* serverURL = "http://berthe-001-site1.jtempurl.com/hardware_api.php";


// Configuration
const int tenant_id = 1;         // Change to actual tenant ID
float used_kw = 0.25;            // Example usage sent every 30 sec

void setup() {
  Serial.begin(115200);
  delay(1000);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  // Wait until connected
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi Connected!");
  Serial.println("IP Address: " + WiFi.localIP().toString());
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    // Create POST data
    String postData = "tenant_id=" + String(tenant_id) + "&used_kw=" + String(used_kw, 2);

    // Setup and send request
    http.begin(serverURL);
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");
    
    int httpResponseCode = http.POST(postData);

    // Print result
    Serial.print("HTTP Response Code: ");
    Serial.println(httpResponseCode);
    String response = http.getString();
    Serial.println("Server Response: " + response);

    http.end();
  } else {
    Serial.println("WiFi disconnected. Retrying...");
  }

  delay(30000);  // Wait 30 seconds before sending again
}
