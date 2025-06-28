#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// WiFi credentials
const char* ssid = "jesus";
const char* password = "jesus1234";

// API endpoints
const char* apiURL_GET = "http://192.168.1.103/tenant_power_control_system/backend/api_get_power.php";
const char* apiURL_POST = "http://192.168.1.103/tenant_power_control_system/backend/hardware_api.php";

// Tenant settings
struct Tenant {
  int id;
  int relayPin;
  int ledPin;
  int currentPin;
  int voltagePin;
  float current_kw;
};

Tenant tenants[] = {
  {1, 18, 15, 32, 34, 5.0},  // Tenant 1
  {2, 19, 2, 33, 35, 5.0}    // Tenant 2
};

const int tenantCount = sizeof(tenants) / sizeof(tenants[0]);

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected!");

  for (int i = 0; i < tenantCount; i++) {
    pinMode(tenants[i].relayPin, OUTPUT);
    pinMode(tenants[i].ledPin, OUTPUT);
    digitalWrite(tenants[i].relayPin, HIGH); // Relay ON
    digitalWrite(tenants[i].ledPin, LOW);    // LED OFF
  }
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(apiURL_GET);
    int code = http.GET();

    if (code == 200) {
      String payload = http.getString();
      Serial.println("GET Payload: " + payload);

      DynamicJsonDocument doc(2048);
      DeserializationError error = deserializeJson(doc, payload);

      if (!error) {
        JsonArray arr = doc.as<JsonArray>();

        for (int i = 0; i < tenantCount; i++) {
          for (JsonObject obj : arr) {
            if (obj["tenant_id"] == tenants[i].id) {
              tenants[i].current_kw = obj["current_kw"];
              break;
            }
          }
//
//          // Read sensors
//          int rawCurrent = analogRead(tenants[i].currentPin);
//          int rawVoltage = analogRead(tenants[i].voltagePin);
//          float current = rawCurrent * (3.3 / 4095.0); // Placeholder
//          float voltage = rawVoltage * (3.3 / 4095.0); // Placeholder
//          float powerUsed = voltage * current;
//
//          Serial.printf("Tenant %d → Raw: C=%d, V=%d | %.2fV, %.2fA, %.2fkW\n",
//            tenants[i].id, rawCurrent, rawVoltage, voltage, current, powerUsed);



          // Replace inside loop:
          int rawCurrent = analogRead(tenants[i].currentPin);
          int rawVoltage = analogRead(tenants[i].voltagePin);
          
          float voltageSense = rawVoltage * 3.3 / 4095.0;
          float currentSense = rawCurrent * 3.3 / 4095.0;
          
          // Voltage line (if using 100k/10k divider = 11x)
          float lineVoltage = voltageSense * 11.0;
          
          // Current (if using ACS712 5A)
          float currentOffset = 2.5;
          float sensitivity = 0.185; // mV per amp
          float lineCurrent = (currentSense - currentOffset) / sensitivity;
          if (lineCurrent < 0) lineCurrent = 0;
          
          // Power calculation (approximate)
          float powerUsed = lineVoltage * lineCurrent;
          
          Serial.printf("Tenant %d → V: %.2fV, I: %.2fA, P: %.2fkW\n", tenants[i].id, lineVoltage, lineCurrent, powerUsed);

          // Update usage
          if (tenants[i].current_kw > 0) {
            tenants[i].current_kw -= powerUsed;
            if (tenants[i].current_kw < 0) tenants[i].current_kw = 0;
            sendUsageUpdate(tenants[i].id, tenants[i].current_kw);
          }

          // Relay and LED control
          if (tenants[i].current_kw <= 0) {
            digitalWrite(tenants[i].relayPin, LOW); // Power OFF
            digitalWrite(tenants[i].ledPin, HIGH);  // LED ON (disconnected)
            Serial.printf("Relay OFF for Tenant %d\n", tenants[i].id);
          } else {
            digitalWrite(tenants[i].relayPin, HIGH); // Power ON
            digitalWrite(tenants[i].ledPin, LOW);    // LED OFF
            Serial.printf("Relay ON for Tenant %d\n", tenants[i].id);
          }

          delay(1000); // Delay between tenants
        }

      } else {
        Serial.println("JSON Parse Error!");
      }
    } else {
      Serial.printf("GET error: %d\n", code);
    }
    http.end();
  } else {
    Serial.println("WiFi disconnected.");
  }

  delay(5000); // Main loop delay
}

void sendUsageUpdate(int tenantId, float remainingKw) {
  HTTPClient http;
  http.begin(apiURL_POST);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");

  String status = (remainingKw <= 0) ? "disconnected" : "connected";
  String postData = "tenant_id=" + String(tenantId) +
                    "&current_kw=" + String(remainingKw, 3) +
                    "&status=" + status;

  int httpCode = http.POST(postData);
  String response = http.getString();

  Serial.printf("POST tenant %d → %.2fkW, status=%s → Code: %d → %s\n",
    tenantId, remainingKw, status.c_str(), httpCode, response.c_str());

  http.end();
}
