#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// WiFi
const char* ssid = "jesus";
const char* password = "jesus1234";

// Backend
const char* url = "http://berthe-001-site1.jtempurl.com/hardware_api.php";

// Map tenant IDs to GPIO pins
struct Tenant {
  int id;
  int relayPin;
  float current_kw;
};

Tenant tenants[] = {
  {1, 5, 0.0},
  {2, 18, 0.0},
  {3, 19, 0.0}
};

const int tenantCount = sizeof(tenants) / sizeof(tenants[0]);

void setup() {
  Serial.begin(115200);
  delay(1000);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  for (int i = 0; i < tenantCount; i++) {
    pinMode(tenants[i].relayPin, OUTPUT);
    digitalWrite(tenants[i].relayPin, HIGH); // Start ON
  }
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(url);
    int code = http.GET();

    if (code == 200) {
      String payload = http.getString();
      Serial.println("GET Response:");
      Serial.println(payload);

      DynamicJsonDocument doc(2048);
      DeserializationError error = deserializeJson(doc, payload);

      if (!error) {
        for (int i = 0; i < tenantCount; i++) {
          for (JsonObject t : doc.as<JsonArray>()) {
            if (t["tenant_id"] == tenants[i].id) {
              tenants[i].current_kw = t["current_kw"];
              Serial.print("Tenant ");
              Serial.print(tenants[i].id);
              Serial.print(" current_kWh: ");
              Serial.println(tenants[i].current_kw);

              // Logic: Decrease and send update
              if (tenants[i].current_kw > 0) {
                tenants[i].current_kw -= 1;
                if (tenants[i].current_kw < 0) tenants[i].current_kw = 0;

                sendUpdate(tenants[i].id, tenants[i].current_kw);
              }

              // Relay control
              if (tenants[i].current_kw <= 0) {
                digitalWrite(tenants[i].relayPin, LOW);
                Serial.print("Relay OFF for Tenant ");
              } else {
                digitalWrite(tenants[i].relayPin, HIGH);
                Serial.print("Relay ON for Tenant ");
              }

              Serial.println(tenants[i].id);
            }
          }
        }
      } else {
        Serial.println("JSON Parse Error!");
      }
    } else {
      Serial.print("GET Error: ");
      Serial.println(code);
    }

    http.end();
  } else {
    Serial.println("WiFi not connected.");
  }

  delay(30000);
}

void sendUpdate(int tenant_id, float current_kw) {
  HTTPClient http;
  http.begin(url);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");

  String postData = "tenant_id=" + String(tenant_id) + "&used_kw=1";

  int response = http.POST(postData);
  String res = http.getString();

  Serial.print("POST (Tenant ");
  Serial.print(tenant_id);
  Serial.print(") Response: ");
  Serial.println(res);

  http.end();
}
