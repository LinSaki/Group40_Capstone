package ca.sheridancollege.ngquocth.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.sheridancollege.ngquocth.beans.User;
import ca.sheridancollege.ngquocth.models.AuthenticationRequest;
import ca.sheridancollege.ngquocth.models.AuthenticationResponse;
import ca.sheridancollege.ngquocth.services.AuthenticationService;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthenticationController {

	private final AuthenticationService authenticationService;
	
	
	
	// Register a new user
    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody User user) {
        return ResponseEntity.ok(authenticationService.register(user));
    }

    // Authenticate a user and return JWT token
    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(@RequestBody AuthenticationRequest request) {
        return ResponseEntity.ok(authenticationService.authenticate(request));
    }
	
	
	
	
	
	
	
	
	
}
