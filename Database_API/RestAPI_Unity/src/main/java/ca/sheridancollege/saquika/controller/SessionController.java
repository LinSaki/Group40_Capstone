package ca.sheridancollege.saquika.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.sheridancollege.saquika.beans.Session;
import ca.sheridancollege.saquika.repositories.SessionRepository;
import ca.sheridancollege.saquika.repositories.TherapistRepository;
import lombok.AllArgsConstructor;

@RestController 
@AllArgsConstructor
@RequestMapping("/sessions")
public class SessionController {
	private SessionRepository iRepo;
	private TherapistRepository sRepo;
	
	//Get for 1 session
	@GetMapping("/{id}")
	public Session getStore(@PathVariable long id) {
		Optional<Session> session = iRepo.findById(id);
		if(session.isPresent()) {
			return session.get();
		} else
			return null;
	}
	
	//Get for ALL sessions
	@GetMapping(value= {"","/"})
	public List<Session> getSessions(){
		return iRepo.findAll();
	}
//	//Post new session
//	@PostMapping(value={"","/"}, headers= {"Content-type=application/json"})
//	public Session addSession(@RequestBody Session session) {
//		session.setId(null);
//		System.out.println("THE Session NAME IS: " + session.getName());
//		System.out.println("THE STORE NAME IS: " + session.getStoreName());
//	    if (session.getStoreName() != null && !session.getStoreName().isEmpty()) {
//	        Store store = sRepo.findByName(session.getStoreName()); // Find store by name
//	        if (store != null) {
//	            session.setStore(store); // Set the found store to the session
//	            System.out.println("Store found: " + store.getName());
//	        } else {
//	            System.out.println("Store not found: " + session.getStoreName());
//	            session.setStore(null); // Set store to null if not found
//	        }
//	    } else {
//	        System.out.println("No storeName provided.");
//	    }
//		return iRepo.save(session);
//	}
//	
//	//Put edit session
//	@PutMapping(value={"/{id}"}, headers={"Content-type=application/json"}) //CRUD - UPDATE
//	public Session updateSession(@RequestBody Session session, @PathVariable long id) {
//		session.setId(id);
//		if (session.getStoreName() != null && !session.getStoreName().isEmpty()) {
//	        Store store = sRepo.findByName(session.getStoreName()); // Find store by name
//	        if (store != null) {
//	            session.setStore(store); // Set the found store to the session
//	            System.out.println("Store found: " + store.getName());
//	        } else {
//	            System.out.println("Store not found: " + session.getStoreName());
//	            session.setStore(null); // Set store to null if not found
//	        }
//	    } else {
//	        System.out.println("No storeName provided.");
//	    }
//		return iRepo.save(session);
//	}
	
	//Delete session
	@DeleteMapping(value={"{id}"}) //CRUD - DELETE - don't need headers,  we are not SENDING info
	public void deleteSession(@PathVariable long id) {
		Optional<Session> session = iRepo.findById(id);
		if(session.isPresent()) {
			iRepo.deleteById(id);
		}
	}
}
