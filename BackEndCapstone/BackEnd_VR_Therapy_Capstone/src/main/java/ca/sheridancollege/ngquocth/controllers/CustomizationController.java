package ca.sheridancollege.ngquocth.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.sheridancollege.ngquocth.beans.Customization;
import ca.sheridancollege.ngquocth.beans.Scenario;
import ca.sheridancollege.ngquocth.beans.TherapistProfile;
import ca.sheridancollege.ngquocth.repositories.CustomizationRepository;
import ca.sheridancollege.ngquocth.repositories.ScenarioRepository;
import ca.sheridancollege.ngquocth.repositories.TherapistProfileRepository;
import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
@RequestMapping("/api/therapists/customizations")
public class CustomizationController {

	//THIS CONTROLLER FOR THERAPIST ONLY
	
	
	private final CustomizationRepository customizationRepo;
    private final TherapistProfileRepository therapistRepo;
    private final ScenarioRepository scenarioRepo;

    // Get all customizations (optional, usually internal use)
    @GetMapping(value = {"", "/"})
    public List<Customization> getAllCustomizations() {
        return customizationRepo.findAll();
    }

    // Therapist: View their own customizations
    @GetMapping("/my-customizations")
    public ResponseEntity<List<Customization>> getOwnCustomizations(@AuthenticationPrincipal UserDetails userDetails) {
        List<Customization> customizations = customizationRepo.findByTherapist_Email(userDetails.getUsername());
        return ResponseEntity.ok(customizations);
    }

    // Therapist: Create a customization for a scenario
    @PostMapping(value = {""}, headers = {"Content-type=application/json"})
    public ResponseEntity<?> addCustomization(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody Map<String, Object> payload) {

        TherapistProfile therapist = therapistRepo.findByEmail(userDetails.getUsername())
            .orElseThrow(() -> new RuntimeException("Therapist not found"));

        if (!payload.containsKey("scenarioId") || !payload.containsKey("changesDescription")) {
            return ResponseEntity.badRequest().body("Missing required fields: scenarioId and changesDescription.");
        }

        Long scenarioId;
        try {
            scenarioId = Long.valueOf(payload.get("scenarioId").toString());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Invalid scenarioId format.");
        }

        String description = payload.get("changesDescription").toString().trim();
        if (description.isEmpty()) {
            return ResponseEntity.badRequest().body("Description must not be empty.");
        }

        Scenario scenario = scenarioRepo.findById(scenarioId)
            .orElseThrow(() -> new RuntimeException("Scenario not found"));

        Customization customization = Customization.builder()
            .therapist(therapist)
            .scenario(scenario)
            .changesDescription(description)
            .build();

        Customization savedCustomization = customizationRepo.save(customization);
        return ResponseEntity.ok(savedCustomization);
    }

    // Therapist: Update their own customization
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCustomization(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody Customization updatedCustomization) {

        TherapistProfile therapist = therapistRepo.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("Therapist not found"));

        Customization existingCustomization = customizationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Customization not found"));

        if (!existingCustomization.getTherapist().getUserId().equals(therapist.getUserId())) {
            return ResponseEntity.status(403).body("You can only edit your own customizations.");
        }

        existingCustomization.setChangesDescription(updatedCustomization.getChangesDescription());
        customizationRepo.save(existingCustomization);

        return ResponseEntity.ok(existingCustomization);
    }

    // Therapist: Delete their own customization
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCustomization(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails) {

        TherapistProfile therapist = therapistRepo.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("Therapist not found"));

        Customization existingCustomization = customizationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Customization not found"));

        if (!existingCustomization.getTherapist().getUserId().equals(therapist.getUserId())) {
            return ResponseEntity.status(403).body("You can only delete your own customizations.");
        }

        customizationRepo.delete(existingCustomization);
        return ResponseEntity.ok("Customization deleted successfully.");
    }
    
    
    
    
    
}
