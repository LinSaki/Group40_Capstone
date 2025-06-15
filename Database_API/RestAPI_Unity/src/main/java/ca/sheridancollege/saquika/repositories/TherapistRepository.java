package ca.sheridancollege.saquika.repositories;


import org.springframework.data.jpa.repository.JpaRepository;

import ca.sheridancollege.saquika.beans.Session;
import ca.sheridancollege.saquika.beans.Therapist;

public interface TherapistRepository extends JpaRepository<Therapist, Long> {

	public Session findByName(String name);

}
