package ca.sheridancollege.saquika.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import ca.sheridancollege.saquika.beans.Session;

public interface SessionRepository extends JpaRepository<Session, Long> {

}
