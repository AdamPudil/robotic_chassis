
class motor {
public:
  void init(int pinA, int pinB) {
    this->pinA = pinA;controll esp 8266 over wifi
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

void setup() {
  left.init(15, 13);
  right.init(12, 14);

}

void loop() {
  delay(1000);
  left.spin(1);
  delay(1000);
  left.stop();
  delay(1000);
  left.spin(0);
  delay(1000);
  left.stop();

  delay(1000);
  right.spin(1);
  delay(1000);
  right.stop();
  delay(1000);
  right.spin(0);
  delay(1000);
  right.stop();
}
