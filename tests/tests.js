'use strict';

const defineAutoTests = () => {
  describe('WiFiManager (window.wifiManager)', () => {
    it('should exist', () => {
      expect(window.wifiManager).toBeDefined();
    });
    it('should contain a connect function', () => {
      expect(window.wifiManager.connect).toBeDefined();
      expect(typeof window.wifiManager.connect === 'function').toBe(true);
    });
    it('should contain a disconnect function', () => {
      expect(window.wifiManager.disconnect).toBeDefined();
      expect(typeof window.wifiManager.disconnect === 'function').toBe(true);
    });
  });

  describe('connect method', () => {
    it('should throw with no arguments', () => {
      expect(() => {
        window.wifiManager.connect();
      }).toThrow();
    });
    it('should throw if 1st argument is not string', () => {
      expect(() => {
        window.wifiManager.connect(
          0,
          'TARGET_PASSPHRASE',
          () => {},
          () => {}
        );
      }).toThrow();
    });
    it('should throw if 2nd argument is not string', () => {
      expect(() => {
        window.wifiManager.connect(
          'TARGET_SSID',
          1,
          () => {},
          () => {}
        );
      }).toThrow();
    });
    it('should throw if success callback is not function', () => {
      expect(() => {
        window.wifiManager.connect('TARGET_SSID', 'TARGET_PASSPHRASE', 'foo', () => {});
      }).toThrow();
    });
    it('should throw if failure callback is not function', () => {
      expect(() => {
        window.wifiManager.connect('TARGET_SSID', 'TARGET_PASSPHRASE', () => {}, 'bar');
      }).toThrow();
    });
  });

  describe('disconnect method', () => {
    it('should throw with no arguments', () => {
      expect(() => {
        window.wifiManager.disconnect();
      }).toThrow();
    });
    it('should throw if 1st argument is not string', () => {
      expect(() => {
        window.wifiManager.disconnect(
          undefined,
          () => {},
          () => {}
        );
      }).toThrow();
    });
    it('should throw if success callback is not function', () => {
      expect(() => {
        window.wifiManager.disconnect('TARGET_SSID', 'foo', () => {});
      }).toThrow();
    });
    it('should throw if failure callback is not function', () => {
      expect(() => {
        window.wifiManager.disconnect('TARGET_SSID', () => {}, 'bar');
      }).toThrow();
    });
  });
};

exports.defineAutoTests = defineAutoTests;
