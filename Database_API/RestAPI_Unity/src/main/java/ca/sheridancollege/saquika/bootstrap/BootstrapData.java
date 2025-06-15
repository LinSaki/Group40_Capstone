package ca.sheridancollege.saquika.bootstrap;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import ca.sheridancollege.saquika.beans.Therapist;
import ca.sheridancollege.saquika.repositories.TherapistRepository;
import lombok.AllArgsConstructor;

@Component
@AllArgsConstructor
public class BootstrapData implements CommandLineRunner {
	private TherapistRepository tRepo;
	@Override
	public void run(String... args) throws Exception {
        Therapist t1 = Therapist.builder().name("Yadira").licenseNum("k").patientCount(71).build();
        Therapist t2 =Therapist.builder().name("Abbie").licenseNum("g").patientCount(60).build();
        Therapist t3 =Therapist.builder().name("Thaddeus").licenseNum("w").patientCount(96).build();
        Therapist t4 =Therapist.builder().name("Tanner").licenseNum("n").patientCount(85).build();
        Therapist t5 =Therapist.builder().name("Monserrate").licenseNum("p").patientCount(34).build();
        Therapist t6 =Therapist.builder().name("Janae").licenseNum("t").patientCount(19).build();
        Therapist t7 =Therapist.builder().name("Dustin").licenseNum("l").patientCount(50).build();
        Therapist t8 =Therapist.builder().name("Coby").licenseNum("k").patientCount(30).build();
        Therapist t9 = Therapist.builder().name("Jamil").licenseNum("d").patientCount(60).build();
        Therapist t10 =Therapist.builder().name("Amari").licenseNum("0").patientCount(54).build();
		
        tRepo.save(t1);
        tRepo.save(t2);
        tRepo.save(t3);
        tRepo.save(t4);
        tRepo.save(t5);
        tRepo.save(t6);
        tRepo.save(t7);
        tRepo.save(t8);
        tRepo.save(t9);
        tRepo.save(t10);
	}
}
