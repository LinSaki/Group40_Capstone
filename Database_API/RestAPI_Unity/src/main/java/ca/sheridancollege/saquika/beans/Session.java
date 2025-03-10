package ca.sheridancollege.saquika.beans;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Transient;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Session {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	private String sessionDate;
	 // Step 9 - we are using Many to One relationship now
	@Transient
	private String therapistName; 
	
//	
//	@ManyToOne
//	@JsonIgnore
//    @JoinColumn(name = "store_id") // this will be the foreign key in the Item table
//    private Store store;
//	
//	
//	public String getStoreName() {
//	    if (store != null) {
//	        return store.getName(); // Return the Store's name if it's set
//	    }
//	    return storeName; // Otherwise, return the received JSON value
//	    	//I HAD THIS AS NULL BEFORE
//	}
//	
//	public void setStoreName(String storeName) {
//        this.storeName = storeName;
//    }
//
//    public void setStore(Store store) {
//        this.store = store;
//    }
	
	
}
