package ca.sheridancollege.ngquocth.models;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class PatientSessionBookingRequest {
    private Long therapistId;
    private Long scenarioId;
    private LocalDateTime sessionDate;
    private Integer sessionDuration;
    private String feedback;
}
