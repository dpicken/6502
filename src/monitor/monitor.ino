struct CpuPinToArduinoPin {
  using value_type = unsigned int;

  static value_type a(value_type addressLine) {
    return 52 - (addressLine * 2);
  }

  static value_type d(value_type dataLine) {
    return 53 - (dataLine * 2);
  }

  static value_type rwb() {
    return 3;
  }

  static value_type phi2() {
    return 2;
  }
};

class CpuMonitor {
  static const unsigned int AddressLineCount = 16;
  static const unsigned int DataLineCount = 8;

  CpuMonitor() {
    for (unsigned int line = 0; line < AddressLineCount; ++line) {
      pinMode(CpuPinToArduinoPin::a(line), INPUT);
    }
    for (unsigned int line = 0; line < DataLineCount; ++line) {
      pinMode(CpuPinToArduinoPin::d(line), INPUT);
    }
    pinMode(CpuPinToArduinoPin::rwb(), INPUT);
  }

  unsigned int readAddressBus() {
    unsigned int address = 0;
    for (unsigned int line = 0; line < AddressLineCount; ++line) {
      if (digitalRead(CpuPinToArduinoPin::a(line))) {
        address |= (1U << line);
      }
    }
    return address;
  }

  unsigned int readDataBus() {
    unsigned int data = 0;
    for (unsigned int line = 0; line < DataLineCount; ++line) {
      if (digitalRead(CpuPinToArduinoPin::d(line))) {
        data |= (1U << line);
      }
    }
    return data;
  }

  bool readRwb() {
    return digitalRead(CpuPinToArduinoPin::rwb());
  }

public:
  CpuMonitor(const CpuMonitor&) = delete;
  CpuMonitor& operator=(const CpuMonitor&) = delete;

  static CpuMonitor& instance() {
    static CpuMonitor instance;
    return instance;
  }

  void poll() {
    unsigned int address = readAddressBus();
    unsigned int data = readDataBus();
    char rw = readRwb() ? 'r' : 'W';

    char output[10];
    snprintf(output, sizeof(output), "%04x %c %02x", address, rw, data);
    Serial.println(output);
  }
};

class Poller {
  Poller() {
    pinMode(CpuPinToArduinoPin::phi2(), INPUT);
    attachInterrupt(digitalPinToInterrupt(CpuPinToArduinoPin::phi2()), onInterrupt, RISING);
  }

public:
  Poller(const Poller&) = delete;
  Poller& operator=(const Poller&) = delete;

  static Poller& instance() {
    static Poller instance;
    return instance;
  }

  static void onInterrupt() {
    CpuMonitor::instance().poll();
  }
};

void setup() {
  Poller::instance();
  Serial.begin(57600);
}

void loop() {
}
