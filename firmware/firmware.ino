#include "wifiCredentials.h"
#include <ESP8266WiFi.h>

class motor {
public:
  void init(int pinA, int pinB) {
    this->pinA = pinA;
    this->pinB = pinB;
    
    pinMode(pinA, OUTPUT);
    pinMode(pinB, OUTPUT);

    this->stop();
  }
    
  void stop() {
    digitalWrite(this->pinA, 1);
    digitalWrite(this->pinB, 1);
  }
  void spin(bool dir) {
    if(dir) {
      digitalWrite(this->pinA, 0);
      digitalWrite(this->pinB, 1);
    }else {
      digitalWrite(this->pinA, 1);
      digitalWrite(this->pinB, 0);
    }
  }

private:
  int pinA, pinB;
};

motor left, right;


WiFiServer espServer(80); /* Instance of WiFiServer with port number 80 */
/* 80 is the Port Number for HTTP Web Server */

void setup() {
  Serial.begin(115200); /* Begin Serial Communication with 115200 Baud Rate */
    
  left.init(15, 13);
  right.init(12, 14);

  Serial.print("\n");
  Serial.print("Connecting to: ");
  Serial.println(ssid);
  WiFi.mode(WIFI_STA); /* Configure ESP8266 in STA Mode */
  WiFi.begin(ssid, password); /* Connect to Wi-Fi based on above SSID and Password */
  while(WiFi.status() != WL_CONNECTED)
  {
    Serial.print("*");
    delay(500);
  }
  Serial.print("\n");
  Serial.print("Connected to Wi-Fi: ");
  Serial.println(WiFi.SSID());
  delay(100);

  Serial.print("\n");
  Serial.println("Starting ESP8266 Web Server...");
  espServer.begin(); /* Start the HTTP web Server */
  Serial.println("ESP8266 Web Server Started");
  Serial.print("\n");
  Serial.print("The URL of ESP8266 Web Server is: ");
  Serial.print("http://");
  Serial.println(WiFi.localIP());
  Serial.print("\n");
  Serial.println("Use the above URL in your Browser to access ESP8266 Web Server\n");
}

void loop() {
  WiFiClient client = espServer.available(); /* Check if a client is available */
  if(!client)
  {
    return;
  }

  Serial.println("New Client!!!");

  String request = client.readStringUntil('\r'); /* Read the first line of the request from client */
  Serial.println(request); /* Print the request on the Serial monitor */
  /* The request is in the form of HTTP GET Method */ 
  client.flush();

  /* Extract the URL of the request */
  /* We have four URLs. If IP Address is 192.168.1.6 (for example),
   * then URLs are: 
   * 192.168.1.6/GPIO4ON and its request is GET /GPIO4ON HTTP/1.1
   * 192.168.1.6/GPIO4OFF and its request is GET /GPIO4OFF HTTP/1.1
   * 192.168.1.6/GPIO5ON and its request is GET /GPIO5ON HTTP/1.1
   * 192.168.1.6/GPIO4OFF and its request is GET /GPIO5OFF HTTP/1.1
   */
   /* Based on the URL from the request, turn the LEDs ON or OFF */
  if (request.indexOf("/FORWARD") != -1) 
  {
    Serial.println("Forward");

    left.spin(1);
    right.spin(1);
  }

  if (request.indexOf("/LEFT") != -1) 
  {
    Serial.println("Left");

    left.spin(0);
    right.spin(1);
  }

  if (request.indexOf("/RIGHT") != -1) 
  {
    Serial.println("Right");
    
    left.spin(1);
    right.spin(0);
  }

  if (request.indexOf("/BACKWARD") != -1) 
  {
    Serial.println("Backwards");
    
    left.spin(0);
    right.spin(0);
  }

  if (request.indexOf("/STOP") != -1) 
  {
    Serial.println("Stop");
      left.stop();
    right.stop();
  }

  
 


  /* HTTP Response in the form of HTML Web Page */
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html");
  client.println(); //  IMPORTANT
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
  client.println("<head>");
  client.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
  client.println("<link rel=\"icon\" href=\"data:,\">");
  /* CSS Styling for Buttons and Web Page */
  client.println("<style>");
  client.println("html { font-family: Courier New; display: inline-block; margin: 0px auto; text-align: center;}");
  client.println(".button {border: none; color: blue; padding: 10px 20px; text-align: center;");
  client.println("text-decoration: none; font-size: 25px; margin: 2px; cursor: pointer;}");

  client.println(".joyatick{display: grid; grid-template-rows: 1fr 1fr 1fr; grid-template-column: 1fr 1fr 1fr; gap: 10px}");


  client.println(".forward{grid-row: 1; grid-column: 2;}");
  client.println(".left{grid-row: 2; grid-column: 1;}");
  client.println(".stop{grid-row: 2; grid-column: 2;}");
  client.println(".right{grid-row: 2; grid-column: 3;}");
  client.println(".backward{grid-row: 3; grid-column: 2;}");

  client.println("</style>");
  client.println("</head>");
  
  /* The main body of the Web Page */
  client.println("<body>");
  client.println("<h2>ESP8266 Web Server</h2>");

  client.println("<div class=\"joystic\">");
  client.print("<p><a href=\"/FORWARD\"><button class=\"button forward\">Forward</button></a></p>"); 
  client.print("<p><a href=\"/LEFT\"><button class=\"button left\">Left</button></a></p>");  
  client.print("<p><a href=\"/STOP\"><button class=\"button stop\">Stop</button></a></p>");  
  client.print("<p><a href=\"/RIGHT\"><button class=\"button right\">Right</button></a></p>");  
  client.print("<p><a href=\"/BACKWARD\"><button class=\"button backward\">Backward</button></a></p>");  
  client.println("</div>");
  
  client.println("</body>");
  client.println("</html>");
  client.print("\n");
  
  delay(1);
  /* Close the connection */
  client.stop();
  Serial.println("Client disconnected");
  Serial.print("\n");
}
