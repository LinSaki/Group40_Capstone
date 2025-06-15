package ca.sheridancollege.saquika.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.sheridancollege.saquika.beans.Therapist;
import ca.sheridancollege.saquika.repositories.TherapistRepository;
import lombok.AllArgsConstructor;

@RestController 
@AllArgsConstructor
@RequestMapping("/therapist")
@CrossOrigin(origins = "*") // Allow Unity to access API from any domain
public class TherapistController {
	private TherapistRepository sRepo;
	
	//GET for one Therapist
	@GetMapping("/{id}")
	public Therapist getTherapist(@PathVariable long id) {
		Optional<Therapist> therapist = sRepo.findById(id);
		if(therapist.isPresent()) {
			Therapist therapistDetails = therapist.get();
	        return therapistDetails;
		} else
			return null;
	}
	
	//GET for ALL therapists
	@GetMapping(value= {"","/"})
	public List<Therapist> getTherapists(){
		return sRepo.findAll();
	}
	
	//POST new Therapist
	@PostMapping(value={""}, headers= {"Content-type=application/json"})
	public Therapist addTherapist(@RequestBody Therapist therapist) {
		therapist.setId(null);
		return sRepo.save(therapist);
	}
}
