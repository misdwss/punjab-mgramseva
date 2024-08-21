package org.egov.wscalculation.web.models;

import lombok.*;
import org.springframework.validation.annotation.Validated;

import java.sql.Timestamp;

@Validated
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Builder
public class BulkDemandCall {
    private String id;
    private String tenantId;
    private String billingPeriod;
    private Timestamp createdTime;
    private String status;

}
