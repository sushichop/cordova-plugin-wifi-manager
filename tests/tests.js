exports.defineAutoTests = function () {
  describe('WiFiManager (window.wifiManager)', function () {
    it('should exist', function () {
      expect(window.wifiManager).toBeDefined();
    });
    it('should contain a connect function', function () {
      expect(window.wifiManager.connect).toBeDefined();
      expect(typeof window.wifiManager.connect === 'function').toBe(true);
    });
    it('should contain a disconnect function', function () {
      expect(window.wifiManager.disconnect).toBeDefined();
      expect(typeof window.wifiManager.disconnect === 'function').toBe(true);
    });
  });

  describe('connect method', function () {
    it('should throw with no arguments', function () {
      expect(function () {
        window.wifiManager.connect();
      }).toThrow();
    });
    it('should throw if 1st argument is not string', function () {
      expect(function () {
        window.wifiManager.connect(0, 'TARGET_PASSPHRASE', function () {}, function () {});
      }).toThrow();
    });
    it('should throw if 2nd argument is not string', function () {
      expect(function () {
        window.wifiManager.connect('TARGET_SSID', 1, function () {}, function () {});
      }).toThrow();
    });
    it('should throw if success callback is not function', function () {
      expect(function () {
        window.wifiManager.connect('TARGET_SSID', 'TARGET_PASSPHRASE', 'foo', function () {});
      }).toThrow();
    });
    it('should throw if failure callback is not function', function () {
      expect(function () {
        window.wifiManager.connect('TARGET_SSID', 'TARGET_PASSPHRASE', function () {}, 'bar');
      }).toThrow();
    });
  });

  describe('disconnect method', function () {
    it('should throw with no arguments', function () {
      expect(function () {
        window.wifiManager.disconnect();
      }).toThrow();
    });
    it('should throw if 1st argument is not string', function () {
      expect(function () {
        window.wifiManager.disconnect(undefined, function () {}, function () {});
      }).toThrow();
    });
    it('should throw if success callback is not function', function () {
      expect(function () {
        window.wifiManager.disconnect('TARGET_SSID', 'foo', function () {});
      }).toThrow();
    });
    it('should throw if failure callback is not function', function () {
      expect(function () {
        window.wifiManager.disconnect('TARGET_SSID', function () {}, 'bar');
      }).toThrow();
    });
  });
};
