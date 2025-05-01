package ca.sheridancollege.ngquocth.models;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class TherapistSessionBookingRequest {
    private Long patientId;
    private Long scenarioId;
    private LocalDateTime sessionDate;
    private Integer sessionDuration;
    private String feedback;
}
