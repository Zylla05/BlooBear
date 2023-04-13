import "package:google_maps_flutter/google_maps_flutter.dart";

const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "MX",
      "currencyCode": "MXN"
    }
  }
}''';

const server = "http://10.14.1.157:3000";

const kata = "http://10.14.1.157:4000";

var token = "";

var correo = "";

var nombre = "";

var code = "";

var ubiac = LatLng(0, 0);

var id = 0;

var mkey = "";
