package br.com.aes.productapi.controllers;

// import org.springframework.web.bind.annotation.RestController;
// import org.springframework.web.bind.annotation.GetMapping;

// @RestController
// public class StatusController {

//   @GetMapping(value = "/")
//   public String getMethodName() {
//     return "Olá Mundo";
//   }

// }

import java.util.HashMap;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class StatusController {

  @GetMapping("status")
  public ResponseEntity<HashMap<String, Object>> getApiStatus() {
    var response = new HashMap<String, Object>();

    response.put("service", "Product-API");
    response.put("status", "up");
    response.put("httpStatus", HttpStatus.OK.value());

    return ResponseEntity.ok(response);
  }

}